import 'package:flutter/material.dart';

import '../../../../core/color_constants.dart';
import '../../../widgets/icon_button.dart';

class ItemWidget extends StatelessWidget {
  ItemWidget(
      {super.key,
      required this.onPressedFunction,
      required this.text,
      required this.iconData});

  String text;
  Function() onPressedFunction;
  IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorConstants().primaryColor.withOpacity(0.2)),
          child: Icon(
            iconData,
            color: ColorConstants().primaryColor,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const Spacer(),
        IconButtonWidget(
          icon: Icons.arrow_forward_ios_rounded,
          isFilled: true,
          onPressedFunction: onPressedFunction,
          iconSize: 15,
        ),
      ],
    );
  }
}
