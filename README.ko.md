<div align="center">

<h1><img src="docs/images/readme-icon.png" width="64" align="center" alt="Trackpad Anything 앱 아이콘"> Trackpad Anything</h1>

### macOS Sonoma에서 USB‑C 매직 트랙패드 쓰기

macOS 15로 올리지 않고 **블루투스**와 **USB** 모두에서 멀티터치 제스처를 쓸 수 있어요.

[![macOS 14 Sonoma](https://img.shields.io/badge/macOS-14%20Sonoma-000?logo=apple&logoColor=white)](#요구-사항)
[![Apple Silicon](https://img.shields.io/badge/Apple%20Silicon-arm64-E5493F)](#요구-사항)
[![Release](https://img.shields.io/github/v/release/souluk319/Trackpad-Anything?color=E5493F&label=release)](https://github.com/souluk319/Trackpad-Anything/releases/latest)
[![License: GPL-3.0](https://img.shields.io/badge/license-GPL--3.0-8F2721)](LICENSE)

[**다운로드**](https://github.com/souluk319/Trackpad-Anything/releases/latest) · [동작 원리](#동작-원리) · [자주 묻는 질문](#자주-묻는-질문)

[English](README.md) · **한국어** · [日本語](README.ja.md) · [简体中文](README.zh-CN.md)

<img src="docs/images/menu-bar.png" width="420" alt="메뉴 막대: 캐릭터와 배터리 잔량">

</div>

---

## 만들게 된 이야기

저는 Parsec, Jump Desktop 같은 원격 접속으로 다른 컴퓨터를 제어하는 일이 많아요. 그럴 때 화면을 넘기는 데 트랙패드만 한 게 없어서 애플의 새 **Magic Trackpad (USB‑C)**를 샀어요.

그런데 동작하지 않았어요. USB‑C 모델은 **macOS 15.1** 이상만 공식 지원하고, 제 Mac에서는 스크롤도 제스처도 안 되는 그냥 마우스였죠.

"OS를 올리면 되잖아"가 정답이지만 저는 그럴 수 없어요. 음악 작업을 하는데 쓰는 플러그인들이 아직 Sequoia와 호환되지 않아서 **macOS 14 Sonoma**를 계속 써야 하거든요. 버전 숫자 하나 때문에 멀쩡한 트랙패드를 반품하기는 아까워서, 소프트웨어로 직접 뜯어보기로 했어요.

USB부터 직접 읽어서 해결했고, 블루투스는 훨씬 어려웠어요. Sonoma는 트랙패드의 터치 데이터를 어떤 앱이 보기도 전에 버려버리거든요. 원시 HID 보고서, L2CAP 채널, DriverKit, 캐시 수정까지 여러 번 막힌 끝에 찾은 답은 의외로 간단했어요. 블루투스에서 USB‑C 트랙패드는 사실상 이름만 바뀐 매직 트랙패드 2이고, Sonoma에는 이미 그 드라이버가 있었어요.

그렇게 나온 게 **Trackpad Anything**이에요. 커널 확장 없이, SIP를 끄지 않고, 유료 개발자 계정도 없이 Sonoma에서 USB‑C 트랙패드를 살려줘요.

<div align="center">
<img src="docs/images/ko/bluetooth.png" width="820" alt="블루투스 연결 화면">
</div>

## 기능

| | |
|---|---|
| 🛜 **블루투스는 macOS 기본으로** | 버튼 한 번이면 macOS에 내장된 매직 트랙패드 2 드라이버가 USB‑C 모델을 구동해요. 제스처를 macOS가 직접 처리해서 정품 그대로의 느낌이에요. |
| 🔌 **USB도 지원** | 내장 제스처 엔진이 케이블로 트랙패드를 직접 읽어요. 포인터, 두 손가락 스크롤, 확대·축소, 데스크탑 전환, Mission Control, 앱 Exposé 등을 지원해요. |
| ⌨️ **키보드 단축키** | **⌃⌥⌘←** / **⌃⌥⌘→**로 *이 Mac*의 데스크탑을 진짜 스와이프 애니메이션으로 넘겨요. 원격 데스크탑 전체 화면 안에서도 돼요. Karabiner 없이 앱에 내장돼 있어요. |
| 🖥 **원격 데스크탑 친화적** | 원격 데스크탑 앱을 전체 화면으로 띄워 둔 상태에서도 네 손가락 스와이프와 단축키가 *내 Mac*의 화면을 넘겨요. Parsec, Jump Desktop 등 원격 데스크탑 앱에서 쓸 수 있어요. |
| 🔋 **메뉴 막대 배터리** | 캐릭터 옆 배터리 안에 잔량 숫자가 보여요. 라이트·다크 메뉴 막대에 맞춰 바뀌어요. |
| 🎛 **앱 하나로 둘 다** | 포인터, 스크롤, 제스처 설정을 한곳에서 조절해요. 선택 기능인 **설정 미러**를 켜면 블루투스 연결 중에 macOS 트랙패드 설정에도 반영돼요. |
| 🌐 **4개 언어** | 한국어, English, 日本語, 简体中文. 시스템 언어를 따르고, 사이드바에서 바꿀 수도 있어요. |
| ↩️ **되돌리기 가능** | 백업이 자동으로 만들어지고, **원래대로 되돌리기**로 모두 원상복구돼요. |

<table>
<tr>
<td><img src="docs/images/ko/pointer-and-scroll.png" alt="포인터 및 스크롤 설정"></td>
<td><img src="docs/images/ko/spaces.png" alt="화면 전환"></td>
</tr>
</table>

## 요구 사항

- macOS **14 Sonoma**. 14.7.2에서 시험했어요.
- **Apple Silicon** Mac. Intel 빌드는 아직 없어요.
- Magic Trackpad (USB‑C), USB 제품 ID `0x0324`
- 시험한 범위와 되돌리기·복구 방법: [테스트 및 복구 (영문)](docs/TESTING.md) · [서드파티 고지 (영문)](docs/THIRD-PARTY.md)

> macOS 15.1 이상이라면 이 앱이 필요 없어요. Apple이 공식 지원해요.

## 설치

1. [**Releases**](https://github.com/souluk319/Trackpad-Anything/releases/latest)에서 `Trackpad-Anything-x.y.z-macOS-AppleSilicon.zip`을 받아 압축을 풀어요.
2. **Trackpad Anything.app**을 **응용 프로그램** 폴더로 옮겨요.
3. **처음 실행할 때:** 공증받지 않은 앱이라 macOS가 경고를 띄워요.
   앱을 우클릭 → **열기** → **열기**를 누르세요. 또는 시스템 설정 → 개인정보 보호 및 보안에서 **확인 없이 열기**를 눌러요.
4. **손쉬운 사용** 권한을 허용해요. USB 제스처 엔진과 키보드 단축키에 필요해요. 블루투스 제스처는 권한 없이도 동작해요.

<details>
<summary>터미널이 편하다면</summary>

```sh
xattr -dr com.apple.quarantine "/Applications/Trackpad Anything.app"
```
</details>

## 사용법

### 블루투스 (추천)

1. 트랙패드를 블루투스로 평소처럼 연결해요.
2. 앱 사이드바에서 **블루투스 연결**로 가요.
3. **블루투스 제스처 켜기**를 누르고 관리자 암호를 입력해요.
4. 블루투스가 몇 초 끊겼다가 다시 연결되면 macOS 기본 드라이버로 동작해요.

재부팅해도 유지되고, 앱을 꺼도 계속 동작해요. 되돌리려면 **원래대로 되돌리기**를 누르세요.

> **충전 팁:** 트랙패드를 *이 Mac*에 케이블로 꽂으면 다시 페어링되면서 원래대로 돌아가요. 충전은 일반 충전기로 하거나, 충전한 뒤 다시 켜 주세요.

### USB

케이블을 연결하고 앱을 메뉴 막대에 띄워 두면 돼요. 처음 한 번은 USB 연결을 위해 관리자 암호를 물어봐요. 설정은 **포인터 및 스크롤**, **제스처**, **화면 전환**에 있어요.

### 키보드 단축키

| 단축키 | 동작 |
|---|---|
| **⌃ Control + ⌥ Option + ⌘ Command + ←** | 이전 데스크탑 / 전체 화면 앱 |
| **⌃ Control + ⌥ Option + ⌘ Command + →** | 다음 데스크탑 / 전체 화면 앱 |

눈앞의 Mac에서 네 손가락 스와이프와 같은 애니메이션으로 화면을 넘겨요. **단축키** 화면에서 켜고 끌 수 있고, 손쉬운 사용 권한이 필요해요.

<details>
<summary>스크립트나 Karabiner로 쓰고 싶다면</summary>

앱 안에 작은 명령줄 도구도 들어 있어요.

```sh
"/Applications/Trackpad Anything.app/Contents/Resources/space-command" left   # 또는 right
```
</details>

## 동작 원리

- **블루투스:** Mac의 블루투스 기기 기록에 저장된 이 트랙패드의 제품 ID만 `0x0324`에서 `0x0265`(Lightning 모델)로 바꿔요. 그러면 macOS에 이미 있는 Magic Trackpad 2 드라이버가 그대로 동작해요.
  - 펌웨어, 시스템 파일, SIP, 페어링 키, 다른 기기는 건드리지 않아요.
  - 기록 형식이 예상과 다르면 아무것도 바꾸지 않고 멈춰요.
  - 원본 백업은 관리자 전용 파일로 기록 옆에 남겨요.
- **USB:** 앱이 실행되는 동안만 작은 도우미 프로그램(libusb)이 트랙패드의 멀티터치 인터페이스를 빌려 터치 데이터를 읽어요. 제스처 엔진이 이를 macOS 이벤트로 바꾸고, 앱을 끄면 인터페이스를 macOS에 돌려줘요.
- **단축키:** 앱이 ⌃⌥⌘←/→를 먼저 받아서 원격 앱으로 넘어가지 않게 하고, 제스처 엔진에 macOS 기본 화면 전환을 요청해요. 그래서 원격 컴퓨터가 아니라 내 Mac에서 화면이 넘어가요.

조사 과정은 [docs/BLUETOOTH-INVESTIGATION.ko.md](docs/BLUETOOTH-INVESTIGATION.ko.md)에 자세히 적어 뒀어요.

## 안전한가요?

- **커널 확장 없음, SIP 변경 없음, 시스템 파일 수정 없음.** 블루투스에서 실제로 일하는 드라이버는 Apple 것이에요.
- 관리자 권한은 앱 안에 들어 있는 작은 도우미 두 개에만 쓰여요. 둘 다 이 저장소에서 코드를 볼 수 있어요.
- 모든 변경은 되돌릴 수 있어요. 앱의 **원래대로 되돌리기**를 누르거나 트랙패드를 다시 페어링하면 돼요.
- 설정 미러는 **기본으로 꺼져 있어요.** macOS 트랙패드 설정은 MacBook 내장 트랙패드를 포함한 모든 트랙패드에 공통이라, 쓰기 전에 경고하고 기존 값을 백업해요.

## 자주 묻는 질문

<details><summary><b>그냥 macOS 15로 올리면 안 되나요?</b></summary>
올릴 수 있다면 그게 가장 좋아요. 오디오 플러그인, 회사 관리 Mac, 오래된 소프트웨어처럼 올릴 수 없는 환경을 위한 프로젝트예요.
</details>

<details><summary><b>재부팅이나 macOS 업데이트 후에도 유지되나요?</b></summary>
재부팅해도 유지돼요. macOS 업데이트가 블루투스 기록을 다시 쓸 수 있어요. 제스처가 멈추면 앱에서 다시 켜 주세요. 업데이트로 기록 형식이 바뀌면 아무것도 바꾸지 않고 알려줘요.
</details>

<details><summary><b>Intel Mac은요?</b></summary>
아직이에요. 포함된 libusb가 arm64 전용이라 릴리스는 Apple Silicon 전용이에요. Intel에서 소스로 직접 빌드하면 동작할 거예요.
</details>

<details><summary><b>단축키는 일반 키보드·마우스에서도 되나요?</b></summary>
네. 트랙패드와 상관없이 동작해서 원격 데스크탑을 쓴다면 누구에게나 유용해요.
</details>

## 직접 빌드하기

```sh
brew install libusb pkg-config
git clone https://github.com/souluk319/Trackpad-Anything.git
cd Trackpad-Anything/GUI && npm ci && cd ..
TC_SIGN=adhoc bash scripts/build-gui.sh   # → build/Trackpad Anything.app
bash scripts/test.sh
```

번역은 [`scripts/locales.py`](scripts/locales.py)에 있어요. 코드에 쓰인 문구 중 번역이 빠진 게 있으면 실행할 때 알려줘요.

## 크레딧 · 라이선스

블루투스 제품 ID 방식은 [GianMarioBen/MagicTrackPadCatalina](https://github.com/GianMarioBen/MagicTrackPadCatalina/pull/1)의 아이디어(Catalina용)에서 출발했고, Sonoma 형식에 맞춰 독립적으로 구현했어요. 그 밖의 출처는 [영문 README](README.md#credits)에 있어요.

[GPL‑3.0](LICENSE) © 2026 **KUGNUS LAB** · Apple Inc.와 관련이 없으며, Magic Trackpad와 macOS는 Apple Inc.의 상표예요.
