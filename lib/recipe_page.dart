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
    appBar: AppBar(
      title: Text(
        'The Mixing Book',
        style: bookTitle(28).copyWith(fontStyle: FontStyle.italic),
      ),
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 780),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 30),
          children: [
            SizedBox(
              height: 290,
              child: DrinkArt(index: index, recipeName: recipe.name),
            ),
            const SizedBox(height: 22),
            Text(recipe.name, style: bookTitle(52)),
            const SizedBox(height: 8),
            Text(
              recipe.glass,
              style: const TextStyle(fontSize: 17, color: muted),
            ),
            const SizedBox(height: 24),
            const Divider(color: accent),
            const SizedBox(height: 13),
            Text(
              'Ingredients',
              style: bookTitle(34).copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 13),
            ...recipe.ingredients.map(
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 88,
                      child: Text(
                        i.quantity,
                        style: const TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        i.ingredient,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 23),
            const Divider(color: accent),
            const SizedBox(height: 13),
            Text(
              'Make it',
              style: bookTitle(34).copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 13),
            ...recipe.preparation
                .split('. ')
                .asMap()
                .entries
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 36,
                          child: Text(
                            '${entry.key + 1}',
                            style: bookTitle(31).copyWith(color: accent),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.value.endsWith('.')
                                ? entry.value
                                : '${entry.value}.',
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.7,
                              color: ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            const Divider(color: accent),
            const SizedBox(height: 13),
            Text(
              'The finishing touch',
              style: bookTitle(32).copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
            Text(
              recipe.garnish,
              style: const TextStyle(fontSize: 17, height: 1.6, color: muted),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    ),
  );
}
