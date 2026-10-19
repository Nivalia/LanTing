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