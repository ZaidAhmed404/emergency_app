import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  CategoryCard({
    required this.text,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
            height: 80,
            width: 140,
            decoration: BoxDecoration(
                color: widget.isSelected
                    ? const Color.fromARGB(255, 223, 223, 223)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10)),
            // color: Colors.amber,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15),
                  child: SizedBox(
                    width: 80,
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/icons8-circled.png'),
                    Image.asset('assets/images/icons8-accident.png')
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
