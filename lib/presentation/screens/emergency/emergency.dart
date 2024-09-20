import 'dart:developer';

import 'package:emergency_app/data/models/contact_model.dart';
import 'package:emergency_app/presentation/controllers/contacts_controller.dart';
import 'package:emergency_app/presentation/controllers/notification_controller.dart';
import 'package:emergency_app/presentation/controllers/user_controller.dart';
import 'package:emergency_app/presentation/provider/user_provider.dart';
import 'package:emergency_app/presentation/screens/emergency/widgets/category_card.dart';
import 'package:emergency_app/presentation/widgets/overlay_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:telephony/telephony.dart';

import '../../widgets/heading_text.dart';

class EmergencyScreen extends ConsumerStatefulWidget {
  EmergencyScreen({super.key});

  @override
  ConsumerState<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends ConsumerState<EmergencyScreen> {
  List<Map> cards = [
    {
      'title': 'Theft Spotted',
      'body': 'has been robbed! Immediate help required.'
    },
    {
      'title': 'Have Accident',
      'body': 'has been in an accident! Immediate assistance needed!'
    },
    {
      'title': 'Heavily Injured',
      'body': 'is injured and needs immediate help!'
    },
    {
      'title': 'Petrol Needed',
      'body': 'is out of petrol and needs assistance!'
    },
  ];

  final ContactsController _contactController = GetIt.I<ContactsController>();

  final NotificationController _notificationController =
      GetIt.I<NotificationController>();

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
    setState(() {
      isLoading = true;
    });
    await askPermission();
    await getEmergencyContacts();
    await getEmergencyContactTokens();
    setState(() {
      isLoading = false;
    });
  }

  Future getEmergencyContacts() async {
    emergencyContacts = await _contactController.handleGetEmergencyContacts();
  }

  Future getEmergencyContactTokens() async {
    tokens = await _userController
        .handleGetEmergencyContactTokens(emergencyContacts);
  }

  Future askPermission() async {
    await telephony.requestPhoneAndSmsPermissions;
  }

  sendNotifications() async {
    for (int index = 0; index < tokens.length; index++) {
      await _notificationController.handleSendingNotification(
          token: tokens[index],
          title: cards[_selectedCategoryIndex]['title'],
          body:
              "${ref.watch(userNotifierProvider).userName} ${cards[_selectedCategoryIndex]['body']}\nPhone Number:${ref.watch(userNotifierProvider).phoneNumber}");
    }
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
                  onTap: () async {
                    // sendSms();
                    setState(() {
                      isLoading = true;
                    });
                    await sendNotifications();
                    setState(() {
                      isLoading = false;
                    });
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
