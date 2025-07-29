import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kanaji/classes/characters.dart';

class ColumnPage extends StatefulWidget {
  final List<JapaneseCharacter> column;
  final double scrollPosition;
  final String initialFont;

  const ColumnPage({
    super.key,
    required this.column,
    required this.scrollPosition,
    required this.initialFont,
  });

  @override
  State<ColumnPage> createState() => _ColumnPageState();
}

class _ColumnPageState extends State<ColumnPage> {
  late String _selectedFont;
  final FlutterTts flutterTts = FlutterTts();

  Future<void> speak(String text)async{
    await flutterTts.setLanguage('ja-JP');
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.6);
    await flutterTts.speak(text);
  }
  @override
  void initState() {
    super.initState();
    _selectedFont = widget.initialFont;
  }

  void _showFontSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: const Center(
              child: Text(
                'Select Font',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  title: const Text('Default'),
                  onTap: () {
                    setState(() {
                      _selectedFont = 'Default';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  height: 2,
                  color: Colors.orange,
                ),
                ListTile(
                  title: const Text('Rounded'),
                  onTap: () {
                    setState(() {
                      _selectedFont = 'Rounded';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  height: 2,
                  color: Colors.orange,
                ),
                ListTile(
                  title: const Text('Caligraphy 1'),
                  onTap: () {
                    setState(() {
                      _selectedFont = 'Mincho';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  height: 2,
                  color: Colors.orange,
                ),
                ListTile(
                  title: const Text('Caligraphy 2'),
                  onTap: () {
                    setState(() {
                      _selectedFont = 'Gakuran';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  height: 2,
                  color: Colors.orange,
                ),
                ListTile(
                  title: const Text('Caligraphy 3'),
                  onTap: () {
                    setState(() {
                      _selectedFont = 'Amakara';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  height: 2,
                  color: Colors.orange,
                ),
                ListTile(
                  title: const Text('Display 1'),
                  onTap: () {
                    setState(() {
                      _selectedFont = 'Curul';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  height: 2,
                  color: Colors.orange,
                ),
                ListTile(
                  title: const Text('Display 2'),
                  onTap: () {
                    setState(() {
                      _selectedFont = 'Humour';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  height: 2,
                  color: Colors.orange,
                ),
                ListTile(
                  title: const Text('Display 3'),
                  onTap: () {
                    setState(() {
                      _selectedFont = 'Reggae';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<JapaneseCharacter> filteredColumn =
    widget.column.where((character) => character.character != "-").toList();
    int cardHeight = 360;
    double cardDivider = widget.scrollPosition * 23;
    ScrollController scrollController =
    ScrollController(initialScrollOffset: (widget.scrollPosition * cardHeight + cardDivider));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            onPressed: () {
              _showFontSelector(context);
            },
            icon: const Icon(Icons.font_download),
          ),
        ],
      ),
      body: ListView.builder(
        controller: scrollController,
        itemCount: filteredColumn.length,
        itemBuilder: (BuildContext context, int index) {
          JapaneseCharacter character = filteredColumn[index];
          Color itemColor = _getItemColor(index);
          return InkWell(
            onTap: () {
              speak(character.character);
            },
            child: Card(
              color: itemColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      character.character,
                      style: TextStyle(
                        fontFamily: _selectedFont,
                        fontSize: 210.0,
                      ),
                    ),
                    Text(
                      character.romanji,
                      style: TextStyle(
                        fontFamily: _selectedFont,
                        fontSize: 50.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getItemColor(int index) {
    List<Color> itemColors = [
      const Color(0xffFCFCFC),
      const Color(0xffededed),
    ];
    return itemColors[index % itemColors.length];
  }
}
