import 'package:emergency_app/presentation/widgets/text_button.dart';
import 'package:flutter/material.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  ConfirmationDialogWidget(
      {super.key,
      required this.message,
      required this.onCancelFunction,
      required this.onConfirmFunction,
      required this.title});

  String title;
  String message;
  Function() onConfirmFunction;
  Function() onCancelFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButtonWidget(
                  buttonWidth: MediaQuery.of(context).size.width * 0.35,
                  function: () => onCancelFunction(),
                  isSelected: false,
                  text: 'Cancel',
                ),
                TextButtonWidget(
                  buttonWidth: MediaQuery.of(context).size.width * 0.35,
                  function: () => onConfirmFunction(),
                  isSelected: true,
                  text: 'Ok',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
