import 'package:emergency_app/data/models/contact_model.dart';
import 'package:emergency_app/presentation/widgets/heading_text.dart';
import 'package:flutter/material.dart';

import '../../../widgets/text_button.dart';

class ContactDetails extends StatelessWidget {
  ContactDetails(
      {super.key,
      required this.contactModel,
      required this.onCancelFunction,
      required this.onConfirmFunction});

  ContactModel contactModel;
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
            HeadingTextWidget(heading: "Contact Details", fontSize: 18),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "User Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(contactModel.userName)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Phone Number",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(contactModel.phoneNumber)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Is Contact Emergency",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("${contactModel.isEmergencyContact}")
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            HeadingTextWidget(
                heading:
                    "Would you like this contact to be updated as your emergency contact?",
                fontSize: 14),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButtonWidget(
                  buttonWidth: MediaQuery.of(context).size.width * 0.25,
                  function: () => onConfirmFunction(),
                  isSelected: false,
                  text: 'yes',
                ),
                TextButtonWidget(
                  buttonWidth: MediaQuery.of(context).size.width * 0.25,
                  function: () => onCancelFunction(),
                  isSelected: true,
                  text: 'no',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
