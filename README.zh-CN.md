<div align="center">

<h1><img src="docs/images/readme-icon.png" width="64" align="center" alt="Trackpad Anything 应用图标"> Trackpad Anything</h1>

### 在 macOS Sonoma 上使用 USB‑C 版妙控板

无需升级到 macOS 15，**蓝牙**和 **USB** 连接都能使用多点触控手势。

[![macOS 14 Sonoma](https://img.shields.io/badge/macOS-14%20Sonoma-000?logo=apple&logoColor=white)](#系统要求)
[![Apple Silicon](https://img.shields.io/badge/Apple%20Silicon-arm64-E5493F)](#系统要求)
[![Release](https://img.shields.io/github/v/release/souluk319/Trackpad-Anything?color=E5493F&label=release)](https://github.com/souluk319/Trackpad-Anything/releases/latest)
[![License: GPL-3.0](https://img.shields.io/badge/license-GPL--3.0-8F2721)](LICENSE)

[**下载**](https://github.com/souluk319/Trackpad-Anything/releases/latest) · [工作原理](#工作原理) · [常见问题](#常见问题)

[English](README.md) · [한국어](README.ko.md) · [日本語](README.ja.md) · **简体中文**

<img src="docs/images/menu-bar.png" width="420" alt="菜单栏：角色图标与电池电量">

</div>

---

## 开发缘起

我经常用 Parsec 和 Jump Desktop 远程控制其他电脑。切换屏幕时，触控板最顺手：四指一扫，就到了另一个屏幕。于是我买了 Apple 新款 **妙控板（USB‑C）**。

结果它用不了。USB‑C 型号官方要求 **macOS 15.1** 及以上，在我的 Mac 上它只被识别成一个普通鼠标：不能滚动，没有手势，也打不开调度中心。

“升级 macOS 就好了”是标准答案，可我做不到。我做音乐，用的音频插件还不兼容 Sequoia，所以这台 Mac 只能继续用 **macOS 14 Sonoma**。为了一个版本号就退掉一块好好的触控板太可惜了，于是我决定用软件把它“拆开”看看。

USB 先通过直接读取数据解决了。蓝牙则难得多：Sonoma 会在任何应用看到之前就丢弃触控板的触控数据。原始 HID 报告、L2CAP 通道、DriverKit、改写缓存……一路碰壁之后，答案却出乎意料地简单：在蓝牙下，USB‑C 触控板其实就是换了名字的妙控板 2，而 Sonoma 本来就有它的驱动。

于是有了 **Trackpad Anything**。无需内核扩展，无需关闭 SIP，也无需付费开发者账号，就能让 USB‑C 触控板在 Sonoma 上用起来。

<div align="center">
<img src="docs/images/zh/bluetooth.png" width="820" alt="蓝牙连接页面">
</div>

## 功能

| | |
|---|---|
| 🛜 **蓝牙原生支持** | 一键让 macOS 内建的妙控板 2 驱动接管 USB‑C 型号。手势由 macOS 自己处理，手感与原装完全一致。 |
| 🔌 **同样支持 USB** | 内置手势引擎通过线缆直接读取触控板：指针、双指滚动、捏合缩放、切换桌面、调度中心、应用程序 Exposé 等。 |
| ⌨️ **键盘快捷键** | **⌃⌥⌘←** / **⌃⌥⌘→** 以真正的轻扫动画切换*这台 Mac* 的桌面，即使在全屏远程桌面中也可以。内置功能，无需 Karabiner。 |
| 🖥 **远程桌面友好** | 即使远程桌面应用处于全屏状态，四指轻扫和快捷键也能切换*本机*的屏幕。适用于 Parsec、Jump Desktop 等远程桌面应用。 |
| 🔋 **菜单栏电量** | 角色图标旁的电池中直接显示电量数字，并随浅色／深色菜单栏变化。 |
| 🎛 **一个应用管两种连接** | 在同一处调节指针、滚动和手势设置。打开可选的 **设置镜像** 后，蓝牙连接时也会同步到 macOS 触控板设置。 |
| 🌐 **四种语言** | 简体中文、English、한국어、日本語。默认跟随系统语言，也可在侧边栏切换。 |
| ↩️ **可随时还原** | 自动创建备份，点按 **恢复原状** 即可全部还原。 |

<table>
<tr>
<td><img src="docs/images/zh/pointer-and-scroll.png" alt="指针与滚动设置"></td>
<td><img src="docs/images/zh/spaces.png" alt="切换屏幕"></td>
</tr>
</table>

## 系统要求

- macOS **14 Sonoma**（已在 14.7.2 上测试）
- **Apple 芯片** Mac（暂不提供 Intel 版本）
- 妙控板（USB‑C），USB 产品 ID `0x0324`
- 已测试范围以及撤销和恢复方法：[测试与恢复（英文）](docs/TESTING.md) · [第三方声明（英文）](docs/THIRD-PARTY.md)

> 如果你使用 macOS 15.1 或更高版本，则不需要此应用，Apple 已官方支持。

## 安装

1. 从 [**Releases**](https://github.com/souluk319/Trackpad-Anything/releases/latest) 下载 `Trackpad-Anything-x.y.z-macOS-AppleSilicon.zip` 并解压。
2. 将 **Trackpad Anything.app** 移到 **应用程序** 文件夹。
3. **首次打开：** 应用未经公证，macOS 首次会显示警告。
   右键点按应用 → **打开** → **打开**。或前往“系统设置” → “隐私与安全性”，点按 **仍要打开**。
4. 出现提示时允许 **辅助功能**。USB 手势引擎和键盘快捷键需要此权限，蓝牙手势不需要。

## 使用方法

### 蓝牙（推荐）

1. 像平常一样通过蓝牙配对触控板。
2. 打开应用，在侧边栏进入 **蓝牙连接**。
3. 点按 **启用蓝牙手势**，并输入管理员密码。
4. 蓝牙会断开几秒后重新连接，之后触控板即由 macOS 自带驱动运行。

重启后依然有效，即使关闭应用也会继续工作。若要撤销，点按 **恢复原状**。

> **充电提示：** 用线缆把触控板连接到*这台 Mac* 会重新配对，从而还原更改。请使用普通充电器充电，或充电后再启用一次。

### USB

连接线缆，并让应用在菜单栏中保持运行。首次使用时，会为 USB 辅助程序请求一次管理员密码。设置位于 **指针与滚动**、**手势** 和 **切换屏幕**。

### 键盘快捷键

| 快捷键 | 操作 |
|---|---|
| **⌃ Control + ⌥ Option + ⌘ Command + ←** | 上一个桌面／全屏应用 |
| **⌃ Control + ⌥ Option + ⌘ Command + →** | 下一个桌面／全屏应用 |

在你面前的 Mac 上，以与四指轻扫相同的动画切换屏幕。可在 **快捷键** 页面打开或关闭，需要辅助功能权限。

## 工作原理

- **蓝牙：** 只把 Mac 蓝牙设备记录中这块触控板的产品 ID 从 `0x0324` 改为 `0x0265`（Lightning 型号）。这样 macOS 自带的妙控板 2 驱动就能直接工作。
  - 不会改动固件、系统文件、SIP、配对密钥或其他设备。
  - 如果记录格式与预期不符，则不做任何更改并停止。
  - 原始记录会备份为仅管理员可读的文件。
- **USB：** 仅在应用运行期间，一个小型辅助程序（libusb）会借用触控板的多点触控接口读取触控数据。手势引擎将其转换为 macOS 事件；退出应用时，接口会交还给 macOS。
- **快捷键：** 应用会先接收 ⌃⌥⌘←/→，防止其传给远程应用，再请求手势引擎执行 macOS 原生的屏幕切换。因此切换发生在你本机的 Mac 上，而不是远程电脑上。

## 安全吗？

- **没有内核扩展，不改 SIP，不修改系统文件。** 在蓝牙下真正工作的是 Apple 自己的驱动。
- 管理员权限只用于应用内的两个小型辅助程序，代码都可以在本仓库中查看。
- 所有更改都可以还原：点按应用中的 **恢复原状**，或重新配对触控板。
- 设置镜像 **默认关闭**。macOS 触控板设置对包括 MacBook 内建触控板在内的所有触控板生效，因此写入前会提示并备份原有设置。

## 常见问题

<details><summary><b>直接升级到 macOS 15 不行吗？</b></summary>
能升级当然最好。本项目面向因音频插件、公司管理的 Mac 或旧软件而无法升级的环境。
</details>

<details><summary><b>重启或 macOS 更新后还有效吗？</b></summary>
重启后依然有效。macOS 更新可能会改写蓝牙记录；如果手势失效，请在应用中再次启用。如果更新改变了记录格式，工具会拒绝写入并提示你。
</details>

<details><summary><b>支持 Intel Mac 吗？</b></summary>
暂不支持。内置的 libusb 仅为 arm64，因此发行版仅支持 Apple 芯片。在 Intel Mac 上从源码构建应该可以运行。
</details>

## 从源码构建

```sh
brew install libusb pkg-config
git clone https://github.com/souluk319/Trackpad-Anything.git
cd Trackpad-Anything/GUI && npm ci && cd ..
TC_SIGN=adhoc bash scripts/build-gui.sh   # → build/Trackpad Anything.app
bash scripts/test.sh
```

翻译位于 [`scripts/locales.py`](scripts/locales.py)，欢迎改进翻译或提交 PR。

## 致谢 · 许可证

蓝牙产品 ID 方案源自 [GianMarioBen/MagicTrackPadCatalina](https://github.com/GianMarioBen/MagicTrackPadCatalina/pull/1)（适用于 Catalina）的思路，并针对 Sonoma 的记录格式独立实现。其他来源见 [英文 README](README.md#credits)。

[GPL‑3.0](LICENSE) © 2026 **KUGNUS LAB** · 与 Apple Inc. 无关。妙控板（Magic Trackpad）和 macOS 是 Apple Inc. 的商标。
