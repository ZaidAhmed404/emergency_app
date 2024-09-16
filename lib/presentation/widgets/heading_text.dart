import 'package:flutter/material.dart';

class HeadingTextWidget extends StatelessWidget {
  HeadingTextWidget({super.key, required this.heading, required this.fontSize});

  String heading;
  double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: fontSize),
      textAlign: TextAlign.center,
    );
  }
}
