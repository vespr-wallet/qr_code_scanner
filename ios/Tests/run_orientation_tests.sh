#!/bin/bash
set -euo pipefail

# Requires Xcode and a booted iOS simulator. Pass its UDID as the first argument
# when more than one simulator is running; otherwise simctl uses "booted".
repo_root="$(cd "$(dirname "$0")/../.." && pwd)"
build_dir="$repo_root/build/ios-orientation-tests"
mkdir -p "$build_dir"

xcrun --sdk iphonesimulator swiftc \
  -sdk "$(xcrun --sdk iphonesimulator --show-sdk-path)" \
  -target "$(uname -m)-apple-ios13.0-simulator" \
  -module-cache-path "$build_dir/ModuleCache" \
  "$repo_root/ios/qr_code_scanner_plus/Sources/qr_code_scanner_plus/NativeBarcodeScanner.swift" \
  "$repo_root/ios/Tests/VideoOrientationTests.swift" \
  -o "$build_dir/VideoOrientationTests"

xcrun simctl spawn "${1:-booted}" "$build_dir/VideoOrientationTests"
