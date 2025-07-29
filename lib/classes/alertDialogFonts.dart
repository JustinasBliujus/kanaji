import 'package:flutter/material.dart';

Function showFontSelectorDialog(BuildContext context, Function(String) onFontSelected) {
  return () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.all(8.0),
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
                    onFontSelected('Default');
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  height: 2,
                  color: Colors.orange,
                ),
                ListTile(
                  title: const Text('Caligraphy 1', style: TextStyle(fontFamily: 'Mincho')),
                  onTap: () {
                    onFontSelected('Mincho');
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  height: 2,
                  color: Colors.orange,
                ),
                ListTile(
                  title: const Text('Caligraphy 2', style: TextStyle(fontFamily: 'Gakuran')),
                  onTap: () {
                    onFontSelected('Gakuran');
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  height: 2,
                  color: Colors.orange,
                ),
                ListTile(
                  title: const Text('Caligraphy 3', style: TextStyle(fontFamily: 'Amakara')),
                  onTap: () {
                    onFontSelected('Amakara');
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  height: 2,
                  color: Colors.orange,
                ),
                ListTile(
                  title: const Text('Display 1', style: TextStyle(fontFamily: 'Curul')),
                  onTap: () {
                    onFontSelected('Curul');
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  height: 2,
                  color: Colors.orange,
                ),
                ListTile(
                  title: const Text('Display 2', style: TextStyle(fontFamily: 'Humour')),
                  onTap: () {
                    onFontSelected('Humour');
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  height: 2,
                  color: Colors.orange,
                ),
                ListTile(
                  title: const Text('Display 3', style: TextStyle(fontFamily: 'Reggae')),
                  onTap: () {
                    onFontSelected('Reggae');
                    Navigator.of(context).pop();
                  },
                ),
                // Add other font options here...
              ],
            ),
          ),
        );
      },
    );
  };
}
