// This is here because dart doesn't seem to support this properly
// https://stackoverflow.com/questions/61161135/adding-support-for-navigator-mediadevices-getusermedia-to-dart

@JS('navigator.mediaDevices')
library;

import 'dart:js_interop';
import 'package:web/web.dart' as web;

@JS('getUserMedia')
external JSPromise<web.MediaStream> getUserMedia(UserMediaOptions constraints);

@JS('enumerateDevices')
external JSPromise<JSArray<web.MediaDeviceInfo>> enumerateDevices();

@JS()
extension type UserMediaOptions._(JSObject _) implements JSObject {
  external VideoOptions? get video;

  external factory UserMediaOptions({VideoOptions? video});
}

@JS()
extension type VideoOptions._(JSObject _) implements JSObject {
  external String? get facingMode;
  external DeviceIdOptions? get deviceId;

  external factory VideoOptions({
    String? facingMode,
    DeviceIdOptions? deviceId,
  });
}

@JS()
extension type DeviceIdOptions._(JSObject _) implements JSObject {
  external String get exact;

  external factory DeviceIdOptions({String? exact});
}
