<div align="center">

<h1><img src="docs/images/readme-icon.png" width="64" align="center" alt="Trackpad Anything アプリアイコン"> Trackpad Anything</h1>

### macOS SonomaでUSB‑C版Magic Trackpadを使う

macOS 15にアップデートせずに、**Bluetooth**でも**USB**でもマルチタッチジェスチャが使えます。

[![macOS 14 Sonoma](https://img.shields.io/badge/macOS-14%20Sonoma-000?logo=apple&logoColor=white)](#動作環境)
[![Apple Silicon](https://img.shields.io/badge/Apple%20Silicon-arm64-E5493F)](#動作環境)
[![Release](https://img.shields.io/github/v/release/souluk319/Trackpad-Anything?color=E5493F&label=release)](https://github.com/souluk319/Trackpad-Anything/releases/latest)
[![License: GPL-3.0](https://img.shields.io/badge/license-GPL--3.0-8F2721)](LICENSE)

[**ダウンロード**](https://github.com/souluk319/Trackpad-Anything/releases/latest) · [仕組み](#仕組み) · [よくある質問](#よくある質問)

[English](README.md) · [한국어](README.ko.md) · **日本語** · [简体中文](README.zh-CN.md)

<img src="docs/images/menu-bar.png" width="420" alt="メニューバー：キャラクターとバッテリー残量">

</div>

---

## 開発のきっかけ

私はParsecやJump Desktopで他のコンピュータをリモート操作することがよくあります。画面を切り替えるにはトラックパッドが一番。4本指でスワイプすれば別の画面へ。そこでAppleの新しい **Magic Trackpad（USB‑C）** を買いました。

ところが動きませんでした。USB‑Cモデルは公式には **macOS 15.1** 以降が必要で、私のMacではスクロールもジェスチャも使えないただのマウスとして認識されました。

「macOSをアップデートすればいい」のが正解ですが、私にはできません。音楽制作で使っているオーディオプラグインがまだSequoiaに対応していないため、このMacは **macOS 14 Sonoma** のままにしておく必要があるのです。バージョン番号ひとつのために問題のないトラックパッドを返品するのは惜しかったので、ソフトウェアで分解してみることにしました。

まずUSBは直接データを読んで解決しました。Bluetoothはずっと大変でした。Sonomaはトラックパッドのタッチデータを、どのアプリにも届く前に捨ててしまうのです。生のHIDレポート、L2CAPチャネル、DriverKit、キャッシュの書き換えと何度も行き詰まった末に、答えは意外とシンプルでした。Bluetooth上のUSB‑Cトラックパッドは、名前が変わっただけのMagic Trackpad 2で、Sonomaはすでにそのドライバを持っていたのです。

こうして生まれたのが **Trackpad Anything** です。カーネル拡張なし、SIPを無効にせず、有料の開発者アカウントもなしで、SonomaでUSB‑Cトラックパッドを使えるようにします。

<div align="center">
<img src="docs/images/ja/bluetooth.png" width="820" alt="Bluetooth接続画面">
</div>

## 機能

| | |
|---|---|
| 🛜 **BluetoothはmacOS標準で** | ワンクリックで、macOS内蔵のMagic Trackpad 2ドライバがUSB‑Cモデルを動かします。ジェスチャはmacOS自身が処理するので、純正そのままの操作感です。 |
| 🔌 **USBにも対応** | 内蔵ジェスチャエンジンがケーブル経由でトラックパッドを直接読み取ります。ポインタ、2本指スクロール、ピンチ、デスクトップ切り替え、Mission Control、アプリケーションExposéなどに対応。 |
| ⌨️ **キーボードショートカット** | **⌃⌥⌘←** / **⌃⌥⌘→** で、*このMac*のデスクトップを本物のスワイプアニメーションで切り替えます。リモートデスクトップのフルスクリーン中でもOK。Karabiner不要の内蔵機能です。 |
| 🖥 **リモートデスクトップに最適** | リモートデスクトップアプリをフルスクリーンにしていても、4本指スワイプとショートカットで*手元のMac*の画面を切り替えられます。Parsec、Jump Desktopなどのリモートデスクトップアプリで使えます。 |
| 🔋 **メニューバーにバッテリー表示** | キャラクターの横のバッテリーに残量の数字を表示。ライト／ダークのメニューバーに合わせて変わります。 |
| 🎛 **ひとつのアプリで両方** | ポインタ、スクロール、ジェスチャの設定を一か所で。オプションの **設定ミラー** をオンにすると、Bluetooth接続中にmacOSのトラックパッド設定にも反映されます。 |
| 🌐 **4言語対応** | 日本語、English、한국어、简体中文。システムの言語に従い、サイドバーで切り替えることもできます。 |
| ↩️ **元に戻せる** | バックアップは自動で作成され、**元に戻す** ですべて元通りになります。 |

<table>
<tr>
<td><img src="docs/images/ja/pointer-and-scroll.png" alt="ポインタとスクロールの設定"></td>
<td><img src="docs/images/ja/spaces.png" alt="画面の切り替え"></td>
</tr>
</table>

## 動作環境

- macOS **14 Sonoma**（14.7.2で確認）
- **Apple Silicon** 搭載Mac（Intel版は未提供）
- Magic Trackpad（USB‑C）、USB製品ID `0x0324`
- テスト済みの範囲と、元に戻す・復旧する方法：[テストと復旧（英語）](docs/TESTING.md) · [サードパーティ通知（英語）](docs/THIRD-PARTY.md)

> macOS 15.1以降ならこのアプリは不要です。Appleが公式にサポートしています。

## インストール

1. [**Releases**](https://github.com/souluk319/Trackpad-Anything/releases/latest) から `Trackpad-Anything-x.y.z-macOS-AppleSilicon.zip` をダウンロードして展開します。
2. **Trackpad Anything.app** を **アプリケーション** フォルダに移動します。
3. **初回起動時：** 公証されていないアプリのため、macOSが警告を表示します。
   アプリを右クリック → **開く** → **開く** を選びます。または、システム設定 → プライバシーとセキュリティで **このまま開く** をクリックします。
4. **アクセシビリティ** の許可を求められたら許可してください。USBジェスチャエンジンとキーボードショートカットに必要です。Bluetoothジェスチャは許可がなくても動作します。

## 使い方

### Bluetooth（おすすめ）

1. いつもどおりトラックパッドをBluetoothでペアリングします。
2. アプリのサイドバーで **Bluetooth接続** を開きます。
3. **Bluetoothジェスチャをオン** をクリックし、管理者パスワードを入力します。
4. Bluetoothが数秒切断されて再接続されると、macOS標準のドライバで動作します。

再起動後もそのまま。アプリを閉じても動き続けます。元に戻すには **元に戻す** をクリックします。

> **充電のヒント：** トラックパッドを*このMac*にケーブルでつなぐと再ペアリングされ、変更がリセットされます。充電はACアダプタで行うか、充電後にもう一度オンにしてください。

### USB

ケーブルをつなぎ、アプリをメニューバーで起動したままにします。初回だけ、USBヘルパーのために管理者パスワードを一度求められます。設定は **ポインタとスクロール**、**ジェスチャ**、**画面の切り替え** にあります。

### キーボードショートカット

| ショートカット | 動作 |
|---|---|
| **⌃ Control + ⌥ Option + ⌘ Command + ←** | 前のデスクトップ／フルスクリーンアプリ |
| **⌃ Control + ⌥ Option + ⌘ Command + →** | 次のデスクトップ／フルスクリーンアプリ |

目の前のMacで、4本指スワイプと同じアニメーションで画面を切り替えます。**ショートカット** 画面でオン／オフでき、アクセシビリティの許可が必要です。

## 仕組み

- **Bluetooth：** MacのBluetoothデバイス記録に保存された、このトラックパッドの製品IDだけを `0x0324` から `0x0265`（Lightningモデル）に変更します。すると、macOSにすでにあるMagic Trackpad 2ドライバがそのまま動作します。
  - ファームウェア、システムファイル、SIP、ペアリングキー、ほかのデバイスには触れません。
  - 記録の形式が想定と異なる場合は、何も変更せずに中止します。
  - 元の記録のバックアップを、管理者だけが読めるファイルとして残します。
- **USB：** アプリの実行中だけ、小さなヘルパー（libusb）がトラックパッドのマルチタッチインターフェイスを借りてタッチデータを読み取ります。ジェスチャエンジンがそれをmacOSのイベントに変換し、アプリを終了するとインターフェイスをmacOSに返します。
- **ショートカット：** アプリが ⌃⌥⌘←/→ を先に受け取り、リモートアプリに渡らないようにしたうえで、ジェスチャエンジンにmacOS標準の画面切り替えを依頼します。だからリモート側ではなく手元のMacで画面が切り替わります。

## 安全性

- **カーネル拡張なし、SIPの変更なし、システムファイルの変更なし。** Bluetoothで実際に動いているのはApple自身のドライバです。
- 管理者権限は、アプリ内の小さなヘルパー2つにだけ使われます。どちらもこのリポジトリでコードを確認できます。
- すべての変更は元に戻せます。アプリの **元に戻す** か、トラックパッドの再ペアリングで戻ります。
- 設定ミラーは **デフォルトでオフ** です。macOSのトラックパッド設定はMacBook内蔵トラックパッドを含むすべてのトラックパッドに共通なので、書き込む前に警告し、既存の値をバックアップします。

## よくある質問

<details><summary><b>macOS 15にアップデートすればいいのでは？</b></summary>
できるならそれが一番です。オーディオプラグイン、会社の管理下のMac、古いソフトウェアなど、アップデートできない環境のためのプロジェクトです。
</details>

<details><summary><b>再起動やmacOSのアップデート後も維持されますか？</b></summary>
再起動後も維持されます。macOSのアップデートでBluetoothの記録が書き換えられることがあります。ジェスチャが止まったら、アプリでもう一度オンにしてください。アップデートで記録の形式が変わった場合は、何も変更せずにお知らせします。
</details>

<details><summary><b>Intel Macは？</b></summary>
まだです。同梱のlibusbがarm64専用のため、リリースはApple Silicon専用です。Intel上でソースからビルドすれば動作するはずです。
</details>

## ソースからビルド

```sh
brew install libusb pkg-config
git clone https://github.com/souluk319/Trackpad-Anything.git
cd Trackpad-Anything/GUI && npm ci && cd ..
TC_SIGN=adhoc bash scripts/build-gui.sh   # → build/Trackpad Anything.app
bash scripts/test.sh
```

翻訳は [`scripts/locales.py`](scripts/locales.py) にあります。翻訳の改善やプルリクエストを歓迎します。

## クレジット・ライセンス

Bluetoothの製品ID方式は [GianMarioBen/MagicTrackPadCatalina](https://github.com/GianMarioBen/MagicTrackPadCatalina/pull/1)（Catalina用）のアイデアをもとに、Sonomaの記録形式に合わせて独自に実装しました。そのほかの出典は [英語版README](README.md#credits) をご覧ください。

[GPL‑3.0](LICENSE) © 2026 **KUGNUS LAB** · Apple Inc.とは関係ありません。Magic Trackpad、macOSはApple Inc.の商標です。
