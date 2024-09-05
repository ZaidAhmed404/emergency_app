import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';

import '../provider/screen_provider.dart';

class OverlayLoadingWidget extends ConsumerWidget {
  OverlayLoadingWidget({
    super.key,
    required this.child,
  });

  Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(screenNotifierProvider);
    log("$isLoading");
    return LoadingOverlay(
      isLoading: isLoading,
      color: Colors.black,
      opacity: 0.5,
      progressIndicator: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
              width: 50,
              height: 50,
              child: Lottie.asset('assets/lottie/loading.json'))),
      child: child,
    );
  }
}
