import 'dart:developer';

import 'package:emergency_app/presentation/screens/emergency/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../../widgets/heading_text.dart';

class EmergencyScreen extends StatefulWidget {
  EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  TwilioFlutter? twilioFlutter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC909353b4c667a622d0515ae7909e8282',
        authToken: '2a1aa1fe8957e44f640d51a6c300afc4',
        twilioNumber: '+13612829068');
  }

  List<Map> cards = [
    {'title': 'Theft Spotted', 'body': 'He Got Robbed Help Him'},
    {'title': 'I Have Accident', 'body': 'Accident Spotted Help Him'},
    {'title': 'I Am Injured', 'body': 'Help Him He is Injued'},
    {'title': 'Petrol Need', 'body': 'He Need Petrol Help Him'},
  ];

  int _selectedCategoryIndex = 0;
  String? selectedText;
  String? selectedBody;

  sendSms() async {
    final response = await twilioFlutter!
        .sendSMS(toNumber: "+923174703741", messageBody: 'Hello World');
    log("${response}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingTextWidget(heading: "Emergency Help Needed?", fontSize: 25),
            const Spacer(),
            InkWell(
                onTap: () {
                  sendSms();
                },
                child: Center(
                    child: Image.asset('assets/images/Alertbutton.png'))),
            const Spacer(),
            Center(
              child: HeadingTextWidget(
                  heading: "Choose the emergency Situation", fontSize: 14),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 130,
              width: 400,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      text: cards[index]['title'],
                      isSelected: _selectedCategoryIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                          selectedText = cards[index]['title'];
                          selectedBody = cards[index]['body'];
                        });
                      },
                    );
                  }),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
