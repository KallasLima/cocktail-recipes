import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:cocktail_recipes/recipe.dart';
import 'package:cocktail_recipes/main.dart';

class LoadedRecipes extends RecipeRepository {
  final List<RecipeEntity> data;
  LoadedRecipes(this.data);
  @override
  Future<List<RecipeEntity>> getAll() async => data;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'bundled collection validates ingredient amounts and preparation',
    () async {
      final repo = RecipeRepository();
      final all = await repo.getAll();
      expect(all.length, 6);
      expect(all.first.ingredients.first.amount, 80.0);
      expect(all.first.ingredients.first.quantity, '80 ml');
      repo.close();
      expect(
        () => IngredientEntity.fromJson({
          'unit': 'ml',
          'ingredient': 'juice',
          'amount': 0,
        }),
        throwsFormatException,
      );
    },
  );
  test('remote HTTP errors are awaited and can be retried', () async {
    var count = 0;
    final repo = RecipeRepository(
      url: 'https://example.test/recipes',
      client: MockClient((_) async {
        count++;
        return http.Response(
          count == 1 ? 'unavailable' : '[]',
          count == 1 ? 503 : 200,
        );
      }),
    );
    await expectLater(repo.getAll(), throwsException);
    expect(await repo.getAll(), isEmpty);
    repo.close();
  });
  testWidgets('ingredient search opens a complete scrollable recipe', (
    tester,
  ) async {
    final data = await tester.runAsync(() => RecipeRepository().getAll());
    await tester.pumpWidget(RecipesApp(repository: LoadedRecipes(data!)));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'orange');
    await tester.pumpAndSettle();
    expect(find.text('2 recipes · Original demo collection'), findsOneWidget);
    await tester.ensureVisible(find.text('Citrus spritz'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Citrus spritz'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Ingredients'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Ingredients'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('The finishing touch'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('A thin orange wheel'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
