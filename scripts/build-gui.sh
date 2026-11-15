#!/bin/bash
set -euo pipefail
export MACOSX_DEPLOYMENT_TARGET=14.0
cd "$(dirname "$0")/.."
(cd GUI && npm run build && npx astryx doctor --built dist)
app="${TC_APP_OUTPUT:-$PWD/build/Trackpad Anything.app}"
mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"
clang -O2 -Wall -Wextra -c Sources/Core/GestureEngine.c -o build/engine.o
clang -O2 -Wall -Wextra -fobjc-arc Sources/App/GUIHost.m build/engine.o -framework Cocoa -framework WebKit -framework ApplicationServices -framework IOKit -framework ServiceManagement -o "$app/Contents/MacOS/TrackpadCompatGUI"
# space-command: CLI for Karabiner or scripts ("space-command left|right").
clang -O2 -Wall -Wextra Sources/Command/main.c -o "$app/Contents/Resources/space-command"
clang -O2 -Wall -Wextra -fobjc-arc Sources/BluetoothSetup/main.m -framework Foundation -o "$app/Contents/Resources/bt-spoof"
# libusb is linked statically so the app runs without Homebrew.
clang -O2 -Wall -Wextra Sources/USBHelper/main.c $(pkg-config --cflags libusb-1.0) "$(pkg-config --variable=libdir libusb-1.0)/libusb-1.0.a" -lobjc -framework IOKit -framework CoreFoundation -framework Security -o "$app/Contents/Resources/usb-helper"
rsync -a --delete GUI/dist/ "$app/Contents/Resources/GUI/"
python3 - "$app" <<'PY'
import sys,plistlib
from pathlib import Path
p=Path(sys.argv[1])/'Contents/Info.plist'
p.write_bytes(plistlib.dumps({'CFBundleIdentifier':'org.trackpadcompat.gui.development','CFBundleName':'Trackpad Anything','CFBundleDisplayName':'Trackpad Anything','CFBundleExecutable':'TrackpadCompatGUI','CFBundlePackageType':'APPL','CFBundleVersion':'1.1.0','CFBundleShortVersionString':'1.1.0','NSHumanReadableCopyright':'© 2026 KUGNUS LAB','LSMinimumSystemVersion':'14.0','NSHighResolutionCapable':True,'CFBundleIconFile':'AppIcon','CFBundleDevelopmentRegion':'en','CFBundleLocalizations':['en','ko','ja','zh-Hans']}))
PY
if [ -f Resources/AppIcon.icns ]; then cp Resources/AppIcon.icns "$app/Contents/Resources/"; fi
cp Resources/MenuBarMascot.png Resources/MenuBarMascot@2x.png "$app/Contents/Resources/"
cp GUI/src/locales.json "$app/Contents/Resources/locales.json"
# libusb is LGPL-2.1 and linked statically: ship its license next to the binary (see docs/THIRD-PARTY.md).
cp "$(brew --prefix libusb)/COPYING" "$app/Contents/Resources/ThirdParty-libusb-COPYING.txt"
cp docs/THIRD-PARTY.md "$app/Contents/Resources/ThirdParty-NOTICES.md"
# TC_SIGN=adhoc: no personal certificate (release builds, or building from source without setup).
if [ "${TC_SIGN:-local}" = adhoc ]; then
  for target in "$app/Contents/Resources/usb-helper" "$app/Contents/Resources/bt-spoof" "$app/Contents/Resources/space-command" "$app"; do codesign --force --sign - --timestamp=none "$target"; done
else
  python3 scripts/sign-local.py "$app"
fi
codesign --verify --strict "$app"
printf '%s\n' "$app"
