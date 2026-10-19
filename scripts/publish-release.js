// Helper: create the GitHub release for the current package.json version and upload assets.
// Usage: LANTING_GITHUB_TOKEN=... node scripts/publish-release.js
const fs = require('node:fs');
const path = require('node:path');

const pkg = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'package.json'), 'utf8'));
const VERSION = pkg.version;
const TOKEN = process.env.LANTING_GITHUB_TOKEN;
const OWNER = 'Nivalia';
const REPO = 'LanTing';
const TAG = `v${VERSION}`;
const RELEASE_NAME = `LanTing ${VERSION}`;
const PROXY = process.env.LANTING_PROXY || 'http://127.0.0.1:9674';

const root = path.resolve(__dirname, '..');
const bodyText = fs.readFileSync(path.join(root, 'docs', `RELEASE_NOTES_v${VERSION}.md`), 'utf8');
const assets = [
  { file: path.join(root, 'dist', `LanTing-${VERSION}-Setup.exe`), name: `LanTing-${VERSION}-Setup.exe` },
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
