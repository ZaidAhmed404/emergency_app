import 'package:emergency_app/presentation/widgets/heading_text.dart';
import 'package:flutter/material.dart';

import '../../widgets/icon_button.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});

  static const routeName = "/About-Screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: [
                  IconButtonWidget(
                    icon: Icons.arrow_back,
                    onPressedFunction: () {
                      Navigator.pop(context);
                    },
                    iconSize: 20,
                    isFilled: true,
                  ),
                  const Spacer(),
                  HeadingTextWidget(
                    heading: "About",
                    fontSize: 25,
                  ),
                  const Spacer(),
                ],
              ),
              Center(
                child: Image.asset(
                  'assets/icons/Logo.png',
                  width: 200,
                  height: 200,
                ),
              ),
              Center(
                child: HeadingTextWidget(
                  heading: 'Ice Help Hand',
                  fontSize: 20,
                ),
              ),
              const Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const Text(
                'ICE Help hand is a platform or an app where any Individual gets help in case of emergency. This app is for individuals who are in any emergency such as theft, accident, harassment etc. Alert will be generated from victim end and will be popped on devices that are nearby in specific radius and will send message to the specific selected contacts so that the victim gets help from those who are nearby.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const Center(
                child: Text(
                  'Contact Us at',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Center(child: Text('AdminIceHelpHand@gmail.com')),
            ],
          ),
        ),
      ),
    );
  }
}
