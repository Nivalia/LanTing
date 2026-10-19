# 澜听 LanTing

[![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](./LICENSE)
[![Release](https://img.shields.io/github/v/release/Nivalia/LanTing?include_prereleased&label=Release)](https://github.com/Nivalia/LanTing/releases)
[![Platform](https://img.shields.io/badge/platform-Windows%2010%2F11-lightgrey.svg)](https://github.com/Nivalia/LanTing/releases)
[![Electron](https://img.shields.io/badge/Electron-42-47848F.svg)](https://www.electronjs.org/)

> **LanTing**，取「澜」之水波与「听」之聆听：像看一片有声的水面。

![澜听暗场启动页](./docs/assets/readme/cinema-beat-smoke.png)

澜听是一款 Windows 桌面沉浸式音乐播放器，把搜索播放、歌词舞台、粒子视觉、3D 歌单架和完整桌面模式组合成一个更接近现场感的私人音乐空间。

## 立即下载

前往 [Releases](https://github.com/Nivalia/LanTing/releases) 下载最新安装包：

```
LanTing-<version>-Setup.exe
```

运行安装包即可完成安装，安装程序会创建桌面快捷方式。`.blockmap`、`latest.yml`、`win-unpacked` 是更新与构建产物，不是安装包。

> **安全提示**：`v1.0.10` 及更早的旧安装包不再建议安装或传播，请只使用本仓库 Release 中的安装包。详见 [SECURITY.md](./SECURITY.md)。

## 核心特性

- **首页仪表盘**：每日推荐、平台推荐、继续听、听歌画像、我的歌单入口
- **完整桌面模式**：播放器、主页、歌单直接铺在桌面上，保留窗口交互与图标层
- **歌词舞台**：多行歌词、翻译、位置与深度控制，桌面歌词独立窗口
- **粒子与节奏视觉**：基于节奏的电影镜头系统，粒子预设随播放状态联动
- **本地视觉内容**：支持本地 MP4 与 Wallpaper Engine 壁纸导入为视觉层
- **3D 歌单架**：右键唤起，浏览歌单队列与封面卡片
- **多平台音源**：网易云音乐、QQ 音乐、酷狗、汽水音乐的搜索、登录与播放辅助
- **播客与长曲目**：面向长播客和 DJ 曲目的专属视觉模式
- **自定义外观**：专辑封面上传裁剪、自定义歌词、DIY 玩家模式
- **Cuefield AutoMix**：可选启用的自动混音规划与过渡运行时（详见 [NOTICE.md](./NOTICE.md)）

## 开发运行

```bash
npm install
npm start          # 以 Electron 启动桌面版
```

构建 Windows NSIS 安装包（产物位于 `dist/`）：

```bash
npm run build:win
```

质量检查：

```bash
node scripts/quick-check.js        # 静态自检：语法、守卫测试、回归检查
node scripts/quick-check.js --full # 附加 Electron 启动与运行时 QA
node --test tests/                 # 完整测试套件
```

> 构建机无法访问 GitHub 时可使用镜像：`ELECTRON_MIRROR=https://npmmirror.com/mirrors/electron/`。

## 目录结构

| 目录 / 文件 | 说明 |
| --- | --- |
| `desktop/` | Electron 主进程：窗口、托盘、IPC、分区、原生层守卫 |
| `public/` | 渲染层：页面、样式、视觉与歌词运行时 |
| `server.js` | 本地服务：数据聚合与更新检测 |
| `*-api.js` | 各音乐平台的搜索 / 歌词 / 播放适配器 |
| `cuefield/` | Cuefield AutoMix 规划器与桥接 |
| `build/` | 图标、NSIS 脚本、打包钩子 |
| `scripts/` | 自检与运维脚本 |
| `tests/` | `node --test` 测试套件 |
| `docs/` | 设计文档、发布说明、第三方移植记录 |

## 更新机制

澜听会请求 GitHub Releases 的 latest 版本检测新版本，远端版本高于本地版本时在应用内展示更新内容。`2.0.3+` 客户端只读取 Release 正文中的下载线路，不会在客户端内下载或应用补丁。

本地验证更新链路时，可通过 `LANTING_UPDATE_MANIFEST` 指向本地 manifest JSON 或 HTTP 地址模拟线上 Release。详见 [docs/UPDATE_DELIVERY.md](./docs/UPDATE_DELIVERY.md)。

## 第三方平台说明

澜听不是网易云音乐、QQ 音乐或腾讯音乐娱乐集团的官方客户端，也不隶属于任何音乐平台。

项目中的第三方平台接入仅用于个人学习、本地客户端体验和用户自有账号的播放辅助。请遵守对应平台的用户协议、版权规则和会员权益规则。项目不会提供绕过付费、绕过会员、破解音质或重新分发音乐内容的能力。

## 用户数据与隐私

登录 Cookie、搜索历史、自定义封面、自定义歌词、节奏分析缓存等数据只保存在本机用户数据目录或浏览器本地存储中，`.gitignore` 已将这些文件全部排除在仓库之外。详见 [PRIVACY.md](./PRIVACY.md)。

## 文档

| 文档 | 内容 |
| --- | --- |
| [SECURITY.md](./SECURITY.md) | 安全策略与安装包安全公告 |
| [PRIVACY.md](./PRIVACY.md) | 隐私与用户数据说明 |
| [NOTICE.md](./NOTICE.md) | 第三方依赖与移植声明（GPL 署名） |
| [CHANGELOG.md](./CHANGELOG.md) | 版本变更记录 |
| [RELEASE.md](./RELEASE.md) | 发布流程与验收清单 |
| [docs/THIRD_PARTY_PORTS.md](./docs/THIRD_PARTY_PORTS.md) | 第三方移植细节 |
| [docs/INSTALLER_STYLE.md](./docs/INSTALLER_STYLE.md) | 安装包视觉规范 |

## 致谢

- 澜听最初由 **XxHuberrr** 设计与打造，本仓库在其公开源码基础上继续维护。
- **emily** 作为早期视觉底层想法与 `emily` 视觉预设改进方向的共创者和灵感来源之一，特此感谢。
- 感谢小天才e宝、应春日、锋将军、軌跡、林中、骊、风痕、花椰菜🥦在早期体验、测试反馈和发布准备中的帮助。

## 版权与授权

Copyright (C) 2026 澜听 LanTing 作者及贡献者。

本项目采用 **GPL-3.0** 授权，详见 [LICENSE](./LICENSE)。

澜听名称、界面视觉设计与原创视觉表达归作者所有；第三方依赖和第三方服务分别遵循其各自授权与服务条款，详见 [NOTICE.md](./NOTICE.md)。
