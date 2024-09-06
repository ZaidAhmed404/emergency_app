import "dart:developer";

import "package:flutter_riverpod/flutter_riverpod.dart";

class ScreenNotifier extends Notifier<bool> {
  @override
  build() {
    // TODO: implement build
    return false;
  }

  updateLoading({required bool isLoading}) {
    log("$isLoading", name: "new loading");
    state = isLoading;
    log("$state", name: "new state");
  }
}

final screenNotifierProvider = NotifierProvider<ScreenNotifier, bool>(() {
  return ScreenNotifier();
});
