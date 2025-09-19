import 'package:flutter/material.dart';

class Stars extends StatelessWidget {
  final String rating;
  const Stars({super.key, required this.rating});

  List<Widget> buildStars(double rating) {
    int filledStars = rating.floor();
    int totalStars = 5;
    return List.generate(totalStars, (index) {
      if (index < filledStars) {
        return const Icon(Icons.star_rounded, color: Colors.amber, size: 24);
      } else {
        return const Icon(Icons.star_rounded,
            color: Color.fromRGBO(18, 18, 18, 1), size: 24);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double parsedRating = double.tryParse(rating) ?? 0.0;

    return Row(
      children: [
        ...buildStars(parsedRating),
        const SizedBox(width: 4),
        Text(
          "(${parsedRating.toStringAsFixed(1)})",
          style: const TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.4,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}
