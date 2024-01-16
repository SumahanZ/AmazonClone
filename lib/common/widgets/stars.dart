import 'package:amazon_app/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Stars extends StatelessWidget {
  final double rating;
  const Stars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(rating: rating, itemSize: 15, itemCount: 5, direction: Axis.horizontal, itemBuilder: (context, index) {
      return const Icon(Icons.star, color: GlobalVariables.secondaryColor);
    });
  }
}