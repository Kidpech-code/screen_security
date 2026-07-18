#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
device_id="$({
  xcrun simctl list devices available --json |
    python3 -c '
import json
import sys

devices = json.load(sys.stdin)["devices"]
available_iphones = (
    device
    for runtime_devices in devices.values()
    for device in runtime_devices
    if device.get("isAvailable") and device.get("name", "").startswith("iPhone")
)
print(next(available_iphones)["udid"])
'
})"

cd "$repo_root/example/ios"
xcodebuild -quiet \
  -workspace Runner.xcworkspace \
  -scheme Runner \
  -destination "platform=iOS Simulator,id=$device_id" \
  -only-testing:RunnerTests \
  test
