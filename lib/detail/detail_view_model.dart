import 'package:notes_app/database/app_repository.dart';
import 'package:notes_app/database/note.dart';

class DetailViewModel {
  final AppRepository repo;

  DetailViewModel({required this.repo});

  void updateNote(int index, Note note) {
    repo.updateNote(index, note);
  }

  void deleteNote(int index) {
    repo.deleteNote(index);
  }
}