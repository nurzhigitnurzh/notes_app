import 'package:notes_app/database/app_repository.dart';
import 'package:notes_app/database/note.dart';

class AddViewModel {
  final AppRepository repo;

  AddViewModel({required this.repo});

  void addNote({required String title, required String description}) {
    final note = Note(
      id: repo.generateId(),
      title: title.trim(),
      description: description.trim(),
      createdAt: DateTime.now().toIso8601String(),
    );
    repo.addNote(note);
  }
}