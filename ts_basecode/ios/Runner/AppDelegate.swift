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

        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
           let keys = NSDictionary(contentsOfFile: path),
           let apiKey = keys["googleMapsApiKey"] as? String {
            GMSServices.provideAPIKey(apiKey)
        }

        guard let pluginRegisterar = self.registrar(forPlugin: "Runner") else { return false }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
