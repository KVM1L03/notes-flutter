import 'package:flutter/material.dart';
import 'package:notes2/screens/new_note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = false;
  List<String> notes = [];

  void _openMenu(BuildContext context) {
    print('Menu icon clicked!');
  }

  void _toggleNightMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  // Przenosi użytkownika na nowy ekran NewNoteScreen, który pozwala na dodawanie nowych notatek.
  // Po powrocie z tego ekranu do bieżącego ekranu, aktualizuje listę notatek (notes) na podstawie
  // wyniku zwróconego z ekranu NewNoteScreen.
  void _addNewNote() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewNoteScreen(notes: notes)),
    ).then((updatedNotes) {
      if (updatedNotes != null) {
        setState(() {
          notes = updatedNotes;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Zmiana tła (jasne/ciemne)
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        // Nagłówek aplikacji z przyciskami
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 217, 0, 255),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  _openMenu(context);
                },
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {
                  _toggleNightMode();
                },
                icon: const Icon(
                  Icons.nightlight_round,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
        // Generowana lista notatek
        body: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];

            // Sprawdź czy tytuł i treść oddziela nowa linia
            if (note.contains('\n')) {
              final title = note.substring(0, note.indexOf('\n'));
              final description = note.substring(note.indexOf('\n') + 1);

              return Card(
                elevation: 4,
                child: ListTile(
                  title: Center(
                    child: Text(
                      title,
                      style:
                          const TextStyle(fontSize: 24, fontFamily: 'Handjet'),
                    ),
                  ),
                  subtitle: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }
          },
        ),
        //Przycisk dodawania notatek uruchamiający funkcję _addNewNote(),
        //która przenosi użytkownika na nowy ekran dodawania notatki
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addNewNote();
          },
          backgroundColor: const Color.fromARGB(255, 217, 0, 255),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
