import 'package:flutter/material.dart';
import 'package:notes2/screens/new_note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = false;
  List<String> notes = [];
  List<String> filteredNotes = [];
  String query = '';

  // Funkcja zmiany pomiędzy trybem jasnym a ciemnym
  void _toggleNightMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  // Funkcja nawigująca do ekranu dodawania notatki
  void _addNewNote() async {
    // Navigator.push zwraca dane z dodanej notatki
    final updatedNotes = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NewNoteScreen(notes: notes, isDarkMode: isDarkMode),
      ),
    );

    if (updatedNotes != null) {
      // Dodanie do listy zwróconej notatki
      setState(() {
        notes = updatedNotes;
      });
      _filterNotes(query); // Filtrowanie notatek
    }
  }

  void _getNotesFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedNotes = prefs.getStringList('notes');
    if (savedNotes != null) {
      setState(() {
        notes = savedNotes;
      });
      _filterNotes(query); // Filtracja notatek przy pustym polu
    }
  }

  @override
  // Pobieranie notatek z pamięci (użyto shared_preferences)
  void initState() {
    super.initState();
    _getNotesFromSharedPreferences();
  }

  // Funkcja filtrująca listę notatek za pomocą słowa kluczowego
  void _filterNotes(String query) {
    setState(() {
      filteredNotes = notes
          .where((note) => note.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Center(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 217, 0, 255),
            title: const Text('Twoje notatki'),
            titleTextStyle:
                const TextStyle(fontSize: 30, fontFamily: 'Handjet'),
            actions: [
              IconButton(
                onPressed: () {
                  _toggleNightMode();
                },
                icon: isDarkMode
                    ? const Icon(Icons.sunny, color: Colors.white, size: 30)
                    : const Icon(Icons.nightlight_round,
                        color: Colors.black, size: 30),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (query) => _filterNotes(query),
                  cursorColor: const Color.fromARGB(255, 217, 0, 255),
                  style: const TextStyle(
                    fontFamily: 'Handjet',
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Szukaj notatek ...',
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: Color.fromARGB(255, 217, 0, 255),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 217, 0, 255)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: filteredNotes.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredNotes.length,
                          itemBuilder: (context, index) {
                            final note = filteredNotes[index];
                            final title = note.substring(0, note.indexOf('\n'));
                            final description =
                                note.substring(note.indexOf('\n') + 2);

                            return Dismissible(
                              key: Key(index.toString()),
                              onDismissed: (direction) {
                                _deleteNote(
                                    index); // Wywołanie funkcji usuwającej notatkę
                              },
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: Card(
                                elevation: 4,
                                child: ListTile(
                                  title: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, bottom: 4, top: 4, right: 4),
                                      child: Text(
                                        title,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'Handjet'),
                                      ),
                                    ),
                                  ),
                                  subtitle: Text(
                                    description,
                                    style: const TextStyle(
                                        fontSize: 18, fontFamily: 'Handjet'),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'Brak notatek :(',
                            style:
                                TextStyle(fontFamily: 'Handjet', fontSize: 30),
                          ),
                        )),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _addNewNote(); // Wywołania funkcji która przenosi na ekran dodawania notatki
            },
            backgroundColor: const Color.fromARGB(255, 217, 0, 255),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  // Funkcja usuwająca notatkę
  void _deleteNote(int index) async {
    setState(() {
      notes.removeAt(index);
      _filterNotes(query);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notes', notes);
  }
}
