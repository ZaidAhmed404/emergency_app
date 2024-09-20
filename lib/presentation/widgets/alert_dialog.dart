import 'package:emergency_app/presentation/widgets/text_button.dart';
import 'package:flutter/material.dart';

class AlertDialogWidget extends StatelessWidget {
  AlertDialogWidget({super.key, required this.message, required this.title});

  String title;
  String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 120,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Color(0xffE74140),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: const Icon(
                Icons.warning_amber,
                color: Colors.white,
                size: 80,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    message,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButtonWidget(
                    buttonWidth: MediaQuery.of(context).size.width * 0.6,
                    function: () {
                      Navigator.pop(context);
                    },
                    isSelected: true,
                    text: 'Okay',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
