function lantingCacheStorageNode(id) {
  return document.getElementById(id);
}

function formatLanTingCacheBytes(value) {
  var bytes = Math.max(0, Number(value) || 0);
  if (bytes < 1024) return bytes + ' B';
  var units = ['KB', 'MB', 'GB', 'TB'];
  var index = -1;
  do {
    bytes /= 1024;
    index += 1;
  } while (bytes >= 1024 && index < units.length - 1);
  return (bytes >= 100 || index === 0 ? bytes.toFixed(0) : bytes.toFixed(1)) + ' ' + units[index];
}

function setLanTingCacheStorageText(id, value) {
  var node = lantingCacheStorageNode(id);
  if (node) node.textContent = value == null || value === '' ? '—' : String(value);
}

function applyLanTingCacheSettings(snapshot) {
  if (!snapshot || !snapshot.ok) {
    setLanTingCacheStorageText('cache-storage-total', '读取失败');
    setLanTingCacheStorageText('cache-storage-note', snapshot && snapshot.error ? ('缓存设置不可用：' + snapshot.error) : '缓存设置不可用');
    return;
  }
  var settings = snapshot.settings || {};
  var usage = snapshot.usage || {};
  setLanTingCacheStorageText('cache-storage-root', settings.rootPath);
  setLanTingCacheStorageText('cache-storage-total', '已占用 ' + formatLanTingCacheBytes(usage.totalManagedBytes));
  setLanTingCacheStorageText('cache-storage-lyrics-path', settings.lyricsPath);
  setLanTingCacheStorageText('cache-storage-lyrics-size', formatLanTingCacheBytes(usage.lyricsBytes));
  setLanTingCacheStorageText('cache-storage-chromium-path', settings.activeChromiumPath || settings.chromiumPath);
  setLanTingCacheStorageText('cache-storage-chromium-size', formatLanTingCacheBytes(usage.chromiumBytes));
  setLanTingCacheStorageText('cache-storage-beatmaps-path', settings.activeBeatmapsPath || settings.beatmapsPath);
  setLanTingCacheStorageText('cache-storage-beatmaps-size', formatLanTingCacheBytes(usage.beatmapsBytes));
  setLanTingCacheStorageText('cache-storage-wallpaper-path', settings.activeWallpaperEnginePath || settings.wallpaperEnginePath);
  setLanTingCacheStorageText('cache-storage-wallpaper-size', formatLanTingCacheBytes(usage.wallpaperEngineBytes));
  setLanTingCacheStorageText('cache-storage-userdata-path', settings.userDataPath || '系统安全数据目录');
  setLanTingCacheStorageText('cache-storage-userdata-size', formatLanTingCacheBytes(usage.userDataBytes));
  var restartButton = lantingCacheStorageNode('cache-storage-restart');
  if (restartButton) restartButton.hidden = !settings.restartRequired;
  setLanTingCacheStorageText(
    'cache-storage-note',
    settings.restartRequired
      ? '歌词缓存已切换；封面、网络、音频分片、节奏分析与 WE 静音场景将在重启后改用新目录。'
      : '歌词缓存立即生效；封面、网络、音频分片、节奏分析与 WE 静音场景已使用此目录。'
  );
}

function refreshLanTingCacheSettings() {
  if (!window.desktopWindow || typeof window.desktopWindow.getCacheSettings !== 'function') {
    applyLanTingCacheSettings({ ok: false, error: '仅桌面版支持本地缓存路径设置' });
    return Promise.resolve();
  }
  setLanTingCacheStorageText('cache-storage-total', '正在统计...');
  return window.desktopWindow.getCacheSettings().then(applyLanTingCacheSettings).catch(function (error) {
    applyLanTingCacheSettings({ ok: false, error: error && error.message || '读取失败' });
  });
}

function chooseLanTingCacheRoot() {
  if (!window.desktopWindow || typeof window.desktopWindow.chooseCacheDirectory !== 'function') return;
  window.desktopWindow.chooseCacheDirectory().then(function (choice) {
    if (!choice || !choice.ok || choice.canceled || !choice.rootPath) return;
    return window.desktopWindow.setCacheSettings({ rootPath: choice.rootPath });
  }).then(function (snapshot) {
    if (snapshot) applyLanTingCacheSettings(snapshot);
  }).catch(function (error) {
    applyLanTingCacheSettings({ ok: false, error: error && error.message || '保存失败' });
  });
}

function restartLanTingForCachePath() {
  if (!window.desktopWindow || typeof window.desktopWindow.restartApp !== 'function') return;
  window.desktopWindow.restartApp();
}

setTimeout(refreshLanTingCacheSettings, 450);
