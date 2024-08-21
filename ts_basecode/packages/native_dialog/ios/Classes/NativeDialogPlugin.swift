import Flutter
import UIKit

public class NativeDialogPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
          let factory = CustomNativeViewFactory(messenger: registrar.messenger())
          registrar.register(factory, withId: "native_dialog")
  }
}
