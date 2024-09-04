import 'package:flutter/material.dart';

import '../presentation/screens/forgot_password/forgot_password.dart';
import '../presentation/screens/login/login.dart';
import '../presentation/screens/signup/signup.dart';
import '../presentation/screens/splash/splash.dart';

Map<String, WidgetBuilder> routes = {
  "/": ((context) => const SplashScreen()),
  LoginScreen.routeName: ((context) => LoginScreen()),
  SignUpScreen.routeName: ((context) => SignUpScreen()),
  ForgotPasswordScreen.routeName: ((context) => ForgotPasswordScreen()),
};
