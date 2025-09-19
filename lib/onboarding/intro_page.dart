import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  final dynamic description;
  final dynamic title;
  final dynamic image;

  const IntroPage(
      {super.key,
      required this.title,
      required this.description,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 0),
          Image.asset(
            image,
            width: 320,
            height: 320,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Roboto",
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400,
              fontSize: 16,
              height: 1.5,
              letterSpacing: 0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
