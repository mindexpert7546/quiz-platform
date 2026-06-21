import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api_client.dart';

class ExamListScreen extends ConsumerStatefulWidget {
  const ExamListScreen({super.key});

  @override
  ConsumerState<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends ConsumerState<ExamListScreen> {
  late final Future<List<ExamItem>> _examsFuture;

  @override
  void initState() {
    super.initState();
    _examsFuture = _fetchExams();
  }

  Future<List<ExamItem>> _fetchExams() async {
    final dio = ref.read(dioProvider);
    final response = await dio
        .get('/public/exams', queryParameters: {'page': 0, 'size': 50});
    final content = (response.data['content'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    return content.map(ExamItem.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExamItem>>(
      future: _examsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _MessageState(
              message: 'Failed to load exams.\n${snapshot.error}');
        }

        final exams = snapshot.data!;
        if (exams.isEmpty) {
          return const _MessageState(message: 'No exams are available yet.');
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.92,
          ),
          itemCount: exams.length,
          itemBuilder: (context, index) {
            final exam = exams[index];
            return _CatalogCard(
              title: exam.name,
              subtitle: exam.description,
              icon: Icons.school_rounded,
              color: _palette[index % _palette.length],
              onTap: () => context.go('/exam/${exam.id}'),
            );
          },
        );
      },
    );
  }
}

class ExamItem {
  ExamItem({required this.id, required this.name, required this.description});

  final String id;
  final String name;
  final String description;

  factory ExamItem.fromJson(Map<String, dynamic> json) {
    return ExamItem(
      id: json['id'].toString(),
      name: json['name'] as String? ?? 'Exam',
      description: json['description'] as String? ?? '',
    );
  }
}

const _palette = [
  Color(0xFFE7F2FF),
  Color(0xFFE8F7EC),
  Color(0xFFF0EAFF),
  Color(0xFFFFF2DF),
  Color(0xFFE4F2FF),
  Color(0xFFF7E9FB),
];

class _CatalogCard extends StatelessWidget {
  const _CatalogCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: color,
                child: Icon(icon, color: const Color(0xFF1677E8), size: 30),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w800, height: 1.15),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}
