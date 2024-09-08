import 'package:emergency_app/presentation/screens/about/about.dart';
import 'package:emergency_app/presentation/screens/setting/widgets/item.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../main.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/heading_text.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final AuthController _authController = GetIt.I<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            HeadingTextWidget(
              heading: "Account",
              fontSize: 25,
            ),
            const SizedBox(
              height: 20,
            ),
            // const ProfileItemWidget(),
            const SizedBox(
              height: 20,
            ),
            HeadingTextWidget(
              heading: "Settings",
              fontSize: 25,
            ),
            const SizedBox(
              height: 20,
            ),
            ItemWidget(
              onPressedFunction: () {
                navigatorKey.currentState?.pushNamed(AboutScreen.routeName);
              },
              text: "About",
              iconData: Icons.info_outline,
            ),
            const Divider(
              height: 30,
            ),
            ItemWidget(
              onPressedFunction: () async {
                await _authController.handleSignOut();
              },
              text: "Logout",
              iconData: Icons.logout,
            ),
            const Divider(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
