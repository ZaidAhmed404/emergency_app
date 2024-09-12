import 'package:flutter/material.dart';

import '../../core/color_constants.dart';

class IconButtonWidget extends StatelessWidget {
  IconButtonWidget(
      {super.key,
      required this.icon,
      required this.onPressedFunction,
      required this.iconSize,
      required this.isFilled});

  IconData icon;
  Function() onPressedFunction;
  double iconSize;
  bool isFilled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressedFunction,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isFilled ? ColorConstants().primaryColor : Colors.white,
            border: Border.all(color: ColorConstants().primaryColor),
            boxShadow: const [
              BoxShadow(
                color: Color(0xffE74140),
                blurRadius: 3,
                offset: Offset(0, 1), // Shadow position
              ),
            ],
            borderRadius: BorderRadius.circular(10)),
        child: Icon(
          icon,
          color: isFilled ? Colors.white : ColorConstants().primaryColor,
          size: iconSize,
        ),
      ),
    );
  }
}
