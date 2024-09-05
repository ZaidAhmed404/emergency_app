import 'package:emergency_app/presentation/screens/forgot_password/forgot_password.dart';
import 'package:emergency_app/presentation/screens/login/login.dart';
import 'package:emergency_app/presentation/screens/signup/signup.dart';
import 'package:emergency_app/presentation/screens/splash/splash.dart';
import 'package:emergency_app/routes/custom_page_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'injection/dependency_injection.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  setupDependencyInjection();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
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
          case ForgotPasswordScreen.routeName:
            return CustomPageRoute(child: ForgotPasswordScreen());
          default:
            return null;
        }
      },
    );
  }
}
