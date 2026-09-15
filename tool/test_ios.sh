#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 'platform=iOS Simulator,name=<simulator name>'" >&2
  exit 1
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
build_dir="$repo_root/build/ios-tests"

# Prepare Flutter's generated framework package and the simulator framework.
(cd "$repo_root/example" && flutter build ios --simulator --debug --no-codesign)

# Dependency tests are not exposed by the example's Runner workspace. Open the
# plugin as a root package, alongside the FlutterFramework package it depends on.
mkdir -p "$build_dir/PluginTests.xcworkspace"
ln -sfn "$repo_root/ios/qr_code_scanner_plus" "$build_dir/qr_code_scanner_plus"
ln -sfn "$repo_root/example/ios/Flutter/ephemeral/Packages/.packages/FlutterFramework" \
  "$build_dir/FlutterFramework"
cat > "$build_dir/PluginTests.xcworkspace/contents.xcworkspacedata" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<Workspace version="1.0">
  <FileRef location="group:qr_code_scanner_plus"/>
</Workspace>
XML

app_path="$repo_root/example/build/ios/iphonesimulator/Runner.app"
minimum_ios="$(/usr/libexec/PlistBuddy -c 'Print MinimumOSVersion' "$app_path/Info.plist")"
xcodebuild_args=(
  -workspace "$build_dir/PluginTests.xcworkspace"
  -sdk iphonesimulator
  -destination "$1"
  -derivedDataPath "$build_dir/DerivedData"
  CODE_SIGNING_ALLOWED=NO
  "IPHONEOS_DEPLOYMENT_TARGET=$minimum_ios"
  "FRAMEWORK_SEARCH_PATHS=\"$app_path/Frameworks\""
  "LD_RUNPATH_SEARCH_PATHS=\"$app_path/Frameworks\""
)

# Rebuild cached Clang modules when the selected Flutter SDK changes. The
# test-only scheme has no clean action, so clean using the library scheme.
xcodebuild clean -scheme qr-code-scanner-plus "${xcodebuild_args[@]}"
xcodebuild test -scheme qr_code_scanner_plusTests "${xcodebuild_args[@]}"
