const { contextBridge, ipcRenderer, clipboard, webUtils } = require('electron');

contextBridge.exposeInMainWorld('desktopWindow', {
  isDesktop: true,
  minimize: () => ipcRenderer.invoke('desktop-window-minimize'),
  restore: () => ipcRenderer.invoke('desktop-window-restore'),
  toggleMaximize: () => ipcRenderer.invoke('desktop-window-toggle-maximize'),
  toggleFullscreen: () => ipcRenderer.invoke('desktop-window-toggle-fullscreen'),
  exitFullscreenWindowed: () => ipcRenderer.invoke('desktop-window-exit-fullscreen-windowed'),
  getState: () => ipcRenderer.invoke('desktop-window-get-state'),
  getGpuDiagnostics: () => ipcRenderer.invoke('lanting-get-gpu-diagnostics'),
  getMemorySnapshot: () => ipcRenderer.invoke('lanting-memory-get-snapshot'),
  configureMemoryReduct: (payload) => ipcRenderer.invoke('lanting-memory-configure-auto', payload || {}),
  trimAppMemory: (payload) => ipcRenderer.invoke('lanting-memory-trim-app', payload || {}),
  purgeSystemMemory: (payload) => ipcRenderer.invoke('lanting-memory-purge-system', payload || {}),
  getCacheSettings: () => ipcRenderer.invoke('lanting-cache-get-settings'),
  chooseCacheDirectory: () => ipcRenderer.invoke('lanting-cache-choose-directory'),
  setCacheSettings: (payload) => ipcRenderer.invoke('lanting-cache-set-settings', payload || {}),
  listWallpaperEngineProjects: (payload) => ipcRenderer.invoke('lanting-wallpaper-engine-list', payload || {}),
  getWallpaperEngineProjectDetails: (id) => ipcRenderer.invoke('lanting-wallpaper-engine-project-details', String(id || '')),
  openWallpaperEngineProjectDetails: (id, target) => ipcRenderer.invoke('lanting-wallpaper-engine-open-project-details', {
    id: String(id || ''),
    target: target === 'workshop' ? 'workshop' : 'we',
  }),
  chooseWallpaperEngineDirectory: () => ipcRenderer.invoke('lanting-wallpaper-engine-choose-directory'),
  chooseWallpaperEngineProjectFile: () => ipcRenderer.invoke('lanting-wallpaper-engine-choose-project-file'),
  removeWallpaperEngineDirectory: (rootId) => ipcRenderer.invoke('lanting-wallpaper-engine-remove-directory', String(rootId || '')),
  getWallpaperEngineRuntimeStatus: (payload) => ipcRenderer.invoke('lanting-wallpaper-engine-runtime-status', payload || {}),
  startWallpaperEngineScene: (payload) => ipcRenderer.invoke('lanting-wallpaper-engine-start-scene', payload || {}),
  reportWallpaperEngineCaptureResult: (payload) => ipcRenderer.invoke('lanting-wallpaper-engine-capture-result', payload || {}),
  prepareWallpaperEngineGlassCapture: (payload) => ipcRenderer.invoke('lanting-wallpaper-engine-prepare-glass-capture', payload || {}),
  activateWallpaperEngineDwmSurface: (payload) => ipcRenderer.invoke('lanting-wallpaper-engine-activate-dwm-surface', payload || {}),
  updateWallpaperEngineGlassSurface: (payload) => ipcRenderer.send('lanting-wallpaper-engine-glass-surface', payload || {}),
  updateWallpaperEngineVisualSettings: (payload) => ipcRenderer.send('lanting-wallpaper-engine-visual-settings', payload || {}),
  reportWallpaperEnginePointerActivity: (payload) => ipcRenderer.send('lanting-wallpaper-engine-pointer-activity', payload || {}),
  stopWallpaperEngineScene: (payload) => ipcRenderer.invoke('lanting-wallpaper-engine-stop-scene', payload || {}),
  onWallpaperEngineHostBoundsChanged: (callback) => {
    if (typeof callback !== 'function') return () => {};
    const listener = (_event, payload) => callback(payload || {});
    ipcRenderer.on('lanting-wallpaper-engine-host-bounds-changed', listener);
    return () => ipcRenderer.removeListener('lanting-wallpaper-engine-host-bounds-changed', listener);
  },
  listLocalMusicLibrary: () => ipcRenderer.invoke('lanting-local-library-list'),
  readLocalMusicLyric: (localFileId) => ipcRenderer.invoke('lanting-local-library-lyric', String(localFileId || '')),
  listBuiltInPlaylists: () => ipcRenderer.invoke('lanting-built-in-playlists-list'),
  readBuiltInPlaylist: (id, options) => ipcRenderer.invoke('lanting-built-in-playlist-page', String(id || ''), options || {}),
  createBuiltInPlaylist: (name) => ipcRenderer.invoke('lanting-built-in-playlist-create', String(name || '')),
  renameBuiltInPlaylist: (id, name) => ipcRenderer.invoke('lanting-built-in-playlist-rename', String(id || ''), String(name || '')),
  deleteBuiltInPlaylist: (id) => ipcRenderer.invoke('lanting-built-in-playlist-delete', String(id || '')),
  addBuiltInPlaylistTrack: (id, track) => ipcRenderer.invoke('lanting-built-in-playlist-add-track', String(id || ''), track || {}),
  removeBuiltInPlaylistTrack: (id, index) => ipcRenderer.invoke('lanting-built-in-playlist-remove-track', String(id || ''), Number(index)),
  reorderBuiltInPlaylistTrack: (id, fromIndex, toIndex) => ipcRenderer.invoke('lanting-built-in-playlist-reorder-track', String(id || ''), Number(fromIndex), Number(toIndex)),
  importLocalMusicFiles: async (files) => {
    const entries = [];
    for (const file of Array.from(files || [])) {
      let filePath = '';
      try {
        filePath = webUtils && typeof webUtils.getPathForFile === 'function' ? webUtils.getPathForFile(file) : '';
      } catch (_) {}
      if (!filePath) continue;
      entries.push({
        path: filePath,
        relativePath: String(file && (file.webkitRelativePath || file.name) || ''),
      });
    }
    if (!entries.length) return { ok: false, count: 0, tracks: [], error: 'NO_AUTHORIZED_LOCAL_AUDIO' };
    const authorization = await ipcRenderer.invoke('lanting-local-library-authorize', { files: entries });
    if (!authorization || authorization.ok !== true || !authorization.token) return authorization;
    return ipcRenderer.invoke('lanting-local-library-import', { token: authorization.token });
  },
  readLyricCache: (key) => ipcRenderer.invoke('lanting-cache-read-lyric', key || ''),
  writeLyricCache: (key, payload) => ipcRenderer.invoke('lanting-cache-write-lyric', key || '', payload || {}),
  close: (behavior) => ipcRenderer.invoke('desktop-window-close', behavior),
  getCloseBehavior: () => ipcRenderer.invoke('desktop-window-get-close-behavior'),
  setCloseBehavior: (behavior) => ipcRenderer.invoke('desktop-window-set-close-behavior', behavior),
  getLoginEasterEggStatus: () => ipcRenderer.invoke('lanting-login-easter-egg-status'),
  unlockLoginEasterEgg: (value) => ipcRenderer.invoke('lanting-login-easter-egg-unlock', String(value || '')),
  resetLoginEasterEgg: () => ipcRenderer.invoke('lanting-login-easter-egg-reset'),
  openNeteaseMusicLogin: () => ipcRenderer.invoke('netease-music-open-login'),
  clearNeteaseMusicLogin: () => ipcRenderer.invoke('netease-music-clear-login'),
  openQQMusicLogin: (options) => ipcRenderer.invoke('qq-music-open-login', options || {}),
  clearQQMusicLogin: () => ipcRenderer.invoke('qq-music-clear-login'),
  openKugouMusicLogin: (options) => ipcRenderer.invoke('kugou-music-open-login', options || {}),
  clearKugouMusicLogin: () => ipcRenderer.invoke('kugou-music-clear-login'),
  clearQishuiMusicLogin: () => ipcRenderer.invoke('qishui-music-clear-login'),
  openSpotifyMusicLogin: () => ipcRenderer.invoke('spotify-music-open-login'),
  verifySpotifyMusicSetup: () => ipcRenderer.invoke('spotify-music-verify-setup'),
  clearSpotifyMusicLogin: () => ipcRenderer.invoke('spotify-music-clear-login'),
  openUpdatePage: (url) => ipcRenderer.invoke('lanting-open-update-page', String(url || '')),
  restartApp: () => ipcRenderer.invoke('lanting-restart-app'),
  configureGlobalHotkeys: (bindings) => ipcRenderer.invoke('lanting-hotkeys-configure-global', bindings || []),
  copyText: (text) => {
    clipboard.writeText(String(text || ''));
    return { ok: true };
  },
  readText: () => ({ ok: true, text: clipboard.readText() || '' }),
  exportJsonFile: (payload) => ipcRenderer.invoke('lanting-export-json-file', payload || {}),
  exportLoginCookie: (provider) => ipcRenderer.invoke('lanting-export-login-cookie', provider || ''),
  importJsonFile: () => ipcRenderer.invoke('lanting-import-json-file'),
  readCurrentFxAutosaveSync: () => ipcRenderer.sendSync('lanting-current-fx-autosave-read-sync'),
  saveCurrentFxAutosaveSync: (payload) => ipcRenderer.sendSync('lanting-current-fx-autosave-save-sync', payload || {}),
  saveCurrentFxAutosave: (payload) => ipcRenderer.invoke('lanting-current-fx-autosave-save', payload || {}),
  onGlobalHotkey: (callback) => {
    if (typeof callback !== 'function') return () => {};
    const listener = (_event, payload) => callback(payload || {});
    ipcRenderer.on('lanting-global-hotkey', listener);
    return () => ipcRenderer.removeListener('lanting-global-hotkey', listener);
  },
  setDesktopLyricsEnabled: (enabled, payload) => ipcRenderer.invoke('lanting-desktop-lyrics-set-enabled', !!enabled, payload || {}),
  updateDesktopLyrics: (payload) => ipcRenderer.invoke('lanting-desktop-lyrics-update', payload || {}),
  onDesktopLyricsLockState: (callback) => {
    if (typeof callback !== 'function') return () => {};
    const listener = (_event, payload) => callback(payload || {});
    ipcRenderer.on('lanting-desktop-lyrics-lock-state', listener);
    return () => ipcRenderer.removeListener('lanting-desktop-lyrics-lock-state', listener);
  },
  onDesktopLyricsEnabledState: (callback) => {
    if (typeof callback !== 'function') return () => {};
    const listener = (_event, payload) => callback(payload || {});
    ipcRenderer.on('lanting-desktop-lyrics-enabled-state', listener);
    return () => ipcRenderer.removeListener('lanting-desktop-lyrics-enabled-state', listener);
  },
  setWallpaperMode: (enabled, payload) => ipcRenderer.invoke('lanting-wallpaper-set-enabled', !!enabled, payload || {}),
  updateWallpaperMode: (payload) => ipcRenderer.invoke('lanting-wallpaper-update', payload || {}),
  getWallpaperModeStatus: () => ipcRenderer.invoke('lanting-wallpaper-get-status'),
  requestGestureCameraPermission: () => ipcRenderer.invoke('lanting-gesture-camera-request-permission'),
  updateDesktopIconShields: (payload) => ipcRenderer.send('lanting-full-desktop-icon-shields', payload || {}),
  setDesktopSoftwareLocked: (locked) => ipcRenderer.invoke('lanting-full-desktop-set-software-lock', locked === true),
  setDesktopIconsVisible: (visible) => ipcRenderer.invoke('lanting-full-desktop-set-icons-visible', visible !== false),
  requestDesktopKeyboardFocus: (reason) => ipcRenderer.invoke(
    'lanting-full-desktop-request-keyboard-focus',
    String(reason || 'renderer-pointerdown').slice(0, 80)
  ),
  updateDesktopPointerRoute: (payload) => ipcRenderer.send('lanting-full-desktop-pointer-route', {
    overSoftwareUi: payload && payload.overSoftwareUi === true,
    overDesktopControls: payload && payload.overDesktopControls === true,
  }),
  onWallpaperModeState: (callback) => {
    if (typeof callback !== 'function') return () => {};
    const listener = (_event, payload) => callback(payload || {});
    ipcRenderer.on('lanting-wallpaper-runtime-state', listener);
    return () => ipcRenderer.removeListener('lanting-wallpaper-runtime-state', listener);
  },
  onStateChange: (callback) => {
    const listener = (_event, state) => callback(state);
    ipcRenderer.on('desktop-window-state', listener);
    return () => ipcRenderer.removeListener('desktop-window-state', listener);
  },
});

window.addEventListener('DOMContentLoaded', () => {
  document.documentElement.classList.add('desktop-shell-root');
  document.body.classList.add('desktop-shell');
});
