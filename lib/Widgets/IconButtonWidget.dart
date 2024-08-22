import 'package:emergency_app/Constants/ColorConstants.dart';
import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  IconButtonWidget(
      {super.key, required this.icon, required this.onPressedFunction});

  IconData icon;
  Function() onPressedFunction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressedFunction,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: ColorConstants().primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
