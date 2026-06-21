import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api_client.dart';

class ExamDetailScreen extends ConsumerStatefulWidget {
  const ExamDetailScreen({required this.examId, super.key});
  final String examId;

  @override
  ConsumerState<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends ConsumerState<ExamDetailScreen> {
  late final Future<ExamSubjectsData> _subjectsFuture;

  @override
  void initState() {
    super.initState();
    _subjectsFuture = _fetchSubjects();
  }

  Future<ExamSubjectsData> _fetchSubjects() async {
    final dio = ref.read(dioProvider);
    final examResponse = await dio.get('/public/exams/${widget.examId}');
    final subjectsResponse =
        await dio.get('/public/exams/${widget.examId}/subjects');
    final examData = examResponse.data as Map<String, dynamic>;
    final subjectData =
        (subjectsResponse.data as List<dynamic>).cast<Map<String, dynamic>>();

    return ExamSubjectsData(
      examName: examData['name'] as String? ?? 'Exam',
      bannerUrl: examData['bannerUrl'] as String? ?? '',
      subjects: subjectData.map(SubjectItem.fromJson).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ExamSubjectsData>(
      future: _subjectsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _MessageState(
              message: 'Could not load subjects.\n${snapshot.error}');
        }

        final data = snapshot.data!;
        if (data.subjects.isEmpty) {
          return const _MessageState(
              message: 'No subjects are available for this exam yet.');
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ExamHeader(title: data.examName, bannerUrl: data.bannerUrl),
            const SizedBox(height: 18),
            GridView.builder(
              itemCount: data.subjects.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.38,
              ),
              itemBuilder: (context, index) {
                final subject = data.subjects[index];
                return _SubjectCard(
                  subject: subject,
                  color: _palette[index % _palette.length],
                  onTap: () => context
                      .go('/exam/${widget.examId}/subject/${subject.id}'),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class ExamSubjectsData {
  ExamSubjectsData(
      {required this.examName,
      required this.bannerUrl,
      required this.subjects});

  final String examName;
  final String bannerUrl;
  final List<SubjectItem> subjects;
}

class SubjectItem {
  SubjectItem(
      {required this.id,
      required this.name,
      required this.description,
      required this.quizCount});

  final String id;
  final String name;
  final String description;
  final int quizCount;

  factory SubjectItem.fromJson(Map<String, dynamic> json) {
    return SubjectItem(
      id: json['id'].toString(),
      name: json['name'] as String? ?? 'Subject',
      description: json['description'] as String? ?? '',
      quizCount: (json['quizCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class _ExamHeader extends StatelessWidget {
  const _ExamHeader({required this.title, required this.bannerUrl});

  final String title;
  final String bannerUrl;

  @override
  Widget build(BuildContext context) {
    if (bannerUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          bannerUrl,
          height: 138,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _FallbackHeader(title: title),
        ),
      );
    }
    return _FallbackHeader(title: title);
  }
}

class _FallbackHeader extends StatelessWidget {
  const _FallbackHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 138,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard(
      {required this.subject, required this.color, required this.onTap});

  final SubjectItem subject;
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
              CircleAvatar(
                radius: 28,
                backgroundColor: color,
                child: const Icon(Icons.auto_stories_rounded,
                    color: Color(0xFF1677E8), size: 30),
              ),
              const Spacer(),
              Text(
                subject.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 18, height: 1.15, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 5),
              Text(
                '${subject.quizCount} sets',
                style: const TextStyle(
                    color: Color(0xFF1681F2), fontWeight: FontWeight.w800),
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
