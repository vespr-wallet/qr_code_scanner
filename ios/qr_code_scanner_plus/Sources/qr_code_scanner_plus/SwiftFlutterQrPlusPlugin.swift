import Flutter
import UIKit

@objc(FlutterQrPlusPlugin)
public class SwiftFlutterQrPlusPlugin: NSObject, FlutterPlugin, FlutterSceneLifeCycleDelegate {

  var factory: QRViewFactory
  public init(with registrar: FlutterPluginRegistrar) {
    self.factory = QRViewFactory(withRegistrar: registrar)
    registrar.register(factory, withId: "net.touchcapture.qr.flutterqrplus/qrview")
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftFlutterQrPlusPlugin(with: registrar)
    // Keep legacy application lifecycle support while also supporting UIScene hosts.
    registrar.addApplicationDelegate(instance)
    registrar.addSceneDelegate(instance)
  }

  public func applicationDidEnterBackground(_ application: UIApplication) {
  }

  public func applicationWillTerminate(_ application: UIApplication) {
  }

}
