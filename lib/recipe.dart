import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class IngredientEntity {
  final String unit, ingredient;
  final double amount;
  const IngredientEntity({
    required this.unit,
    required this.ingredient,
    required this.amount,
  });
  factory IngredientEntity.fromJson(Map<String, dynamic> json) {
    if (json['unit'] is! String ||
        json['ingredient'] is! String ||
        json['amount'] is! num ||
        (json['amount'] as num) <= 0) {
      throw const FormatException('Invalid ingredient.');
    }
    return IngredientEntity(
      unit: json['unit'],
      ingredient: json['ingredient'],
      amount: (json['amount'] as num).toDouble(),
    );
  }
  String get quantity =>
      '${amount == amount.roundToDouble() ? amount.toInt() : amount} $unit';
}

class RecipeEntity {
  final String name, glass, category, garnish, preparation;
  final List<IngredientEntity> ingredients;
  const RecipeEntity({
    required this.name,
    required this.glass,
    required this.category,
    required this.garnish,
    required this.preparation,
    required this.ingredients,
  });
  factory RecipeEntity.fromJson(Map<String, dynamic> json) {
    for (final field in [
      'name',
      'glass',
      'category',
      'garnish',
      'preparation',
    ]) {
      if (json[field] is! String || (json[field] as String).trim().isEmpty) {
        throw FormatException('Invalid recipe $field.');
      }
    }
    final ingredients = (json['ingredients'] as List)
        .map((x) => IngredientEntity.fromJson(x))
        .toList();
    if (ingredients.isEmpty) {
      throw const FormatException('Recipe has no ingredients.');
    }
    return RecipeEntity(
      name: json['name'],
      glass: json['glass'],
      category: json['category'],
      garnish: json['garnish'],
      preparation: json['preparation'],
      ingredients: ingredients,
    );
  }
}

class RecipeRepository {
  final http.Client client;
  final String url;
  RecipeRepository({
    http.Client? client,
    this.url = const String.fromEnvironment('RECIPE_URL'),
  }) : client = client ?? http.Client();
  bool get isDemo => url.isEmpty;
  Future<List<RecipeEntity>> getAll() async {
    String data;
    if (isDemo) {
      data = await rootBundle.loadString('assets/recipes.json');
    } else {
      final uri = Uri.parse(url);
      if (uri.scheme != 'https') {
        throw const FormatException('Recipe feeds must use HTTPS.');
      }
      final response = await client
          .get(uri)
          .timeout(const Duration(seconds: 12));
      if (response.statusCode != 200) {
        throw Exception('Recipe feed returned ${response.statusCode}.');
      }
      data = response.body;
    }
    final json = jsonDecode(data) as List<dynamic>;
    return json
        .map((x) => RecipeEntity.fromJson(x as Map<String, dynamic>))
        .toList();
  }

  void close() => client.close();
}
