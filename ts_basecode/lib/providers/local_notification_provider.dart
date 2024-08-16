import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/data/services/local_notification_manager/local_notification_manager.dart';

final localNotificationProvider = Provider<LocalNotificationManager>(
    (ref) => LocalNotificationManager(FlutterLocalNotificationsPlugin()));
