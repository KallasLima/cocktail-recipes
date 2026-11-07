import 'package:flutter/material.dart';
import 'recipe.dart';
import 'theme.dart';
import 'widgets/drink_art.dart';

class RecipePage extends StatelessWidget {
  final RecipeEntity recipe;
  final int index;
  const RecipePage({super.key, required this.recipe, required this.index});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('The recipe')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            SizedBox(
              height: 230,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: DrinkArt(index: index),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              recipe.category.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                color: accent,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              recipe.name,
              style: const TextStyle(
                fontSize: 34,
                color: ink,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'SERVE IN A ${recipe.glass.toUpperCase()}',
              style: const TextStyle(
                color: Color(0xff666e5c),
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 22, color: ink),
            ),
            const SizedBox(height: 12),
            ...recipe.ingredients.map(
              (i) => Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xffdeded1))),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 85,
                      child: Text(
                        i.quantity,
                        style: const TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        i.ingredient,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text('Make it', style: TextStyle(fontSize: 22, color: ink)),
            const SizedBox(height: 12),
            Text(
              recipe.preparation,
              style: const TextStyle(
                height: 1.8,
                fontSize: 16,
                color: Color(0xff637061),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'The finishing touch',
              style: TextStyle(fontSize: 22, color: ink),
            ),
            const SizedBox(height: 12),
            Text(
              recipe.garnish,
              style: const TextStyle(
                fontSize: 16,
                height: 1.7,
                color: Color(0xff637061),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    ),
  );
}
