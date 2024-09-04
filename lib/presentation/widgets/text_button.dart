import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextButtonWidget extends StatelessWidget {
  String text;
  VoidCallback function;
  bool isSelected;

  TextButtonWidget({
    super.key,
    required this.text,
    required this.function,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isSelected ? const Color(0xffE74140) : Colors.white,
            border: Border.all(
                color:
                    isSelected ? Colors.transparent : const Color(0xff1E232C)),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Text(
          text,
          style: GoogleFonts.ubuntu(
            color: isSelected ? Colors.white : const Color(0xff1E232C),
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
