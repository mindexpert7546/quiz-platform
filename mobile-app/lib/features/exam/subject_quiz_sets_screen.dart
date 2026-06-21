import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api_client.dart';

class SubjectQuizSetsScreen extends ConsumerStatefulWidget {
  const SubjectQuizSetsScreen(
      {required this.examId, required this.subjectId, super.key});

  final String examId;
  final String subjectId;

  @override
  ConsumerState<SubjectQuizSetsScreen> createState() =>
      _SubjectQuizSetsScreenState();
}

class _SubjectQuizSetsScreenState extends ConsumerState<SubjectQuizSetsScreen> {
  late final Future<List<QuizSetItem>> _setsFuture;

  @override
  void initState() {
    super.initState();
    _setsFuture = _fetchSets();
  }

  Future<List<QuizSetItem>> _fetchSets() async {
    final dio = ref.read(dioProvider);
    final response = await dio.get(
        '/public/exams/${widget.examId}/subjects/${widget.subjectId}/quizzes');
    final data = (response.data as List<dynamic>).cast<Map<String, dynamic>>();
    return data.map(QuizSetItem.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QuizSetItem>>(
      future: _setsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _MessageState(
              message: 'Could not load quiz sets.\n${snapshot.error}');
        }

        final sets = snapshot.data!;
        if (sets.isEmpty) {
          return const _MessageState(
              message: 'No quiz sets are available for this subject yet.');
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.45,
          ),
          itemCount: sets.length,
          itemBuilder: (context, index) {
            final set = sets[index];
            return _SetCard(
              set: set,
              color: _palette[index % _palette.length],
              onTap: () => context.go('/quiz-detail/${set.id}'),
            );
          },
        );
      },
    );
  }
}

class QuizSetItem {
  QuizSetItem({
    required this.id,
    required this.name,
    required this.setName,
    required this.durationMinutes,
    required this.optionCount,
    required this.examName,
    required this.subjectName,
  });

  final String id;
  final String name;
  final String setName;
  final int durationMinutes;
  final int optionCount;
  final String examName;
  final String subjectName;

  factory QuizSetItem.fromJson(Map<String, dynamic> json) {
    return QuizSetItem(
      id: json['id'].toString(),
      name: json['name'] as String? ?? 'Quiz Set',
      setName: json['setName'] as String? ?? '',
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      optionCount: (json['optionCount'] as num?)?.toInt() ?? 4,
      examName: json['examName'] as String? ?? '',
      subjectName: json['subjectName'] as String? ?? '',
    );
  }

  String get displayName => setName.isNotEmpty ? setName : name;
}

class _SetCard extends StatelessWidget {
  const _SetCard({required this.set, required this.color, required this.onTap});

  final QuizSetItem set;
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
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundColor: color,
                    child: const Icon(Icons.assignment_rounded,
                        color: Color(0xFF1677E8), size: 30),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 16, color: Color(0xFF9CA3AF)),
                ],
              ),
              const Spacer(),
              Text(
                set.displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 20, height: 1.1, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 7),
              Text(
                '${set.durationMinutes} min | ${set.optionCount} options',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Color(0xFF6B7280), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
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
