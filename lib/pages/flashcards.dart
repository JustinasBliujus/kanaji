import 'package:flutter/material.dart';
import 'package:kanaji/classes/reusableFlashCard.dart';
import 'package:kanaji/classes/characters.dart';
import 'dart:math';
import 'package:kanaji/classes/alertDialogFonts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kanaji/classes/showRangeSelector.dart';
class FlashCards extends StatefulWidget {
  final int currentIndex;
  final String initialFont;
  const FlashCards({super.key, required this.currentIndex,required this.initialFont});

  @override
  State<FlashCards> createState() => _FlashCardsState();
}

class _FlashCardsState extends State<FlashCards> {
  final FlutterTts flutterTts = FlutterTts();

  Future<void> speak(String text)async{
    var language = 'ja-JP';
    try {
      var isLanguageAvailable = await flutterTts.isLanguageAvailable(language);
      if (isLanguageAvailable) {
        await flutterTts.setLanguage(language);
        await flutterTts.setPitch(1.0);
        await flutterTts.setSpeechRate(0.6);
        await flutterTts.speak(text);
      } else {
        print("error");
      }
    } catch (ex) {
      print("error");
    }
  }
  late int start;
  late int end;
  late String _selectedFont;
  Map data = {};
  int _selectedIndex = 0;
  int _currentIndex = 0;
  int _currentIndexCombined = 0;
  bool usingRegularKana = true;
  dynamic _currentCharacter;
  dynamic _currentCharacterCombined;
  late bool kana;
  late List<dynamic> currentList;
  late List<dynamic> currentListCombined;
  late String flashCardsTitle;
  @override
  void initState() {
    super.initState();
    _updateCurrentList();
    _updateCurrentCharacter();
    kana = true;
    start = 0;
    end = originalHiraList.length;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _updateCurrentList();
      _updateCurrentCharacter();
    });
  }

  List<Hiragana>hiraList = HiraganaData.hiraganaList
      .where((character) => !character.isYoon && character.character != "-")
      .toList();

  List<Katakana>kataList = KatakanaData.katakanaList
      .where((character) => !character.isYoon && character.character != "-")
      .toList();

  List<Hiragana>hiraCombined = HiraganaData.hiraganaList
      .where((character) => character.isYoon && character.character != "-")
      .toList();

  List<Katakana>kataCombined = KatakanaData.katakanaList
      .where((character) => character.isYoon && character.character != "-")
      .toList();
// Copies of the original lists for reverting
  List<Hiragana> originalHiraList = HiraganaData.hiraganaList
      .where((character) => !character.isYoon && character.character != "-")
      .toList();

  List<Katakana> originalKataList = KatakanaData.katakanaList
      .where((character) => !character.isYoon && character.character != "-")
      .toList();

  List<Hiragana> originalHiraCombined = HiraganaData.hiraganaList
      .where((character) => character.isYoon && character.character != "-")
      .toList();

  List<Katakana> originalKataCombined = KatakanaData.katakanaList
      .where((character) => character.isYoon && character.character != "-")
      .toList();

  void _showFontSelector(BuildContext context) {
    showFontSelectorDialog(context, (selectedFont) {
      setState(() {
        _selectedFont = selectedFont;
      });
    })();
  }
  void shuffleTwoLists(List<dynamic> list1, List<dynamic> list2) {
    final random = Random();
    for (var i = list1.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);

      // Swap elements in both lists at index i and j
      final temp1 = list1[i];
      list1[i] = list1[j];
      list1[j] = temp1;

      final temp2 = list2[i];
      list2[i] = list2[j];
      list2[j] = temp2;
    }
  }
  void _updateCurrentList() {
    setState(() {
      if (_selectedIndex == 0) {
        currentList = hiraList;
        currentListCombined = hiraCombined;
        usingRegularKana? flashCardsTitle = "Hiragana" : flashCardsTitle = "Hiragana Digraphs";
      } else {
        currentList = kataList;
        currentListCombined = kataCombined;
        usingRegularKana? flashCardsTitle = "Katakana" : flashCardsTitle = "Katakana Digraphs";
      }
    });
  }
  void _updateCurrentCharacter() {
    setState(() {
      _currentCharacter = currentList[_currentIndex];
      _currentCharacterCombined = currentListCombined[_currentIndexCombined];
    });
  }
  void revertToOriginalOrder() {
      if (_selectedIndex == 0) {
        if (usingRegularKana) {
          hiraList = List.from(originalHiraList.sublist(start, end));
          kataList = List.from(originalKataList.sublist(start, end));
        } else {
          hiraCombined = List.from(originalHiraCombined.sublist(start, end));
        }
      } else {
        if (usingRegularKana) {
          kataList = List.from(originalKataList.sublist(start, end));
          hiraList = List.from(originalHiraList.sublist(start, end));
        } else {
          kataCombined = List.from(originalKataCombined.sublist(start, end));
        }
      }
    _updateCurrentList();
    _updateCurrentCharacter();
  }
  double decideFontSize(String text) {
    // Remove white spaces from the text
    String cleanedText = text.replaceAll(' ', '');

    // Count the number of letters
    int numLetters = cleanedText.length;

    // Decide the font size based on the number of letters
    if (numLetters == 1) {
      return 220.0;
    } else if (numLetters == 2) {
      return 170.0;
    } else if (numLetters == 3) {
      return 120.0;
    } else {
      return 100.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if(data.isEmpty){
      data = ModalRoute.of(context)!.settings.arguments as Map;
      _selectedIndex = data['currentIndex'] <= 1 ? data['currentIndex'] : data['currentIndex'] - 1;
      _selectedFont = data['initialFont'];
      _updateCurrentList();
      _updateCurrentCharacter();
    }
    _updateCurrentList();
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Flash Cards",style: TextStyle(letterSpacing: 1),),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // Height of the border
          child: Container(
            color: Colors.white, // Color of the border
            height: 1.0, // Thickness of the border
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Map<String, int>? result = await showRangeSelectorDialog(context, originalHiraList,originalKataList,_selectedIndex);
              if (result != null) {
                start = result['start']!;
                end = result['end']!;
                setState(() {
                  hiraList.clear();
                  kataList.clear();
                  hiraList.addAll(originalHiraList.sublist(start, end));
                  kataList.addAll(originalKataList.sublist(start, end));
                  _currentIndex = _currentIndex > currentList.length-1 ? currentList.length-1 : _currentIndex;
                  _updateCurrentCharacter();
                });
              }
            },
            icon: const Icon(Icons.filter_list_alt),
          ),
          IconButton(
            onPressed: () {
              _showFontSelector(context);
            },
            icon: const Icon(Icons.text_fields),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 75,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              usingRegularKana = !usingRegularKana;
            });

          },
          backgroundColor: Colors.orange,
            child: const Text("Digraphs",style: TextStyle(fontSize: 16),),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.orange, // Border color
              width: 1.0, // Border width
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
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.orange,
          onTap: _onItemTapped,
          selectedFontSize: 18,
          unselectedFontSize: 15,
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanEnd: (details) {
          // Swiping in right direction.
          if (details.velocity.pixelsPerSecond.dx < 0) {
            setState(() {
              if (usingRegularKana) {
                _currentIndex = _currentIndex < currentList.length - 1 ? _currentIndex + 1 : _currentIndex;
                _currentCharacter = currentList[_currentIndex];
              } else {
                _currentIndexCombined = _currentIndexCombined < currentListCombined.length - 1 ? _currentIndexCombined + 1 : _currentIndexCombined;
                _currentCharacterCombined = currentListCombined[_currentIndexCombined];
              }
              kana = true;
            });
          }
          // Swiping in left direction.
          if (details.velocity.pixelsPerSecond.dx > 0) {
            setState(() {
              if (usingRegularKana) {
                _currentIndex = _currentIndex > 0 ? _currentIndex - 1 : _currentIndex;
                _currentCharacter = currentList[_currentIndex];
              } else {
                _currentIndexCombined = _currentIndexCombined > 0 ? _currentIndexCombined - 1 : _currentIndexCombined;
                _currentCharacterCombined = currentListCombined[_currentIndexCombined];
              }
              kana = true;
            });
          }
        },

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text(flashCardsTitle,
              style: const TextStyle(
                  fontSize: 35,
                letterSpacing: 1,
              ),)),
            GestureDetector(
              onTap: () {
                setState(() {
                  kana = !kana;
                });
              },
              child: ReusableCard(
                text: kana ? (usingRegularKana ? _currentCharacter.character : _currentCharacterCombined.character) :
                (usingRegularKana ? _currentCharacter.romanji : _currentCharacterCombined.romanji),
                fontSize: kana ? (usingRegularKana ? decideFontSize(_currentCharacter.character) :
                decideFontSize(_currentCharacterCombined.character)) :
                (usingRegularKana ? decideFontSize(_currentCharacter.romanji) :
                decideFontSize(_currentCharacterCombined.romanji)),
                font: _selectedFont,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        usingRegularKana
                            ? shuffleTwoLists(hiraList, kataList)
                            : shuffleTwoLists(hiraCombined, kataCombined);
                        _updateCurrentList();
                        _updateCurrentCharacter();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 7,
                      shadowColor: Colors.orange,
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.shuffle),
                    label: const Text(
                      "Shuffle",
                      style: TextStyle(
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        revertToOriginalOrder();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 7,
                      shadowColor: Colors.orange,
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      "Reorder",
                      style: TextStyle(
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      String textToSpeak = usingRegularKana? _currentCharacter.character : _currentCharacterCombined.character;
                      speak(textToSpeak);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 7,
                      shadowColor: Colors.orange,
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.volume_up),
                    label: const Text(
                      "Speak",
                      style: TextStyle(
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 7,
                        shadowColor: Colors.orange,
                        foregroundColor: Colors.black,
                      ),
                      onLongPress: (){
                        setState(() {
                          if (usingRegularKana) {
                            _currentIndex = 0;
                            _currentCharacter = currentList[_currentIndex];
                          } else {
                            _currentIndexCombined = 0;
                            _currentCharacterCombined = currentListCombined[_currentIndexCombined];
                          }
                          kana = true;
                        });
                      },
                      onPressed: () {
                        if (_currentIndex < currentList.length) {
                          setState(() {
                            if (usingRegularKana) {
                              _currentIndex = _currentIndex > 0 ? _currentIndex - 1 : _currentIndex;
                              _currentCharacter = currentList[_currentIndex];
                            } else {
                              _currentIndexCombined = _currentIndexCombined > 0 ? _currentIndexCombined - 1 : _currentIndexCombined;
                              _currentCharacterCombined = currentListCombined[_currentIndexCombined];
                            }
                            kana = true;
                          });
                        }
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${usingRegularKana ? _currentIndex + 1 : _currentIndexCombined + 1}/${usingRegularKana ? currentList.length : currentListCombined.length}',
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 7,
                        shadowColor: Colors.orange,
                        foregroundColor: Colors.black,
                      ),
                      onLongPress: (){
                        setState(() {
                          if (usingRegularKana) {
                            _currentIndex = currentList.length-1;
                            _currentCharacter = currentList[_currentIndex];
                          } else {
                            _currentIndexCombined = currentListCombined.length-1;
                            _currentCharacterCombined = currentListCombined[_currentIndexCombined];
                          }
                          kana = true;
                        });
                      },
                      onPressed: () {
                        if (_currentIndex < currentList.length - 1) {
                          setState(() {
                            if (usingRegularKana) {
                              _currentIndex = _currentIndex < currentList.length - 1 ? _currentIndex + 1 : _currentIndex;
                              _currentCharacter = currentList[_currentIndex];
                            } else {
                              _currentIndexCombined = _currentIndexCombined < currentListCombined.length - 1 ? _currentIndexCombined + 1 : _currentIndexCombined;
                              _currentCharacterCombined = currentListCombined[_currentIndexCombined];
                            }
                            kana = true;
                          });
                        }
                      },
                      child: const Icon(
                        Icons.arrow_forward_ios,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
