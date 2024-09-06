import 'package:emergency_app/presentation/widgets/overlay_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../Widgets/text_button.dart';
import '../../Widgets/text_field.dart';
import '../../controllers/auth_controller.dart';
import '../../provider/screen_provider.dart';
import '../../widgets/icon_button.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  static const routeName = "/Forgot-Password-Screen";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  final AuthController _authController = GetIt.I<AuthController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenNotifier = ref.watch(screenNotifierProvider.notifier);
    return Scaffold(
      body: OverlayLoadingWidget(
        isLoading: ref.watch(screenNotifierProvider),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                IconButtonWidget(
                  icon: Icons.arrow_back,
                  onPressedFunction: () {
                    Navigator.pop(context);
                  },
                ),
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
                    FocusScope.of(context).unfocus();
                    screenNotifier.updateLoading(isLoading: true);
                    if (_formKey.currentState!.validate()) {
                      final isSuccess = await _authController
                          .handleForgetPassword(emailController.text);
                      if (isSuccess && context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                    screenNotifier.updateLoading(isLoading: false);
                  },
                  isSelected: true,
                  text: 'Send',
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
