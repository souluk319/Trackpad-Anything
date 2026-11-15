#!/usr/bin/env python3
"""Fixture tests for bt-spoof: apply/restore/idempotency and refusal on unexpected caches.

Runs bt-spoof with --cache PATH (test mode: no root, no bluetoothd restart).
Usage: python3 -I tests/bluetooth_setup_tests.py build/tests/bt-spoof
"""
import hashlib, os, plistlib, subprocess, sys, tempfile

TOOL = os.path.abspath(sys.argv[1])
REAL, SPOOF = 0x0324, 0x0265


def sdp(pid):
    # attrID 0x0201 VendorID / 0x0202 ProductID, type 1 (uint), size 2, little-endian value.
    vendor = bytes([0x01, 0x02, 0x01, 0x02, 0x00, 0x4C, 0x00])
    product = bytes([0x02, 0x02, 0x01, 0x02, 0x00, pid & 0xFF, pid >> 8])
    return b"\x09\x00" + vendor + b"\x35\x10" + product + b"\x00\x01"


def record(pid=REAL, name="Magic Trackpad", **over):
    r = {"Name": name, "HIDProductID": pid.to_bytes(2, "little"), "DeviceIdProduct": pid, "SdpCache": sdp(pid)}
    r.update(over)
    return {k: v for k, v in r.items() if v is not None}


def cache(*records):
    devices = {f"aa-bb-cc-dd-ee-{i:02x}": r for i, r in enumerate(records)}
    devices["11-22-33-44-55-66"] = {"Name": "Keyboard", "LinkKey": b"secret"}
    return {"DeviceCache": devices}


def run(path, mode):
    p = subprocess.run([TOOL, mode, "--cache", path], capture_output=True, text=True)
    return p.returncode, p.stdout


def digest(path):
    return hashlib.sha256(open(path, "rb").read()).hexdigest()


def trackpad(path):
    for r in plistlib.load(open(path, "rb"))["DeviceCache"].values():
        if "HIDProductID" in r:
            return r


failures = 0


def check(name, ok, detail=""):
    global failures
    print(("PASS " if ok else "FAIL ") + name + ("" if ok else f"\n  {detail}"))
    failures += not ok


with tempfile.TemporaryDirectory() as d:
    # Apply -> backup + spoofed fields; apply again -> refused, unchanged; restore -> original.
    path = os.path.join(d, "devices.plist")
    plistlib.dump(cache(record()), open(path, "wb"), fmt=plistlib.FMT_BINARY)
    original = digest(path)
    code, out = run(path, "apply")
    r = trackpad(path)
    check("apply rewrites all three product-ID fields", code == 0 and "WROTE pid=0x0265" in out
          and int.from_bytes(r["HIDProductID"], "little") == SPOOF and r["DeviceIdProduct"] == SPOOF
          and r["SdpCache"] == sdp(SPOOF), out)
    check("apply leaves other devices untouched",
          plistlib.load(open(path, "rb"))["DeviceCache"]["11-22-33-44-55-66"]["LinkKey"] == b"secret")
    backup = path + ".tc-before-pid-spoof"
    check("apply makes a 0600 backup of the original", os.path.exists(backup) and digest(backup) == original
          and (os.stat(backup).st_mode & 0o777) == 0o600)
    applied = digest(path)
    code, out = run(path, "apply")
    check("second apply is refused and writes nothing", code == 2 and "already enabled" in out and digest(path) == applied, out)
    code, out = run(path, "restore")
    r = trackpad(path)
    check("restore returns to the original product ID", code == 0 and int.from_bytes(r["HIDProductID"], "little") == REAL
          and r["SdpCache"] == sdp(REAL), out)
    restored = digest(path)
    code, out = run(path, "restore")
    check("second restore is refused and writes nothing", code == 2 and "already original" in out and digest(path) == restored, out)
    code, out = run(path, "status")
    check("status reports and writes nothing", code == 0 and "BEFORE pid=0x0324" in out and digest(path) == restored, out)

    # Unexpected caches: refuse, change nothing, create no backup.
    bad = {
        "no trackpad record": cache(),
        "two trackpad records": cache(record(), record(name="Magic Trackpad 2")),
        "HIDProductID wrong length": cache(record(HIDProductID=b"\x24\x03\x00")),
        "unknown product ID": cache(record(pid=0x1234)),
        "SdpCache missing": cache(record(SdpCache=None)),
        "SdpCache product appears twice": cache(record(SdpCache=sdp(REAL) + sdp(REAL))),
    }
    for name, data in bad.items():
        path = os.path.join(d, name.replace(" ", "-") + ".plist")
        plistlib.dump(data, open(path, "wb"), fmt=plistlib.FMT_BINARY)
        before = digest(path)
        code, out = run(path, "apply")
        check(f"refuses: {name}", code == 2 and out.splitlines()[-1].startswith("STOP")
              and digest(path) == before and not os.path.exists(path + ".tc-before-pid-spoof"), out)

    path = os.path.join(d, "not-a-plist.plist")
    open(path, "wb").write(b"garbage")
    code, out = run(path, "apply")
    check("refuses: not a property list", code == 2 and open(path, "rb").read() == b"garbage", out)
    code, out = run(os.path.join(d, "missing.plist"), "apply")
    check("refuses: missing cache", code == 2, out)

print("bt-spoof fixtures:", "all passed" if not failures else f"{failures} failed")
sys.exit(1 if failures else 0)
