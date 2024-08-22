import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconTextWidget extends StatelessWidget {
  IconTextWidget(
      {super.key,
      required this.onPressedFunction,
      required this.iconUrl,
      required this.text});

  Function onPressedFunction;
  String iconUrl;
  String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressedFunction(),
      child: Container(
        padding:
            const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: SvgPicture.asset(
                iconUrl,
                width: 25,
                height: 25,
              ),
            ),
            Text(
              text,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
