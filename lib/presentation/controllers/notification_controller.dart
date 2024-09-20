import '../../domain/services/notification_services.dart';

class NotificationController {
  final NotificationServices notificationServices;

  NotificationController(this.notificationServices);

  Future handleSendingNotification(
      {required String token,
      required String title,
      required String body}) async {
    await notificationServices.sendNotifications(
        token: token, title: title, body: body);
  }
}
