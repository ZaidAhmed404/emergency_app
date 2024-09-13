import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String name;
  final String message;
  final bool condition;
  final String imageUrl;

  const Message(
      {Key? key,
      required this.name,
      required this.message,
      required this.condition,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: condition ? Alignment.bottomRight : Alignment.bottomLeft,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                gradient: condition
                    ? const LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: condition ? null : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: condition ? Colors.transparent : Colors.blue),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(top: 10),
              // Leave space for the avatar
              child: Text(
                message,
                style: TextStyle(
                    fontSize: 14,
                    color: condition ? Colors.white : Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            top: -20,
            left: condition ? null : 10,
            right: condition ? 10 : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (condition == false)
                  CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        condition ? Colors.white : Colors.blueAccent,
                    child: Icon(
                      Icons.person,
                      color: condition ? Colors.blueAccent : Colors.white,
                    ),
                  ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                if (condition)
                  CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        condition ? Colors.white : Colors.blueAccent,
                    child: Icon(
                      Icons.person,
                      color: condition ? Colors.blueAccent : Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
