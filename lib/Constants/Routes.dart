import 'package:emergency_app/Screens/ForgotPasswordScreen/ForgotPasswordScreen.dart';
import 'package:flutter/material.dart';

import '../Screens/LoginScreen/LoginScreen.dart';
import '../Screens/SignUpScreen/SignUpScreen.dart';

Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: ((context) => LoginScreen()),
  SignUpScreen.routeName: ((context) => SignUpScreen()),
  ForgotPasswordScreen.routeName: ((context) => ForgotPasswordScreen()),
};
