abstract class NotificationServices {
  Future sendNotifications(
      {required String token, required String title, required String body});
}
