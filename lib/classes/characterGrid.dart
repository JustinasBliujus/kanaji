import 'package:flutter/material.dart';
import 'package:kanaji/classes/characters.dart';
import 'package:kanaji/pages/columnPage.dart';
class CharacterGrid extends StatelessWidget {
  final List<JapaneseCharacter> characters;
  final int columns;
  final Function(JapaneseCharacter) onTap;
  final double fontSize;
  final Color cardBackgroundColor;
  final String font;

  const CharacterGrid({
    super.key,
    required this.characters,
    required this.columns,
    required this.onTap,
    required this.fontSize,
    required this.cardBackgroundColor,
    required this.font,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: columns,
      children: characters.map((character) {
        int columnIndex = characters.indexOf(character);
        Color columnColor = _getColumnColor(columnIndex);
        return InkWell(
          onTap: () {
            int startIndex = columnIndex % columns;
            List<JapaneseCharacter> column = [];
            for (int i = startIndex; i < characters.length; i += columns) {
              column.add(characters[i]);
            }
            double scrollPosition = (columnIndex ~/ columns) * 1.0;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ColumnPage(
                  column: column,
                  scrollPosition: scrollPosition,
                  initialFont: font,
                ),
              ),
            );
          },
          child: Card(
            color: columnColor, // Use color for the column
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    character.character,
                    style: TextStyle(fontSize: fontSize, fontFamily: font), // Apply selected font
                  ),
                  Text(
                    character.romanji,
                    style: TextStyle(fontSize: fontSize * 0.6, fontFamily: font), // Apply selected font
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getColumnColor(int index) {
    // Define five different colors
    List<Color> columnColors = [
      const Color(0xffFCFCFC),
      const Color(0xffededed),
      Colors.white,
      const Color(0xffededed),
      const Color(0xffFCFCFC),
    ];

    return columnColors[index % columnColors.length];
  }
}
