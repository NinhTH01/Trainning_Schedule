import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationManager {
  LocalNotificationManager(this.flutterLocalNotificationsPlugin);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void _initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification({
    required String title,
    required String description,
  }) async {
    _initialize();
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      description,
      notificationDetails,
    );
  }
}
