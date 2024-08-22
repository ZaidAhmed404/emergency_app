import 'package:flutter/material.dart';

import '../../Widgets/IconTextWidget.dart';
import '../../Widgets/TextButtonWidget.dart';
import '../../Widgets/TextFieldWidget.dart';
import '../ForgotPasswordScreen/ForgotPasswordScreen.dart';
import '../SignUpScreen/SignUpScreen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static const routeName = "/Login-Screen";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const Text(
                'Login',
                style: TextStyle(fontSize: 28),
              ),
              const Spacer(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFieldWidget(
                          hintText: "Email Address",
                          controller: emailController,
                          isPassword: false,
                          isEnabled: true,
                          validationFunction: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            } else if (value.length < 8) {
                              return 'Email must have 8 characters';
                            } else if (!value.contains("@") ||
                                !value.contains(".com")) {
                              return 'Please enter correct email';
                            }
                            return null;
                          },
                          textInputType: TextInputType.text,
                          textFieldWidth: MediaQuery.of(context).size.width,
                          onValueChange: (value) {},
                          maxLines: 1,
                          borderCircular: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          hintText: "Password",
                          controller: passwordController,
                          isPassword: true,
                          isEnabled: true,
                          validationFunction: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            } else if (value.length < 8) {
                              return 'Password must have 8 characters';
                            }
                            return null;
                          },
                          textInputType: TextInputType.text,
                          textFieldWidth: MediaQuery.of(context).size.width,
                          onValueChange: (value) {},
                          maxLines: 1,
                          borderCircular: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, ForgotPasswordScreen.routeName);
                  },
                  child: const Text(
                    'Forget Password?',
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Color(0xff6A707C)),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButtonWidget(
                function: () async {
                  if (_formKey.currentState!.validate()) {
                    // await auth.signinWithEmailAndPass(
                    //     email, pass, context);
                  }
                },
                isSelected: true,
                text: 'Login',
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'or Login With',
                  style: TextStyle(color: Color(0xff6A707C)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              IconTextWidget(
                iconUrl: "assets/icons/google_ic.svg",
                text: "Google",
                onPressedFunction: () {
                  // auth.signInWithGoogle(context);
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have account?',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(SignUpScreen.routeName);
                    },
                    child: const Text(
                      'Register Now',
                      style: TextStyle(color: Color(0xffE74140)),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
