@JS()
library;

import 'dart:js_interop';

@JS('jsQR')
external Code? jsQR(JSTypedArray data, int? width, int? height);

extension type Code._(JSObject _) implements JSObject {
  external String get data;
}
