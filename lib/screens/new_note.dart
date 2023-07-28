import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewNoteScreen extends StatefulWidget {
  final List<String> notes;
  final bool isDarkMode;

  const NewNoteScreen({Key? key, required this.notes, required this.isDarkMode})
      : super(key: key);

  @override
  NewNoteScreenState createState() => NewNoteScreenState();
}

class NewNoteScreenState extends State<NewNoteScreen> {
  // Kontrolery do text inputów
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: widget.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Center(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Nowa notatka'),
            titleTextStyle:
                const TextStyle(fontSize: 30, fontFamily: 'Handjet'),
            backgroundColor: const Color.fromARGB(255, 217, 0, 255),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: widget.isDarkMode
                  ? const Icon(Icons.arrow_back, color: Colors.white, size: 30)
                  : const Icon(Icons.arrow_back, color: Colors.black, size: 30),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // Pole tekstowe tytułu
              children: [
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 1,
                  cursorColor: const Color.fromARGB(255, 217, 0, 255),
                  maxLength: 20,
                  style: const TextStyle(
                    fontFamily: 'Handjet',
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Tytuł',
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 217, 0, 255)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                // Pole tekstowe treści
                TextFormField(
                  controller: _contentController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  cursorColor: const Color.fromARGB(255, 217, 0, 255),
                  style: const TextStyle(
                    fontFamily: 'Handjet',
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Treść',
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 217, 0, 255)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Przycisk zapisz
                ElevatedButton(
                  onPressed: () {
                    _saveNoteAndReturnHome();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 217, 0, 255),
                      elevation: 10,
                      textStyle:
                          const TextStyle(fontFamily: 'Handjet', fontSize: 24)),
                  child: const Text('ZAPISZ'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Funkcja sprawdzająca i zapisująca tekst z obu ból tekstowych
  void _saveNoteAndReturnHome() async {
    String newNoteTitle = _titleController.text.trim();
    String newNoteContent = _contentController.text.trim();

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notes', updatedNotes);

    // Zamykanie bieżącego ekranu i przekazywanie zaktualizowanej listy notatek z powrotem do HomeScreen
    Navigator.pop(context, updatedNotes);
  }
}
