import 'theme.dart';
import 'widgets/drink_art.dart';
import 'recipe_page.dart';
import 'package:flutter/material.dart';
import 'recipe.dart';

void main() => runApp(const RecipesApp());

class RecipesApp extends StatelessWidget {
  final RecipeRepository? repository;
  const RecipesApp({super.key, this.repository});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Cocktail recipes',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: accent, surface: paper),
      scaffoldBackgroundColor: paper,
      appBarTheme: const AppBarTheme(
        backgroundColor: paper,
        foregroundColor: ink,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    ),
    home: HomePage(repository: repository),
  );
}

class HomePage extends StatefulWidget {
  final RecipeRepository? repository;
  const HomePage({super.key, this.repository});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final RecipeRepository repository;
  List<RecipeEntity> recipes = [];
  String query = '', category = 'All', error = '';
  bool loading = true;
  int generation = 0;
  @override
  void initState() {
    super.initState();
    repository = widget.repository ?? RecipeRepository();
    load();
  }

  Future<void> load() async {
    final current = ++generation;
    setState(() {
      loading = true;
      error = '';
    });
    try {
      final data = await repository.getAll();
      if (mounted && generation == current) {
        setState(() {
          recipes = data;
          loading = false;
        });
      }
    } catch (_) {
      if (mounted && generation == current) {
        setState(() {
          loading = false;
          error = 'We couldn’t load the recipes. Please try again.';
        });
      }
    }
  }

  @override
  void dispose() {
    generation++;
    repository.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = recipes
        .where(
          (r) =>
              (category == 'All' || r.category == category) &&
              ('${r.name} ${r.ingredients.map((i) => i.ingredient).join(' ')}')
                  .toLowerCase()
                  .contains(query.trim().toLowerCase()),
        )
        .toList();
    final categories = ['All', ...recipes.map((x) => x.category).toSet()];
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.local_bar_outlined),
            SizedBox(width: 10),
            Text(
              'THE MIXING BOOK',
              style: TextStyle(
                fontSize: 15,
                letterSpacing: 2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : error.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.menu_book_outlined, size: 44),
                        const SizedBox(height: 16),
                        Text(error, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: load,
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              repository.isDemo
                                  ? 'SIX ZERO-PROOF IDEAS'
                                  : 'YOUR RECIPE COLLECTION',
                              style: const TextStyle(
                                color: accent,
                                fontSize: 10,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'A little ritual.\nA good mix.',
                              style: TextStyle(
                                fontSize: 40,
                                height: 1.05,
                                color: ink,
                                letterSpacing: -1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Simple ingredients, clear steps and something worth making.',
                              style: TextStyle(
                                color: Color(0xff666e5c),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 22),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Search recipes or ingredients',
                                prefixIcon: Icon(Icons.search),
                              ),
                              onChanged: (x) => setState(() => query = x),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: categories
                                  .map(
                                    (x) => ChoiceChip(
                                      label: Text(x),
                                      selected: category == x,
                                      onSelected: (_) =>
                                          setState(() => category = x),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              '${visible.length} recipes${repository.isDemo ? ' · Original demo collection' : ''}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xff666e5c),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    if (visible.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.search_off,
                                size: 42,
                                color: accent,
                              ),
                              const SizedBox(height: 12),
                              const Text('No recipes match this mix.'),
                              TextButton(
                                onPressed: () =>
                                    setState(() => category = 'All'),
                                child: const Text('Show all categories'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverLayoutBuilder(
                          builder: (context, constraints) {
                            final cols = constraints.crossAxisExtent > 780
                                ? 3
                                : constraints.crossAxisExtent > 500
                                ? 2
                                : 1;
                            return SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: cols,
                                    mainAxisExtent: 290,
                                    mainAxisSpacing: 18,
                                    crossAxisSpacing: 18,
                                  ),
                              delegate: SliverChildBuilderDelegate((
                                context,
                                i,
                              ) {
                                final r = visible[i];
                                final index = recipes.indexOf(r);
                                return Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 0,
                                  color: Colors.white,
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            RecipePage(recipe: r, index: index),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(child: DrinkArt(index: index)),
                                        Padding(
                                          padding: const EdgeInsets.all(18),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                r.category.toUpperCase(),
                                                style: const TextStyle(
                                                  fontSize: 9,
                                                  color: accent,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                r.name,
                                                style: const TextStyle(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w500,
                                                  color: ink,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${r.ingredients.length} ingredients · ${r.glass}',
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Color(0xff666e5c),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_forward,
                                                    size: 18,
                                                    color: accent,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }, childCount: visible.length),
                            );
                          },
                        ),
                      ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Made to explore, one recipe at a time.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xff666e5c),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
