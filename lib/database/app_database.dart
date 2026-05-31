import 'package:hive/hive.dart';
import 'package:notes_app/database/note.dart';

class AppDatabase {
  final Box _box = Hive.box('notesBox');
  List<Note> _noteList = [];

  AppDatabase() {
    _loadNotes();
  }

  void _loadNotes() {
    final data = _box.get('notes', defaultValue: []);
    _noteList = List<Map>.from(data).map((e) => Note.fromMap(e)).toList();
  }

  void _saveNotes() {
    final data = _noteList.map((n) => n.toMap()).toList();
    _box.put('notes', data);
  }

  List<Note> getNoteList() => List.unmodifiable(_noteList);

  void addNote(Note note) {
    _noteList.insert(0, note);
    _saveNotes();
  }

  void updateNote(int index, Note note) {
    _noteList[index] = note;
    _saveNotes();
  }

  void deleteNote(int index) {
    _noteList.removeAt(index);
    _saveNotes();
  }

  int generateId() {
    if (_noteList.isEmpty) return 1;
    return _noteList.map((n) => n.id).reduce((a, b) => a > b ? a : b) + 1;
  }
}