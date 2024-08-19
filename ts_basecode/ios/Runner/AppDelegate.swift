import Flutter
import flutter_local_notifications
import UIKit
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

      FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
             GeneratedPluginRegistrant.register(with: registry)
         }

         if #available(iOS 10.0, *) {
           UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
         }


      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
          if let error = error {
              // Handle the error here.
              print("Error requesting notification permissions: \(error.localizedDescription)")
          }

          if granted {
              print("Notification permissions granted.")
              // You can now register for remote notifications if needed.
              DispatchQueue.main.async {
                  UIApplication.shared.registerForRemoteNotifications()
              }
          } else {
              print("Notification permissions denied.")
          }
      }

    GMSServices.provideAPIKey("AIzaSyDsLxsd0qDWOO1ANXC-mSzpzYS7V-PahhA")

      guard let pluginRegisterar = self.registrar(forPlugin: "Runner") else { return false }

      let factory = FLNativeViewFactory(messenger: pluginRegisterar.messenger())
      pluginRegisterar.register(
          factory,
          withId: "congratulation_view")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
