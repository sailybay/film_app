import 'package:flutter/material.dart';

class RatingBadge extends StatelessWidget {
  final double rating;
  final double fontSize;
  final double iconSize;
  final Color backgroundColor;

  const RatingBadge({
    super.key,
    required this.rating,
    this.fontSize = 12,
    this.iconSize = 14,
    this.backgroundColor = const Color.fromRGBO(0, 0, 0, 0.7),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.orange, size: iconSize),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}
