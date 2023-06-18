import 'package:flutter/material.dart';

Widget buildRatingStars(double rating) {
  final List<Widget> stars = [];
  final int fullStars = rating.floor(); // Number of full stars
  final bool hasHalfStar =
      (rating - fullStars) > 0; // Check if there is a half star

  // Add full stars
  for (int i = 0; i < fullStars; i++) {
    stars.add(
      const Icon(
        Icons.star,
        color: Colors.amber,
        size: 14,
      ),
    );
  }

  // Add half star if necessary
  if (hasHalfStar) {
    stars.add(
      const Icon(
        Icons.star_half,
        color: Colors.amber,
        size: 14,
      ),
    );
  }

  return Row(
    children: stars,
  );
}
