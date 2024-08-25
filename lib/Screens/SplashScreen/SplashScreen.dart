import 'package:emergency_app/Screens/LoginScreen/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeSetting();
    });
  }

  initializeSetting() {
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const Center(
                child: Text(
              "Welcome",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
            const Center(
                child: Text(
              "Please Wait a while",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
            const Spacer(),
            SizedBox(
                width: 50,
                height: 50,
                child: Lottie.asset('assets/lottie/loading.json')),
          ],
        ),
      ),
    );
  }
}
