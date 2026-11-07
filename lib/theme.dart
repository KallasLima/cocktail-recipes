import 'package:flutter/material.dart';

const ink = Color(0xfffff7ec),
    accent = Color(0xffe9c661),
    paper = Color(0xff341c2a),
    muted = Color(0xffd5c5cd),
    rule = Color(0xff785866);
TextStyle bookTitle(double size) => TextStyle(
  fontFamily: 'BookSerif',
  fontVariations: const [FontVariation('wght', 550)],
  fontSize: size,
  height: 1.06,
  color: ink,
  fontWeight: FontWeight.w500,
);
ThemeData recipeTheme() => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: accent,
    onPrimary: paper,
    surface: paper,
    onSurface: ink,
  ),
  scaffoldBackgroundColor: paper,
  fontFamily: 'BookBody',
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontVariations: [FontVariation('wght', 450)]),
    bodyMedium: TextStyle(fontVariations: [FontVariation('wght', 450)]),
    bodySmall: TextStyle(fontVariations: [FontVariation('wght', 450)]),
    labelLarge: TextStyle(fontVariations: [FontVariation('wght', 550)]),
    labelMedium: TextStyle(fontVariations: [FontVariation('wght', 500)]),
    labelSmall: TextStyle(fontVariations: [FontVariation('wght', 500)]),
    titleMedium: TextStyle(fontVariations: [FontVariation('wght', 500)]),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: paper,
    foregroundColor: ink,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xff482b3a),
    labelStyle: const TextStyle(color: muted),
    prefixIconColor: ink,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: rule),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: accent, width: 2),
    ),
  ),
);
