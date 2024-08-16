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




    GMSServices.provideAPIKey("AIzaSyDsLxsd0qDWOO1ANXC-mSzpzYS7V-PahhA")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
