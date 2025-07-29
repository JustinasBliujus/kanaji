import 'package:flutter/material.dart';

class ReusableCard extends StatefulWidget {
  const ReusableCard({super.key, required this.text, required this.fontSize, required this.font});

  final String text;
  final double fontSize;
  final String font;

  @override
  State<ReusableCard> createState() => _ReusableCardState();
}

class _ReusableCardState extends State<ReusableCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 7,
        shadowColor: Colors.orange,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontFamily: widget.font,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
