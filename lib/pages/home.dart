import 'package:flutter/material.dart';
import 'package:kanaji/classes/characters.dart';
import 'package:kanaji/classes/characterGrid.dart';
import 'package:kanaji/classes/kanji.dart';
import 'package:kanaji/classes/alertDialogFonts.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  JapaneseCharacter? selectedCharacter;
  int selectedCharacterIndex = 0;
  int _selectedIndex = 0;
  String _selectedFont = 'DefaultFont';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Method to show font selector dialog
  void _showFontSelector(BuildContext context) {
    showFontSelectorDialog(context, (selectedFont) {
      setState(() {
        _selectedFont = selectedFont;
      });
    })();
  }
  @override
  Widget build(BuildContext context) {
    List<Hiragana> basicHiraganaList = HiraganaData.hiraganaList
        .where((character) => !character.isYoon)
        .toList();

    List<Katakana> basicKatakanaList = KatakanaData.katakanaList
        .where((character) => !character.isYoon)
        .toList();

    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.white,
            height: 1.0,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showFontSelector(context);
            },
            icon: const Icon(Icons.text_fields),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/flashcards", arguments: {
                'currentIndex': _selectedIndex,
                'initialFont': _selectedFont,
              });
            },
            icon: const Icon(Icons.quiz),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.orange,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Text("平仮名"),
              label: 'Hiragana',
            ),
            BottomNavigationBarItem(
              icon: Text("片仮名"),
              label: 'Katakana',
            ),
            BottomNavigationBarItem(
              icon: Text("漢字"),
              label: 'Kanji',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.orange,
          onTap: _onItemTapped,
          selectedFontSize: 18,
          unselectedFontSize: 15,
        ),
      ),
      body: _getBodyContent(
        _selectedIndex,
        basicHiraganaList,
        basicKatakanaList,
      ),
    );
  }

  Widget _getBodyContent(
      int index,
      List<Hiragana> hiraganaCharacters,
      List<Katakana> katakanaCharacters,
      ) {
    switch (index) {
      case 0:
        return selectedCharacter == null
            ? CharacterGrid(
          characters: hiraganaCharacters,
          columns: 5,
          fontSize: 24.0,
          font: _selectedFont, // Pass selected font to CharacterGrid
          onTap: (character) {
            setState(() {
              selectedCharacter = character;
              selectedCharacterIndex =
                  hiraganaCharacters.indexOf(character as Hiragana);
            });
          },
          cardBackgroundColor: Colors.orange.shade100,
        )
            : CharacterGrid(
          characters: hiraganaCharacters,
          columns: 1,
          fontSize: 24.0,
          font: _selectedFont, // Pass selected font to CharacterGrid
          onTap: (character) {
            setState(() {
              selectedCharacter = null;
              selectedCharacterIndex = 0;
            });
          },
          cardBackgroundColor: Colors.orange.shade100,
        );
      case 1:
        return selectedCharacter == null
            ? CharacterGrid(
          characters: katakanaCharacters,
          columns: 5,
          fontSize: 24.0,
          font: _selectedFont, // Pass selected font to CharacterGrid
          onTap: (character) {
            setState(() {
              selectedCharacter = character;
              selectedCharacterIndex =
                  katakanaCharacters.indexOf(character as Katakana);
            });
          },
          cardBackgroundColor: Colors.orange.shade100,
        )
            : CharacterGrid(
          characters: katakanaCharacters,
          columns: 1,
          fontSize: 24.0,
          font: _selectedFont, // Pass selected font to CharacterGrid
          onTap: (character) {
            setState(() {
              selectedCharacter = null;
              selectedCharacterIndex = 0;
            });
          },
          cardBackgroundColor: Colors.orange.shade100,
        );
      case 2:
        return const KanjiListPage();
      default:
        return Container();
    }
  }
}

class KanjiListPage extends StatelessWidget {
  const KanjiListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: kanjiList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'On\'yomi Latin: ${kanjiList[index].onyomiLatin.join(", ")}',
                        style: const TextStyle(fontSize: 24),
                      ),
                      const Text(
                        'On\'yomi Kana:',
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        kanjiList[index].onyomiKana.join(", "),
                        style: const TextStyle(fontSize: 54),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Kun\'yomi Latin: ${kanjiList[index].kunyomiLatin.join(", ")}',
                        style: const TextStyle(fontSize: 24),
                      ),
                      const Text(
                        'Kun\'yomi Kana: ',
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        kanjiList[index].kunyomiKana.join(", "),
                        style: const TextStyle(fontSize: 54),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Meaning: ${kanjiList[index].meaning}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Card(
            child: ListTile(
              title: Text(
                kanjiList[index].character,
                style: const TextStyle(fontSize: 150),
              ),
              subtitle: Text(
                kanjiList[index].meaning,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        );
      },
    );
  }
}
