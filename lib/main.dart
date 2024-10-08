import 'dart:developer';

import 'package:emergency_app/presentation/screens/about/about.dart';
import 'package:emergency_app/presentation/screens/complete_profile/complete_profile.dart';
import 'package:emergency_app/presentation/screens/edit_profile/edit_profile.dart';
import 'package:emergency_app/presentation/screens/email_verification/email_verification.dart';
import 'package:emergency_app/presentation/screens/forgot_password/forgot_password.dart';
import 'package:emergency_app/presentation/screens/home/home.dart';
import 'package:emergency_app/presentation/screens/login/login.dart';
import 'package:emergency_app/presentation/screens/search_contacts/search_contacts.dart';
import 'package:emergency_app/presentation/screens/signup/signup.dart';
import 'package:emergency_app/presentation/screens/splash/splash.dart';
import 'package:emergency_app/routes/custom_page_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'firebase_options.dart';
import 'injection/dependency_injection.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    log("Handling a background message: ${message.messageId}",
        name: "background message");
    log('Message data: ${message.data}', name: "message data");
    log('Message notification: ${message.notification?.title}', name: "title");
    log('Message notification: ${message.notification?.body}', name: "message");
  }
}

void main() async {
  setupDependencyInjection();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  await ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Emergency App',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return CustomPageRoute(child: const SplashScreen());
          case LoginScreen.routeName:
            return CustomPageRoute(child: LoginScreen());
          case SignUpScreen.routeName:
            return CustomPageRoute(child: SignUpScreen());
          case HomeScreen.routeName:
            return CustomPageRoute(child: HomeScreen());
          case ForgotPasswordScreen.routeName:
            return CustomPageRoute(child: ForgotPasswordScreen());
          case AboutScreen.routeName:
            return CustomPageRoute(child: AboutScreen());
          case EditProfileScreen.routeName:
            return CustomPageRoute(child: const EditProfileScreen());
          case EmailVerificationScreen.routeName:
            return CustomPageRoute(child: EmailVerificationScreen());
          case CompleteProfileScreen.routeName:
            return CustomPageRoute(child: CompleteProfileScreen());
          case SearchContactsScreen.routeName:
            return CustomPageRoute(child: SearchContactsScreen());
          default:
            return null;
        }
      },
    );
  }
}
