import 'dart:convert';
import 'dart:developer';

import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

import '../services/notification_services.dart';

class NotificationServicesImpl extends NotificationServices {
  Future getAccessToken() async {
    final _serviceAccountJson = {
      "type": "service_account",
      "project_id": "emergency-app-4ac25",
      "private_key_id": "fab00b94b0cc3f671e08bca9bdc57b1bee50b5cf",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCXb9H0oE1YQFVR\nyOP9RSGRLpn5TTnLRPf4JYvATCCW+skIKRJ1FwJtZXz6ndtaL4kq8PrsRXlygKR2\nMoRCK4uBwosho8X3JwGDRtY++4RV0SdfH6OWdE2ZlHILdqybqjj7oUatpO4VAmme\ne+p/thDS9vfZpu3W1A2ofXRRF13E8mmZS639e7p3aHiieMJ/YUWjx5RwLhWsnca0\nTEt5d07D5mLKpuz4wzSW+ytnx72PuIeHUM94GVW0Cz0jUxXY7xrehvu7CeQfnGXk\nIn0GfV+N+UWq4mFe216PH1SNCugVHjNGhs5RNOM+iWol+QjCEnaemOARCd04wK0d\nHI55cbnxAgMBAAECggEAE8xSrqCme/stLFwPMnVvRgPJrYYjICgMIy0FcEaDnDl9\nPsvf1d8EOjkidcFdhBTi4fJPW8RZdFbNKYbBM8Vtn7FHb0ZyAzXeRMNmDyXizzVg\n6FbClFDwNDvsDQOe3VsLyBn1m44MckK2fDnHFps+59XR4WqpfYSLpJOCOXfMkorL\nEtp1Bs//Ntqs1sCQc7VyY/zzKmWyz9YgR9blkvxhrOOwKc2nSuhHI1mqDhPTw4Yl\nqkUySK/2WYe4kbwnFfZsGTplCNCN8wwTA8wGFXgI5FZdReu6mny6+44ETmsD0tOJ\nehW4fGFltiOT8SMBHzHU54EA9507h4BzLZdtZ5g8gQKBgQDUMiWMHq7ERvNVlj06\ndcK/KI2WpBGClH8LtyLUdKQARB8wMcrYQAyugDbkXJ6Xo6MlZcdgoOr0pMMeqWHK\naz1MFtHby0q2m+fE+sseJO3/yg/DCbTGJbJCBic33W1eVjk5IuZCsJ06yaW2haMx\nHyYIqHt1rkCV+Ow1dth5v4O/dQKBgQC2ssGBNHZAzPcO7TyC4+pasjkPgUUNyiso\nDAGf1igFy947hCEgp/5pDtrS4hxssbQQIbC8lpOEZDHTneUUY32jSYuV68FdsNJT\neE8v/KBk5K5sCGihfcgkLOnGQ5g2Y5q/4x0AsE/jCFTwcBU8rhHVqPiXTgtlObw+\n0bD9F3XdDQKBgQDKFLu3Vp0fpWYlsv+6hd2iiO9WcAeQ8PSQ5qbP6Akri7ScBD9m\ndJDfOpGMJzyNszQy8FvRBU7dD3AW6j6MNFba+LyA8njDsXQnHqSDn63ctMUP/FVh\ngxLhV9TPmhuHBNxYMolRJ7uE+fbL/TbuF/jzs+hnqTwu1zG0tOrx/1Zr5QKBgQC2\nAQ5UsPa9R3M4I46MtpDZGYNOtvEb87Naidt0Z9wnKhmSIOb/qVwBPRMx0p+OiNlg\n2K9AsKD02vvoXPvBe/vFl5a/G8XemDBvhwMcQwdme4pnhVj2yF+B6lxZby1LwZ6A\nWrih3wM2oS48+OuvL5oEx/geg1lG1mV6D1vKRnzcYQKBgD7+6PAagqN2xUNQ62GN\nVZu/gKDhFhKo/VE6THO6u8nmet2FOQPhkErn4cDAmV+5Yo9zmAhQ/7x8m8LMZnQs\nlXP38eAC9dKlsPKcd8dHXCFuzVq5gvdpEOXkweH8PLVe5dNvTigh+XsKi7Tn+PDZ\ntmqRGuR299NUKDycYVRkGdCA\n-----END PRIVATE KEY-----\n",
      "client_email": "emergency-app-4ac25@appspot.gserviceaccount.com",
      "client_id": "101067467168950005463",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/emergency-app-4ac25%40appspot.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    final List<String> _scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(_serviceAccountJson), _scopes);
    //get Access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(_serviceAccountJson),
            _scopes,
            client);

    client.close();

    return credentials.accessToken.data;
  }

  @override
  Future sendNotifications(
      {required String token,
      required String title,
      required String body}) async {
    try {
      final String serverAccessToken = await getAccessToken();
      const projectId = "emergency-app-4ac25";
      const endpoint =
          "https://fcm.googleapis.com/v1/projects/$projectId/messages:send";
      final Map<String, dynamic> message = {
        "message": {
          "token": token,
          "notification": {"title": title, "body": body},
          "data": {}
        }
      };

      final http.Response response = await http.post(Uri.parse(endpoint),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $serverAccessToken"
          },
          body: jsonEncode(message));
      if (response.statusCode == 200) {
        log("notification sent successfully");
      } else {
        log("notification sent failed");
      }
    } catch (error) {}
  }
}
