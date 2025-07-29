import 'package:flutter/material.dart';
import 'characters.dart';
import 'package:kanaji/classes/reusableFlashCard.dart';

Future<Map<String, int>?> showRangeSelectorDialog(BuildContext context, List<Hiragana> originalHiraList,List<Katakana> originalKataList, int selectedIndex) {
  return showDialog<Map<String, int>>(
    context: context,
    builder: (BuildContext context) {
      int start = 1;
      int end = originalHiraList.length;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            scrollable: true,
            title: Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(4.0),
              child: const Center(
                child: Text(
                  'Select Range',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReusableCard(
                  text: selectedIndex == 0 ? originalHiraList[start - 1].character : originalKataList[start-1].character,
                  fontSize: 120,
                  font: "Default",
                ),
                Text('Start: $start',style: const TextStyle(
                  color: Colors.black,
                  letterSpacing: 1,
                  fontSize: 20,
                ),),
                Slider(
                  thumbColor: Colors.orange,
                  activeColor: Colors.orange,
                  value: start.toDouble(),
                  min: 1,
                  max: end.toDouble(),
                  divisions: end > 1 ? end : null,
                  label: start.toString(),
                  onChanged: (double value) {
                    setState(() {
                      start = value.toInt();
                      if (start > end) {
                        end = start;
                      }
                    });
                  },
                ),
                ReusableCard(
                  text: selectedIndex == 0 ? originalHiraList[end - 1].character : originalKataList[end - 1].character,
                  fontSize: 120,
                  font: "Default",
                ),
                Text('End: $end',style: const TextStyle(
                  color: Colors.black,
                  letterSpacing: 1,
                  fontSize: 20,
                ),),
                Slider(
                  thumbColor: Colors.orange,
                  activeColor: Colors.orange,
                  value: end.toDouble(),
                  min: start.toDouble(),
                  max: originalHiraList.length.toDouble(),
                  divisions: (originalHiraList.length - start) > 1 ? originalHiraList.length - start : null,
                  label: end.toString(),
                  onChanged: (double value) {
                    setState(() {
                      end = value.toInt();
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('OK',style: TextStyle(
                  color: Colors.black,letterSpacing: 1,fontWeight: FontWeight.bold,
                ),),
                onPressed: () {
                  Navigator.of(context).pop({'start': start-1, 'end': end});
                },
              ),
            ],
          );
        },
      );
    },
  );
}
