import 'dart:developer';

import 'package:emergency_app/data/models/contact_model.dart';
import 'package:emergency_app/presentation/controllers/contacts_controller.dart';
import 'package:emergency_app/presentation/controllers/user_controller.dart';
import 'package:emergency_app/presentation/screens/emergency/widgets/category_card.dart';
import 'package:emergency_app/presentation/widgets/overlay_loading.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:telephony/telephony.dart';

import '../../widgets/heading_text.dart';

class EmergencyScreen extends StatefulWidget {
  EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  List<Map> cards = [
    {'title': 'Theft Spotted', 'body': 'He Got Robbed Help Him'},
    {'title': 'I Have Accident', 'body': 'Accident Spotted Help Him'},
    {'title': 'I Am Injured', 'body': 'Help Him He is Injured'},
    {'title': 'Petrol Need', 'body': 'He Need Petrol Help Him'},
  ];

  final ContactsController _contactController = GetIt.I<ContactsController>();
  final UserController _userController = GetIt.I<UserController>();

  List<ContactModel> emergencyContacts = [];
  List<String> tokens = [];

  final Telephony telephony = Telephony.instance;

  int _selectedCategoryIndex = 0;
  String? selectedText;
  String? selectedBody;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeSetting();
  }

  Future initializeSetting() async {
    await askPermission();
    await getEmergencyContacts();
    await getEmergencyContactTokens();
  }

  Future getEmergencyContacts() async {
    setState(() {
      isLoading = true;
    });
    emergencyContacts = await _contactController.handleGetEmergencyContacts();

    setState(() {
      isLoading = false;
    });
  }

  Future getEmergencyContactTokens() async {
    setState(() {
      isLoading = true;
    });
    tokens = await _userController
        .handleGetEmergencyContactTokens(emergencyContacts);
    setState(() {
      isLoading = false;
    });
  }

  Future askPermission() async {
    setState(() {
      isLoading = true;
    });
    await telephony.requestPhoneAndSmsPermissions;
    setState(() {
      isLoading = false;
    });
  }

  sendSms() async {
    final SmsSendStatusListener listener = (SendStatus status) {
      log("${status}", name: 'status');
    };

    telephony.sendSms(
        to: "+923174703741", message: "Hello World", statusListener: listener);
  }

  @override
  Widget build(BuildContext context) {
    return OverlayLoadingWidget(
      isLoading: isLoading,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingTextWidget(
                  heading: "Emergency Help Needed?", fontSize: 25),
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
      ),
    );
  }
}
