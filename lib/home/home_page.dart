
import 'package:flutter/material.dart';
import 'package:notes_app/add/add_page.dart';
import 'package:notes_app/database/app_database.dart';
import 'package:notes_app/database/app_repository.dart';
import 'package:notes_app/database/note.dart';
import 'package:notes_app/detail/detail_page.dart';
import 'package:notes_app/home/home_view_model.dart';
 
class HomePage extends StatefulWidget {
  const HomePage({super.key});
 
  @override
  State<HomePage> createState() => _HomePageState();
}
 
class _HomePageState extends State<HomePage> {
  late final HomeViewModel vm;
  late final AppDatabase db;
  final TextEditingController _searchController = TextEditingController();
 
  @override
  void initState() {
    super.initState();
    db = AppDatabase();
    final repo = AppRepositoryImpl(db: db);
    vm = HomeViewModel(repo: repo);
    vm.loadNotes();
  }
 
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: const Text(
                'Заметки',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D0D0D),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    vm.search(val);
                    setState(() {});
                  },
                  style: const TextStyle(fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: 'Искать заметки',
                    hintStyle: TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF8E8E93),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: vm.filteredList.isEmpty
                  ? _buildEmpty()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 100),
                      itemCount: vm.filteredList.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        indent: 20,
                        endIndent: 20,
                        color: Color(0xFFE5E5EA),
                      ),
                      itemBuilder: (context, index) {
                        return _NoteListTile(
                          note: vm.filteredList[index],
                          onTap: () => _navigateToDetail(index),
                          onDelete: () => _deleteNote(index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        backgroundColor: const Color(0xFF007AFF),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
 
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.note_alt_outlined, size: 64, color: Color(0xFFC7C7CC)),
          SizedBox(height: 12),
          Text(
            'Нет заметок',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8E8E93),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Нажмите + чтобы создать первую',
            style: TextStyle(fontSize: 14, color: Color(0xFFC7C7CC)),
          ),
        ],
      ),
    );
  }
 
  void _navigateToAdd() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddPage(database: db)),
    );
    if (result == true) setState(() => vm.loadNotes());
  }
 
  void _navigateToDetail(int filteredIndex) async {
    final note = vm.filteredList[filteredIndex];
    final realIndex = vm.noteList.indexOf(note);
 
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPage(
          database: db,
          note: note,
          index: realIndex,
        ),
      ),
    );
    if (result == true) setState(() => vm.loadNotes());
  }
 
  void _deleteNote(int filteredIndex) {
    setState(() => vm.deleteNote(filteredIndex));
  }
}
 
class _NoteListTile extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
 
  const _NoteListTile({
    required this.note,
    required this.onTap,
    required this.onDelete,
  });
 
  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      final now = DateTime.now();
      final isToday =
          dt.year == now.year && dt.month == now.month && dt.day == now.day;
      final timeStr =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      return isToday
          ? 'Сегодня • $timeStr'
          : '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} • $timeStr';
    } catch (_) {
      return '';
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 8, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D0D0D),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    note.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8E8E93),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _formatDate(note.createdAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFC7C7CC),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (val) {
                if (val == 'delete') onDelete();
              },
              icon: const Icon(
                Icons.more_horiz,
                color: Color(0xFF8E8E93),
                size: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: const [
                      Icon(Icons.delete_outline, color: Colors.red, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Удалить',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}