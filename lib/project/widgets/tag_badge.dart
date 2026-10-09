import 'package:flutter/material.dart';

class TagBadge extends StatelessWidget {
  final String text;

  const TagBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.teal.shade800, fontSize: 13),
      ),
    );
  }
}
