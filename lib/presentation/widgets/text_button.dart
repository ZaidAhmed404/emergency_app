import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextButtonWidget extends StatelessWidget {
  String text;
  VoidCallback function;
  bool isSelected;

  double buttonWidth;

  TextButtonWidget({
    super.key,
    required this.text,
    required this.function,
    required this.isSelected,
    required this.buttonWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: buttonWidth,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffE74140) : Colors.white,
          border: Border.all(
              color: isSelected ? Colors.transparent : const Color(0xffE74140)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: const [
            BoxShadow(
              color: Color(0xffE74140),
              blurRadius: 3,
              offset: Offset(0, 1), // Shadow position
            ),
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.ubuntu(
              color: isSelected ? Colors.white : const Color(0xffE74140),
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
