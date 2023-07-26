import 'package:flutter/material.dart';
import 'package:notes2/components/note_card.dart';
import 'package:notes2/screens/new_note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = false;
  List<String> notes = [
    'Note 1',
    'Note 2',
    'Note 3',
  ];

  void _openMenu(BuildContext context) {
    print('Menu icon clicked!');
  }

  void _toggleNightMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void _addNewNote() async {
    String? newNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewNoteScreen()),
    );

    if (newNote != null) {
      setState(() {
        notes.add(newNote);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
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
        body: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return NoteCard(
                note: notes[index],
              );
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _addNewNote();
            },
            backgroundColor: const Color.fromARGB(255, 217, 0, 255),
            child: const Icon(Icons.add)),
      ),
    );
  }
}
