#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p build/tests
clang -Wall -Wextra -Werror tests/EngineTests.c -framework ApplicationServices -o build/tests/engine
build/tests/engine
clang -Wall -Wextra -Werror -c Sources/Core/GestureEngine.c -o build/tests/engine.o
clang -Wall -Wextra -Werror -fobjc-arc tests/SettingsTests.m build/tests/engine.o -framework Foundation -framework ApplicationServices -o build/tests/settings
build/tests/settings
# bt-spoof on fixture caches (no root, no bluetoothd restart).
clang -Wall -Wextra -Werror -fobjc-arc Sources/BluetoothSetup/main.m -framework Foundation -o build/tests/bt-spoof
python3 -I tests/bluetooth_setup_tests.py build/tests/bt-spoof
