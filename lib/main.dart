import 'package:flutter/material.dart';
import 'package:kanaji/pages/home.dart';
import 'package:kanaji/pages/columnPage.dart';
import 'package:kanaji/pages/flashcards.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => const Home(),
      '/column': (context) => const ColumnPage(column: [],scrollPosition: 0,initialFont: 'Default',),
      "/flashcards": (context) => const FlashCards(currentIndex: 0,initialFont: 'Default',),

    },
  ));
}
