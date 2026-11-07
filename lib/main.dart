import 'package:flutter/foundation.dart';
import 'package:flutter/semantics.dart';
import 'theme.dart';
import 'widgets/drink_art.dart';
import 'recipe_page.dart';
import 'package:flutter/material.dart';
import 'recipe.dart';

SemanticsHandle? _webSemantics;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Keep the small web app accessible without an invisible activation gesture.
  if (kIsWeb) _webSemantics ??= SemanticsBinding.instance.ensureSemantics();
  runApp(const RecipesApp());
}

class RecipesApp extends StatelessWidget {
  final RecipeRepository? repository;
  const RecipesApp({super.key, this.repository});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Cocktail recipes',
    theme: recipeTheme(),
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
  final searchController = TextEditingController();
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
    searchController.dispose();
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
        toolbarHeight: 68,
        title: Row(
          children: [
            Text(
              'The Mixing Book',
              style: bookTitle(29).copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(width: 22),
            const Expanded(child: Divider(color: accent)),
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
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.menu_book_outlined,
                          size: 44,
                          color: accent,
                        ),
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
                      padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              repository.isDemo
                                  ? 'The zero-proof\nrecipe book.'
                                  : 'The recipe book.',
                              style: bookTitle(52),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              repository.isDemo
                                  ? 'Six original drinks. Find your next mix.'
                                  : 'Find your next mix.',
                              style: const TextStyle(
                                color: muted,
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                labelText: 'Search recipes or ingredients',
                                prefixIcon: Icon(Icons.search),
                              ),
                              onChanged: (value) =>
                                  setState(() => query = value),
                            ),
                            const SizedBox(height: 14),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: categories
                                    .map(
                                      (value) => Padding(
                                        padding: const EdgeInsets.only(
                                          right: 20,
                                        ),
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: category == value
                                                    ? accent
                                                    : Colors.transparent,
                                                width: 3,
                                              ),
                                            ),
                                          ),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: category == value
                                                  ? accent
                                                  : ink,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 2,
                                                    vertical: 12,
                                                  ),
                                            ),
                                            onPressed: () => setState(
                                              () => category = value,
                                            ),
                                            child: Text(value),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            const Divider(color: rule, height: 1),
                            const SizedBox(height: 15),
                            Text(
                              '${visible.length} recipes${repository.isDemo ? ' · Original demo collection' : ''}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: muted,
                              ),
                            ),
                            const SizedBox(height: 10),
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
                                color: accent,
                                size: 36,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No recipes match this mix.',
                                style: bookTitle(27),
                              ),
                              TextButton(
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {
                                    query = '';
                                    category = 'All';
                                  });
                                },
                                child: const Text('Clear filters'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        sliver: SliverList.builder(
                          itemCount: visible.length,
                          itemBuilder: (context, i) {
                            final recipe = visible[i];
                            final index = recipes.indexOf(recipe);
                            return _RecipeEntry(
                              recipe: recipe,
                              index: index,
                              open: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      RecipePage(recipe: recipe, index: index),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(22),
                        child: Text(
                          'Original recipes · Illustrative drink photography',
                          style: TextStyle(color: muted, fontSize: 11),
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

class _RecipeEntry extends StatelessWidget {
  final RecipeEntity recipe;
  final int index;
  final VoidCallback open;
  const _RecipeEntry({
    required this.recipe,
    required this.index,
    required this.open,
  });
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: rule)),
      ),
      child: InkWell(
        onTap: open,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width < 500 ? 116 : 190,
                height: 112,
                child: DrinkArt(index: index, recipeName: recipe.name),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.category,
                      style: const TextStyle(color: muted, fontSize: 11),
                    ),
                    const SizedBox(height: 5),
                    Text(recipe.name, style: bookTitle(29)),
                    const SizedBox(height: 8),
                    Text(
                      '${recipe.ingredients.length} ingredients',
                      style: const TextStyle(color: muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, color: accent, size: 23),
            ],
          ),
        ),
      ),
    ),
  );
}
