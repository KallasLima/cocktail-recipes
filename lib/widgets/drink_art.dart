import 'package:flutter/material.dart';
import '../theme.dart';

class DrinkArt extends StatelessWidget {
  final int index;
  final String? recipeName;
  const DrinkArt({super.key, required this.index, this.recipeName});
  static const images = {
    'Citrus spritz': 'citrus',
    'Ginger lime cooler': 'ginger',
    'Berry garden': 'berry',
    'Cucumber fizz': 'cucumber',
    'Pineapple sunset': 'pineapple',
    'Mint tea tonic': 'mint',
  };
  @override
  Widget build(BuildContext context) {
    final image = images[recipeName];
    return image == null
        ? const ColoredBox(
            color: Color(0xff482b3a),
            child: Center(
              child: Icon(Icons.local_bar_outlined, size: 54, color: accent),
            ),
          )
        : Image.asset(
            'assets/drinks/$image.webp',
            fit: BoxFit.cover,
            semanticLabel: 'Illustrative ${recipeName!.toLowerCase()}',
            errorBuilder: (_, error, stack) => const ColoredBox(
              color: paper,
              child: Center(
                child: Icon(Icons.local_bar_outlined, color: accent, size: 54),
              ),
            ),
          );
  }
}
