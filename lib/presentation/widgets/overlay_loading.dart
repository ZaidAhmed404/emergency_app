import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';

class OverlayLoadingWidget extends StatefulWidget {
  OverlayLoadingWidget(
      {super.key, required this.child, required this.isLoading});

  Widget child;
  bool isLoading;

  @override
  State<OverlayLoadingWidget> createState() => _OverlayLoadingWidgetState();
}

class _OverlayLoadingWidgetState extends State<OverlayLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: widget.isLoading,
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
      child: widget.child,
    );
  }
}
