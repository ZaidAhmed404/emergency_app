import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallButtonWidget extends StatelessWidget {
  CallButtonWidget(
      {super.key,
      required this.isVideoCall,
      required this.targetUserId,
      required this.targetUserName,
      required this.targetUserPhotoUrl});

  bool isVideoCall;
  String targetUserId;
  String targetUserName;

  String targetUserPhotoUrl;

  @override
  Widget build(BuildContext context) {
    return ZegoSendCallInvitationButton(
      padding: EdgeInsets.zero,
      iconSize: const Size(40, 40),
      margin: EdgeInsets.zero,
      buttonSize: const Size(40, 40),
      isVideoCall: isVideoCall,
      resourceID: "ic_helper",
      onPressed: (_, __, ___) {},
      invitees: [
        ZegoUIKitUser(
          id: targetUserId,
          name: targetUserName,
        ),
      ],
    );
  }
}
