// Capture the real LanTing splash screen for the README hero image.
// Usage: npx electron scripts/capture-readme-splash.js [outputPath]
const { app, BrowserWindow } = require('electron');
const path = require('node:path');
const fs = require('node:fs');

const root = path.resolve(__dirname, '..');
const output = process.argv[2] || path.join(root, 'docs', 'assets', 'readme', 'cinema-beat-smoke.png');
const WIDTH = 1280;
const HEIGHT = 720;
const DEADLINE_MS = 90000;

function log(msg) {
  process.stdout.write(`[capture] ${msg}\n`);
}

async function poll(win) {
  const started = Date.now();
  let fontsDone = false;
  while (Date.now() - started < DEADLINE_MS) {
    try {
      const state = await win.webContents.executeJavaScript(`(function () {
        var splash = document.getElementById('splash');
        return {
          fonts: document.fonts ? document.fonts.status : 'unknown',
          loaded: document.fonts ? document.fonts.size : 0,
          splashReady: !!(splash && splash.classList.contains('ready')),
          splashGone: !!(splash && (splash.classList.contains('hide') || splash.style.display === 'none')),
          now: Math.round(performance.now()),
          wordmark: (document.querySelector('.splash-wordmark') || {}).innerText || ''
        };
      })()`);
      if (!fontsDone && state.fonts === 'loaded') {
        fontsDone = true;
        log(`fonts loaded (${state.loaded} faces) at ${state.now}ms`);
      }
      // Wordmark animation runs 5200ms; capture after it settles and the
      // "点击进入" ready state is on, while the splash is still visible.
      if (fontsDone && state.splashReady && state.now > 6500 && !state.splashGone) {
        log(`ready: fonts=${state.fonts} now=${state.now}ms wordmark=${JSON.stringify(state.wordmark)}`);
        return;
      }
      if (state.splashGone) throw new Error('splash disappeared before capture');
    } catch (err) {
      if (String(err.message).includes('splash disappeared')) throw err;
      // page may still be wiring up; retry
    }
    await new Promise((r) => setTimeout(r, 400));
  }
  throw new Error('timed out waiting for splash capture state');
}

async function main() {
  const win = new BrowserWindow({
    width: WIDTH,
    height: HEIGHT,
    useContentSize: true,
    show: true,
    frame: false,
    resizable: false,
    backgroundColor: '#000000',
    webPreferences: {
      contextIsolation: false,
      nodeIntegration: false,
      sandbox: true,
    },
  });

  win.setMenuBarVisibility(false);
  await win.loadFile(path.join(root, 'public', 'index.html'));
  log('page loaded');

  await poll(win);
  // Let the final animation frames composite.
  await new Promise((r) => setTimeout(r, 1200));

  const image = await win.webContents.capturePage();
  const png = image.toPNG();
  fs.writeFileSync(output, png);
  log(`saved ${output} (${image.getSize().width}x${image.getSize().height}, ${png.length} bytes)`);

  win.destroy();
  app.quit();
}

app.whenReady().then(() => {
  main().catch((err) => {
    log(`FAILED: ${err.message}`);
    app.exit(1);
  });
});

app.on('window-all-closed', () => app.quit());
