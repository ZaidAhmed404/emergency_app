import "dart:developer";

import "package:emergency_app/data/models/user_model.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class ScreenNotifier extends Notifier<UserModel> {
  @override
  build() {
    // TODO: implement build
    return UserModel(
        firstName: "",
        lastName: "",
        phoneNumber: "",
        photoUrl: "",
        userName: "",
        uid: "");
  }

  updateUserModel({required UserModel userModel}) {
    state = userModel;
    log("$state", name: "new state");
  }
}

final screenNotifierProvider = NotifierProvider<ScreenNotifier, UserModel>(() {
  return ScreenNotifier();
});
