import 'package:emergency_app/presentation/provider/user_provider.dart';
import 'package:emergency_app/presentation/screens/edit_profile/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../main.dart';
import '../../../widgets/icon_button.dart';

class ProfileItemWidget extends ConsumerWidget {
  const ProfileItemWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userNotifierProvider);
    return Row(
      children: [
        ClipOval(
            child: SizedBox.fromSize(
          size: const Size.fromRadius(40),
          child: Image.network(userData.photoUrl, fit: BoxFit.fill,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
                width: 50,
                height: 50,
                child: Lottie.asset('assets/lottie/loading.json'));
          }),
        )),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ref.watch(userNotifierProvider).userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              FirebaseAuth.instance.currentUser!.email!,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        const Spacer(),
        IconButtonWidget(
          icon: Icons.arrow_forward_ios_rounded,
          onPressedFunction: () {
            navigatorKey.currentState?.pushNamed(EditProfileScreen.routeName);
          },
          iconSize: 15,
        ),
      ],
    );
  }
}
