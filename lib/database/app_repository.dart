import 'package:notes_app/database/app_database.dart';
import 'package:notes_app/database/note.dart';

abstract class AppRepository {
  List<Note> getNoteList();
  void addNote(Note note);
  void updateNote(int index, Note note);
  void deleteNote(int index);
  int generateId();
}

class AppRepositoryImpl extends AppRepository {
  final AppDatabase db;

  AppRepositoryImpl({required this.db});

  @override
  List<Note> getNoteList() => db.getNoteList();

  @override
  void addNote(Note note) => db.addNote(note);

  @override
  void updateNote(int index, Note note) => db.updateNote(index, note);

  @override
  void deleteNote(int index) => db.deleteNote(index);

  @override
  int generateId() => db.generateId();
}