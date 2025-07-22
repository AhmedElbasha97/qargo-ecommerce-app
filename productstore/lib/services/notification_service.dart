import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      print("Notification permission status: $status");
    }
    const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);
  }


    Future<void> showCartNotification(String title) async {
      const androidDetails = AndroidNotificationDetails(
        'cart_channel_id',
        'Cart Notifications',
        channelDescription: 'Notification when product is added to cart',
        importance: Importance.max,
        priority: Priority.high,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      await _plugin.show(
        0,
        'Added to Cart',
        '$title has been added',
        notificationDetails,
      );
    }
  }
