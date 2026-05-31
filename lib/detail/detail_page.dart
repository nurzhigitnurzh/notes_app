import 'package:flutter/material.dart';
import 'package:notes_app/database/app_database.dart';
import 'package:notes_app/database/app_repository.dart';
import 'package:notes_app/database/note.dart';
import 'package:notes_app/detail/detail_view_model.dart';

class DetailPage extends StatefulWidget {
  final AppDatabase database;
  final Note note;
  final int index;

  const DetailPage({
    super.key,
    required this.database,
    required this.note,
    required this.index,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final DetailViewModel vm;
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final repo = AppRepositoryImpl(db: widget.database);
    vm = DetailViewModel(repo: repo);
    _titleController = TextEditingController(text: widget.note.title);
    _descController = TextEditingController(text: widget.note.description);
    _titleController.addListener(_checkChanges);
    _descController.addListener(_checkChanges);
  }

  void _checkChanges() {
    final changed = _titleController.text.trim() != widget.note.title ||
        _descController.text.trim() != widget.note.description;
    if (changed != _hasChanges) setState(() => _hasChanges = changed);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF0D0D0D)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          widget.note.title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0D0D0D),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: _NoteIllustration(),
                ),
              ),
              const Text(
                'Название',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0D0D0D),
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _titleController,
                hint: 'Введите название',
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              const Text(
                'Описание',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0D0D0D),
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _descController,
                hint: 'Введите описание',
                maxLines: 5,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _hasChanges ? _save : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    disabledBackgroundColor: const Color(0xFFB0B0B0),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Сохранить изменения',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 15, color: Color(0xFF0D0D0D)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFC7C7CC), fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Название не может быть пустым')),
      );
      return;
    }
    final updated = widget.note.copyWith(
      title: title,
      description: _descController.text.trim(),
    );
    vm.updateNote(widget.index, updated);
    Navigator.pop(context, true);
  }
}

class _NoteIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 180,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E8),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          Positioned(
            right: 30,
            top: 20,
            child: Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD166),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(
                    5,
                    (i) => Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 6),
                      height: 2,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E5EA),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6BCB77),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.eco, color: Colors.white, size: 16),
                ),
                Container(
                  width: 24,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A574),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 15,
            bottom: 12,
            child: Transform.rotate(
              angle: -0.4,
              child: Container(
                width: 8,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD166),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Text('♪',
                style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFFFFD166).withOpacity(0.8))),
          ),
          Positioned(
            top: 20,
            left: 50,
            child: Text('♫',
                style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF007AFF).withOpacity(0.4))),
          ),
        ],
      ),
    );
  }
}