# LanTing 2.3.0 发布流程

## 发布边界

- 正式版本：`2.3.0`
- Git tag：`v2.3.0`
- Release 标题：`LanTing 2.3.0`
- 安装包：`LanTing-2.3.0-Setup.exe`
- 仅从当前可信源码完整构建，不复用旧安装包或旧 `dist/`。
- 正式 Release 不混入澜听_Beat 产物。
- GitHub Release 附带完整安装包 `LanTing-2.3.0-Setup.exe` 和最小版本说明 `latest.yml`。后者供旧版主检测失败时的备用线路使用；不上传 blockmap 或补丁。
- `2.0.3+` 客户端不得从 Release assets 识别或下载安装包，软件内更新仍只读取正文中的下载线路。
- Release 正文使用 `lanting-download-page` 隐藏标记提供本次下载入口，指向 Release 附件的直链。

## 分发

安装包统一从本仓库 [GitHub Releases](https://github.com/Nivalia/LanTing/releases) 分发，不再使用第三方网盘。

- 直链：`https://github.com/Nivalia/LanTing/releases/download/v2.3.0/LanTing-2.3.0-Setup.exe`

<!-- lanting-download-page: 直接下载|https://github.com/Nivalia/LanTing/releases/download/v2.3.0/LanTing-2.3.0-Setup.exe -->

## 公开更新说明

- 重新接入 Spotify：登录向导、搜索标签、账号胶囊与首页推荐全链路恢复。
- 换源增强：跨平台匹配改按专辑亲和与同名度评分，失败原因具体说明；无可换源版本时自动播放 Spotify 官方 30 秒试听。
- 新增伴奏：搜索栏「伴奏」开关直搜伴奏/纯音乐版本；输出区「人声消除」实时去除居中人声。
- README 主视觉换为真实启动画面。

## 发布资产

GitHub Release 上传 `dist/LanTing-2.3.0-Setup.exe` 和 `docs/update/latest.yml`。版本说明仅包含 `version/releaseDate`，不得使用带安装包下载字段的构建工具清单（`dist/latest.yml`）。构建生成的 blockmap、安装清单与校验记录仍只用于本地验收。

2.1.0 的备用检测和入口限制见 [更新公告与旧版兼容](docs/UPDATE_DELIVERY.md)。每次发布都要同步版本说明；缺失会使主接口访问失败的旧客户端无法发现更新。

安装包 SHA-256：`a0241d87c71e91ed028c293837c841a748a4ecb79bd0b00924aca68cd8c262db`。

## 发布前检查

- 运行完整回归检查与 Electron 启动检查。
- 构建并检查 `win-unpacked/resources/app` 内容，核对正式版本、资源完整性和源码一致性。
- 验证安装包启动、退出、重启和用户数据恢复。
- 确认仓库与安装包不包含 Cookie、Token、凭据、缓存或本机日志。
- 核对安装包 SHA-256、README 下载链接和 Release 正文隐藏标记中的直链。
