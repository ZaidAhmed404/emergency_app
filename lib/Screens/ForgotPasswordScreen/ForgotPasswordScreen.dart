import 'package:emergency_app/Widgets/TextButtonWidget.dart';
import 'package:flutter/material.dart';

import '../../Widgets/TextFieldWidget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  static const routeName = "/Forgot-Password-Screen";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Text(
                'Enter Email Address',
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
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButtonWidget(
                function: () async {
                  if (_formKey.currentState!.validate()) {
                    // auth.passwordRest(email, context);
                  }
                },
                isSelected: true,
                text: 'Send',
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
