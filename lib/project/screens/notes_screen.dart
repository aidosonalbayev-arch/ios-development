import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';
import '../models/note_item.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final nameController = TextEditingController();
  final noteController = TextEditingController();

  String userName = 'Guest User';
  List<NoteItem> notes = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    String savedName = prefs.getString(userNameKey) ?? 'Guest User';

    List<NoteItem> savedNotes = [];
    String? notesJson = prefs.getString(notesKey);
    if (notesJson != null) {
      List<dynamic> list = jsonDecode(notesJson);
      for (var item in list) {
        savedNotes.add(NoteItem.fromJson(item));
      }
    }

    setState(() {
      userName = savedName;
      notes = savedNotes;
    });
  }

  Future<void> changeTheme(bool value) async {
    isDarkMode.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkModeKey, value);
  }

  Future<void> saveName() async {
    String name = nameController.text.trim();
    if (name.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNameKey, name);

    setState(() {
      userName = name;
    });
    nameController.clear();
  }

  Future<void> saveNotes() async {
    List<Map<String, dynamic>> list = [];
    for (var note in notes) {
      list.add(note.toJson());
    }
    String notesJson = jsonEncode(list);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(notesKey, notesJson);
  }

  void addNote() {
    String title = noteController.text.trim();
    if (title.isEmpty) return;

    DateTime now = DateTime.now();
    String date = '${now.day}.${now.month}.${now.year}';

    NoteItem newNote = NoteItem(
      id: now.millisecondsSinceEpoch,
      title: title,
      dateText: date,
    );

    setState(() {
      notes.insert(0, newNote);
    });
    noteController.clear();
    saveNotes();
  }

  void toggleNote(NoteItem note) {
    setState(() {
      note.isCompleted = !note.isCompleted;
    });
    saveNotes();
  }

  void deleteNote(NoteItem note) {
    setState(() {
      notes.remove(note);
    });
    saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Hello, $userName!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        ValueListenableBuilder<bool>(
          valueListenable: isDarkMode,
          builder: (context, dark, child) {
            return SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Dark Mode'),
              secondary: Icon(dark ? Icons.dark_mode : Icons.light_mode),
              value: dark,
              onChanged: changeTheme,
            );
          },
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Your name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: saveName, child: const Text('Save')),
          ],
        ),
        const SizedBox(height: 24),

        const Text(
          'My Notes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'New note',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) => addNote(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(onPressed: addNote, icon: const Icon(Icons.add)),
          ],
        ),
        const SizedBox(height: 8),

        if (notes.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('No notes yet')),
          ),

        for (var note in notes)
          Card(
            child: ListTile(
              leading: Checkbox(
                value: note.isCompleted,
                onChanged: (value) => toggleNote(note),
              ),
              title: Text(
                note.title,
                style: TextStyle(
                  decoration: note.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              subtitle: Text(note.dateText),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => deleteNote(note),
              ),
            ),
          ),
      ],
    );
  }
}
