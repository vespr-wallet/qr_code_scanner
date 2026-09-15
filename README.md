[![pub package](https://img.shields.io/pub/v/qr_code_scanner_plus?include_prereleases)](https://pub.dartlang.org/packages/qr_code_scanner_plus)

⚠️ **If you are starting a new project, or your project requires new features or long-term stability, use an actively maintained alternative such as [mobile_scanner](https://pub.dev/packages/mobile_scanner).**

---

# ⚠️ Maintenance-only fork (no new features)

This package is a **maintenance-only fork** of the original `qr_code_scanner` package.

Its sole purpose is to keep existing projects compiling and running on newer versions of Flutter, the Android Gradle Plugin, and related tooling after the upstream package became unmaintained. It exists to allow **existing users to postpone migration**, not to provide an actively developed QR scanning solution.

**New feature PRs will be rejected.**  
This includes (but is not limited to):
- New functionality
- Feature extensions
- API changes or expansions
- Behavior changes beyond minimal fixes required for compatibility

If you need additional functionality, this package is not the right choice.

---

## Scope and limitations

- I maintain **only the Flutter-facing code** in this repository.
- The underlying native scanning is handled by:
  - Android: [zxing](https://github.com/zxing/zxing)
  - iOS: Native AVFoundation (Swift Package Manager and CocoaPods supported)

The original `qr_code_scanner` package used [MTBBarcodeScanner](https://github.com/mikebuss/MTBBarcodeScanner) on iOS, which has been archived and unmaintained since 2021. This fork replaced it with a native AVFoundation implementation to enable Swift Package Manager support and remove the only third-party iOS dependency.

The Android native library (zxing) is **outdated and unmaintained**. There are known issues and limitations in that native package that will **not be fixed here**.

As a result:
- Native-level bugs should be expected.
- This package is not a good foundation for adding or extending features.
- Only minimal fixes required to keep the package usable on current Flutter toolchains will be considered.

Projects that require new functionality, reliability, or long-term maintenance of both Flutter and native code should migrate to a fully maintained alternative such as [mobile_scanner](https://pub.dev/packages/mobile_scanner).

---

# QR Code Scanner Plus

A QR code scanner for iOS, Android, and Web that embeds platform views in Flutter.

This description is retained for historical context only and does **not** imply ongoing feature development.

---

## Screenshots

<table>
<tr>
<th colspan="2">
Android
</th>
</tr>

<tr>
<td>
<p align="center">
<img src="https://raw.githubusercontent.com/juliuscanute/qr_code_scanner/master/.resources/android-app-screen-one.jpg" width="30%" height="30%">
</p>
</td>
<td>
<p align="center">
<img src="https://raw.githubusercontent.com/juliuscanute/qr_code_scanner/master/.resources/android-app-screen-two.jpg" width="30%" height="30%">
</p>
</td>
</tr>

<tr>
<th colspan="2">
iOS
</th>
</tr>

<tr>
<td>
<p align="center">
<img src="https://raw.githubusercontent.com/juliuscanute/qr_code_scanner/master/.resources/ios-app-screen-one.png" width="30%" height="30%">
</p>
</td>
<td>
<p align="center">
<img src="https://raw.githubusercontent.com/juliuscanute/qr_code_scanner/master/.resources/ios-app-screen-two.png" width="30%" height="30%">
</p>
</td>
</tr>

</table>

## Get Scanned QR Code

When a QR code is recognized, the text identified will be set in 'result' of type `Barcode`, which contains the output text as property 'code' of type `String` and scanned code type as property 'format' which is an enum `BarcodeFormat`, defined in the library.

```dart
class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }
}

```

## Android Integration

In order to use this plugin, please make sure to add the Camera permissions in `android/app/src/main/AndroidManifest.xml`

```xml
    <uses-permission android:name="android.permission.CAMERA" />
```

## iOS Integration

In order to use this plugin, add the following to your Info.plist file:

```
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan QR codes</string>
```

### UIScene lifecycle

The iOS plugin supports both the `UIScene` lifecycle and the legacy application
lifecycle. No plugin-specific `SceneDelegate` or camera lifecycle changes are
required.

The host app must still adopt `UIScene`; updating this package alone does not
migrate your app. Follow [Flutter's UIScene migration guide](https://docs.flutter.dev/release/breaking-changes/uiscenedelegate)
to configure `UIApplicationSceneManifest` in `Info.plist` and register plugins in
`didInitializeImplicitFlutterEngine` using `engineBridge.pluginRegistry`.
The [example AppDelegate](example/ios/Runner/AppDelegate.swift) and
[example Info.plist](example/ios/Runner/Info.plist) already use this setup.

## Web Integration

Add this to `web/index.html`:

```html
<script src="https://cdn.jsdelivr.net/npm/jsqr@1.3.1/dist/jsQR.min.js"></script>
```

Please note: on web, only QR codes are supported. Other barcodes and 2D codes cannot be scanned.

Web support is in very early stage. Features such as flash, pause or resume are not implemented. Moreover, the camera
preview does not respect the surrounding constraints. This is not at last due to Flutter's early state of platform views
on web.

## Flip Camera (Back/Front)

The default camera is the back camera.

```dart
await controller.flipCamera();
```

## Flash (Off/On)

By default, flash is OFF.

```dart
await controller.toggleFlash();
```

## Resume/Pause

Pause camera stream and scanner.

```dart
await controller.pauseCamera();
```

Resume camera stream and scanner.

```dart
await controller.resumeCamera();
```

# Credits

- Android: https://github.com/zxing/zxing
- Original qr_code_scanner contributors
