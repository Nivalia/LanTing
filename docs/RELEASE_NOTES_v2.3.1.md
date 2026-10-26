## LanTing 2.3.1

- 修复 QQ 音乐扫码登录成功但播放授权（qm_keyst）不生成：登录回调返回 code 后，主进程按官方算法补做一次授权换取，避免页面内嵌请求未落地导致「登录成功但仍未授权」。
- 登录窗口新增 qq-login-debug.log 诊断记录（导航、cookie 状态、授权交换结果），便于定位登录链路问题。
- 修复 QQ / 酷狗登录窗口自动点击「登录」时误点整块导航容器，导致登录弹窗不打开。

## 下载

安装包：`LanTing-2.3.1-Setup.exe`（见 Release 的 Assets）。

SHA-256：`39fc604c123872f4dbb5bd5d59dd82997d75c04626e88efc1afb6b511338e6ca`。

<!-- lanting-download-page: 直接下载|https://github.com/Nivalia/LanTing/releases/download/v2.3.1/LanTing-2.3.1-Setup.exe -->
