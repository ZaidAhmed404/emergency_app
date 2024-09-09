import "dart:developer";

import "package:emergency_app/data/models/user_model.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class UserNotifier extends Notifier<UserModel> {
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
    log("$state", name: "new user state");
  }

  updateImage({required String url}) {
    state.photoUrl = url;
    log(state.photoUrl, name: "updated image");
  }
}

final userNotifierProvider = NotifierProvider<UserNotifier, UserModel>(() {
  return UserNotifier();
});
