import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewNoteScreen extends StatefulWidget {
  final List<String> notes;

  const NewNoteScreen({Key? key, required this.notes}) : super(key: key);

  @override
  NewNoteScreenState createState() => NewNoteScreenState();
}

class NewNoteScreenState extends State<NewNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String newNoteTitle = '';
  String newNoteContent = '';

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nowa notatka'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // Pole tekstowe tytułu
          children: [
            TextFormField(
              controller: _titleController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
            ),
            // Pole tekstowe treści
            TextFormField(
              controller: _contentController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Content',
              ),
            ),
            const SizedBox(height: 16),
            // Przycisk zapisz
            ElevatedButton(
              onPressed: () {
                _saveNoteAndReturnHome();
              },
              child: const Text('SAVE'),
            ),
          ],
        ),
      ),
    );
  }

  // Funkcja sprawdzająca i zapisująca tekst z obu ból tekstowych
  void _saveNoteAndReturnHome() {
    String newNoteTitle = _titleController.text;
    String newNoteContent = _contentController.text;

    // Zabezpiczenie przed niewpisaniem tytułu lub treści
    if (newNoteTitle.isEmpty || newNoteContent.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Błąd'),
          content: const Text('Zapomniałeś/aś tytułu lub treści notatki!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    //Połączenie tytułu i treści w nowy jeden napis oddzielony 2 nowymi liniami
    String newNote = '$newNoteTitle\n\n$newNoteContent';
    List<String> updatedNotes = List.from(widget.notes)..add(newNote);

    //Użycie modułu shared_preferences aby zapisać dane w pamięci urządzenia
    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('notes', updatedNotes);

      
      Navigator.pop(context, updatedNotes);
    });
  }
}
