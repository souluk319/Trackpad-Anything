# Third-party notices

Trackpad Anything is licensed under the GNU GPL v3 (see `LICENSE`). It includes or uses:

| Component | License | How it is used |
|---|---|---|
| [libusb](https://libusb.info) 1.0.x | LGPL-2.1-or-later | Statically linked into `usb-helper` |
| [Astryx](https://www.npmjs.com/package/@astryxdesign/core) | MIT | Settings window UI (bundled JavaScript) |
| [Heroicons](https://heroicons.com) | MIT | Icons in the settings window |
| [React](https://react.dev) | MIT | Settings window UI (bundled JavaScript) |

## libusb (LGPL-2.1)

`usb-helper` links libusb statically so the release runs without Homebrew. The LGPL allows this when users can
relink the program against a modified libusb. Because all of Trackpad Anything's source code is published under
the GPL v3, you can do that with the normal build:

```bash
# Build your modified libusb, make it visible to pkg-config, then:
bash scripts/build-gui.sh
```

`scripts/build-gui.sh` links whatever `libusb-1.0` pkg-config reports. The libusb license text ships inside the app
at `Contents/Resources/ThirdParty-libusb-COPYING.txt`. libusb's source code is available at
<https://github.com/libusb/libusb>. Each release states the libusb version it was built with.
