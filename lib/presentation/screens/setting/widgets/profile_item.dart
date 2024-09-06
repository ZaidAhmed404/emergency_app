import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../widgets/icon_button.dart';

class ProfileItemWidget extends StatelessWidget {
  const ProfileItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
            child: SizedBox.fromSize(
          size: const Size.fromRadius(40), // Image radius
          child: Image.network(FirebaseAuth.instance.currentUser!.photoURL!,
              fit: BoxFit.fill, loadingBuilder: (BuildContext context,
                  Widget child, ImageChunkEvent? loadingProgress) {
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
              FirebaseAuth.instance.currentUser!.displayName!,
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
          onPressedFunction: () {},
          iconSize: 15,
        ),
      ],
    );
  }
}
