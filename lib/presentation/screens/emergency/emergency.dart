import 'package:emergency_app/presentation/screens/emergency/widgets/category_card.dart';
import 'package:flutter/material.dart';

import '../../widgets/heading_text.dart';

class EmergencyScreen extends StatefulWidget {
  EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<Map> cards = [
    {'title': 'Theft Spotted', 'body': 'He Got Robbed Help Him'},
    {'title': 'I Have Accident', 'body': 'Accident Spotted Help Him'},
    {'title': 'I Am Injured', 'body': 'Help Him He is Injured'},
    {'title': 'Petrol Need', 'body': 'He Need Petrol Help Him'},
  ];

  int _selectedCategoryIndex = 0;
  String? selectedText;
  String? selectedBody;

  sendSms() async {}

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
