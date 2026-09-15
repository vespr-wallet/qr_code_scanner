# iOS plugin tests

From the repository root, with Flutter, Xcode, and an iOS simulator installed:

```sh
xcrun simctl list devices available
./tool/test_ios.sh 'platform=iOS Simulator,name=<simulator name>'
```

The script builds the example to prepare Flutter's framework, then runs the Swift
package's XCTest target in a generated workspace under `build/ios-tests`.
The tests verify scene and legacy delegate registration share one plugin instance
and register the platform view factory only once. No camera access is required.

Flutter may update the example's tracked generated files during the build; those
machine-specific changes are not part of the plugin tests.
