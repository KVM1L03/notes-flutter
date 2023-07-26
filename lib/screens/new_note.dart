import 'package:flutter/material.dart';

class NewNoteScreen extends StatefulWidget {
  const NewNoteScreen({Key? key}) : super(key: key);

  @override
  NewNoteScreenState createState() => NewNoteScreenState();
}

class NewNoteScreenState extends State<NewNoteScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _textController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Enter your new note...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveNoteAndReturnHome(context);
              },
              child: const Text('SAVE'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNoteAndReturnHome(BuildContext context) {
    String newNote = _textController.text;

    Navigator.pop(context, newNote);
  }
}
