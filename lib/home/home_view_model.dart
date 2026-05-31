import 'package:notes_app/database/app_repository.dart';
import 'package:notes_app/database/note.dart';

class HomeViewModel {
  final AppRepository repo;
  List<Note> noteList = [];
  List<Note> filteredList = [];
  String searchQuery = '';

  HomeViewModel({required this.repo});

  void loadNotes() {
    noteList = repo.getNoteList().toList();
    _applyFilter();
  }

  void search(String query) {
    searchQuery = query;
    _applyFilter();
  }

  void deleteNote(int indexInFiltered) {
    final note = filteredList[indexInFiltered];
    final realIndex = noteList.indexOf(note);
    if (realIndex != -1) {
      repo.deleteNote(realIndex);
      loadNotes();
    }
  }

  void _applyFilter() {
    if (searchQuery.isEmpty) {
      filteredList = List.from(noteList);
    } else {
      final q = searchQuery.toLowerCase();
      filteredList = noteList
          .where((n) =>
              n.title.toLowerCase().contains(q) ||
              n.description.toLowerCase().contains(q))
          .toList();
    }
  }
}