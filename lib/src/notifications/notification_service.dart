import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seda/main.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/presentation/router/app_router_names.dart';

class NotificationService {
  static final _notificationService = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _notificationService.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse nr) {
        if (nr.id == 2) {
          navigatorKey.currentState?.pushNamed(AppRouterNames.chat);
        }
      },
    );
  }

  static Future<NotificationDetails> notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "channelId",
      "channelName",
      channelDescription: "description",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    return const NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await notificationDetails();
    await _notificationService.show(id, title, body, details);
  }

  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    printResponse("id $id");
  }
}
