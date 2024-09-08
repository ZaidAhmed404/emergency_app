import 'package:emergency_app/presentation/controllers/user_controller.dart';
import 'package:emergency_app/presentation/widgets/heading_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import '../../controllers/auth_controller.dart';
import '../../provider/screen_provider.dart';
import '../../widgets/text_button.dart';

class EmailVerificationScreen extends ConsumerWidget {
  EmailVerificationScreen({super.key});

  final AuthController _authController = GetIt.I<AuthController>();
  final UserController _userController = GetIt.I<UserController>();

  static const routeName = "/Email-Verification-Screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenNotifier = ref.watch(screenNotifierProvider.notifier);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(
            flex: 3,
          ),
          Center(
              child: SvgPicture.asset(
            'assets/icons/gmail.svg',
            height: 200,
          )),
          const Spacer(
            flex: 3,
          ),
          HeadingTextWidget(heading: 'Email Verification', fontSize: 20),
          const SizedBox(
            height: 20,
          ),
          Text(
            'An Email has been sent to ${FirebaseAuth.instance.currentUser?.email}. Please check your inbox and follow the instructions to complete the process.\n After verifying email. Please login again',
            style: const TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          TextButtonWidget(
            buttonWidth: MediaQuery.of(context).size.width,
            function: () async {
              screenNotifier.updateLoading(isLoading: true);
              await _userController.handleSendVerificationEmail();
              screenNotifier.updateLoading(isLoading: false);
            },
            isSelected: false,
            text: 'Send Again',
          ),
          const SizedBox(
            height: 15,
          ),
          TextButtonWidget(
            buttonWidth: MediaQuery.of(context).size.width,
            function: () async {
              screenNotifier.updateLoading(isLoading: true);
              await _authController.handleSignOut();
              screenNotifier.updateLoading(isLoading: false);
            },
            isSelected: true,
            text: 'Logout',
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    ));
  }
}
