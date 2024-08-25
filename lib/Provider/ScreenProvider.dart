import "package:flutter_riverpod/flutter_riverpod.dart";

bool isLoading = false;

class NameNotifier extends Notifier<bool> {
  @override
  build() {
    // TODO: implement build
    return isLoading;
  }

  updateName({required bool newIsLoading}) {
    isLoading = newIsLoading;
  }
}

final nameNotifierProvider = NotifierProvider<NameNotifier, bool>(() {
  return NameNotifier();
});
