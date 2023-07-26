import 'package:flutter/material.dart';

class NoteCard extends StatefulWidget {
  final String note;

  const NoteCard({required this.note});

  @override
  NoteCardState createState() => NoteCardState();
}

class NoteCardState extends State<NoteCard> {
  // Rest of your code...

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(widget.note),
      ),
    );
  }
}
