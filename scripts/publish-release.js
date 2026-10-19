// One-off helper: create the v2.2.0 GitHub release and upload assets.
// Usage: node scripts/publish-release.js
const fs = require('node:fs');
const path = require('node:path');

const TOKEN = process.env.LANTING_GITHUB_TOKEN;
const OWNER = 'Nivalia';
const REPO = 'LanTing';
const TAG = 'v2.2.0';
const RELEASE_NAME = 'LanTing 2.2.0';
const PROXY = process.env.LANTING_PROXY || 'http://127.0.0.1:9674';

const root = path.resolve(__dirname, '..');
const bodyText = fs.readFileSync(path.join(root, 'docs', 'RELEASE_NOTES_v2.2.0.md'), 'utf8');
const assets = [
  { file: path.join(root, 'dist', 'LanTing-2.2.0-Setup.exe'), name: 'LanTing-2.2.0-Setup.exe' },
  { file: path.join(root, 'docs', 'update', 'latest.yml'), name: 'latest.yml' },
];

async function api(url, init = {}) {
  const res = await fetch(url, {
    ...init,
    dispatcher: undefined,
    headers: {
      Authorization: `token ${TOKEN}`,
      Accept: 'application/vnd.github+json',
      'User-Agent': 'LanTing-release-script',
      ...(init.headers || {}),
    },
  });
  const text = await res.text();
  let json = null;
  try { json = JSON.parse(text); } catch (_) {}
  if (!res.ok) {
    throw new Error(`HTTP ${res.status} ${url}\n${text.slice(0, 800)}`);
  }
  return json;
}

async function main() {
  if (!TOKEN) throw new Error('set LANTING_GITHUB_TOKEN');

  // Release may already exist (idempotent retry).
  let release;
  try {
    release = await api(`https://api.github.com/repos/${OWNER}/${REPO}/releases/tags/${TAG}`);
    console.log(`release exists id=${release.id}`);
  } catch (err) {
    if (!String(err.message).includes('HTTP 404')) throw err;
  }

  if (!release) {
    release = await api(`https://api.github.com/repos/${OWNER}/${REPO}/releases`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        tag_name: TAG,
        target_commitish: 'main',
        name: RELEASE_NAME,
        body: bodyText,
        draft: false,
        prerelease: false,
        generate_release_notes: false,
      }),
    });
    console.log(`created release id=${release.id} url=${release.html_url}`);
  }

  for (const asset of assets) {
    const existing = (release.assets || []).find((a) => a.name === asset.name);
    if (existing) {
      console.log(`asset already present: ${asset.name} id=${existing.id}`);
      continue;
    }
    const buf = fs.readFileSync(asset.file);
    const res = await fetch(
      `https://uploads.github.com/repos/${OWNER}/${REPO}/releases/${release.id}/assets?name=${encodeURIComponent(asset.name)}`,
      {
        method: 'POST',
        headers: {
          Authorization: `token ${TOKEN}`,
          'Content-Type': 'application/octet-stream',
          'Content-Length': String(buf.length),
          'User-Agent': 'LanTing-release-script',
        },
        body: buf,
      }
    );
    const text = await res.text();
    if (!res.ok) throw new Error(`upload failed ${asset.name}: HTTP ${res.status}\n${text.slice(0, 500)}`);
    const json = JSON.parse(text);
    console.log(`uploaded ${asset.name} id=${json.id} size=${json.size}`);
  }

  const final = await api(`https://api.github.com/repos/${OWNER}/${REPO}/releases/${release.id}`);
  console.log('--- final ---');
  console.log(`url=${final.html_url} tag=${final.tag_name} assets=${final.assets.map((a) => a.name).join(', ')}`);
}

main().catch((err) => {
  console.error(err.message || err);
  process.exit(1);
});
