import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_client.dart';
import '../../core/app_drawer.dart';

class ExamDetailScreen extends ConsumerStatefulWidget {
  const ExamDetailScreen({required this.examId, super.key});
  final String examId;

  @override
  ConsumerState<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends ConsumerState<ExamDetailScreen> {
  late final Future<ExamDetail> _examFuture;

  @override
  void initState() {
    super.initState();
    _examFuture = _fetchExam();
  }

  Future<ExamDetail> _fetchExam() async {
    final dio = ref.read(dioProvider);
    final response = await dio.get('/public/exams/${widget.examId}');
    final data = response.data as Map<String, dynamic>;
    final quizzes = (data['quizzes'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(QuizSummary.fromJson)
        .toList();
    return ExamDetail(
      id: data['id'].toString(),
      name: data['name'] as String? ?? 'Exam',
      description: data['description'] as String? ?? 'No description available.',
      code: data['code'] as String? ?? '',
      thumbnailUrl: data['thumbnailUrl'] as String? ?? '',
      bannerUrl: data['bannerUrl'] as String? ?? '',
      quizzes: quizzes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam Details')),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: FutureBuilder<ExamDetail>(
          future: _examFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Could not load exam details.\n${snapshot.error}', textAlign: TextAlign.center),
                ),
              );
            }

            final exam = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (exam.bannerUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(exam.bannerUrl, fit: BoxFit.cover, height: 180, width: double.infinity, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                  ),
                const SizedBox(height: 16),
                Text(exam.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(exam.description, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 20),
                const Text('Quizzes for this exam', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                if (exam.quizzes.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('No quizzes are available for this exam yet.'),
                  )
                else
                  for (final quiz in exam.quizzes)
                    Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(quiz.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(quiz.details),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () => context.go('/quiz-detail/${quiz.id}'),
                      ),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ExamDetail {
  ExamDetail({required this.id, required this.name, required this.description, required this.code, required this.thumbnailUrl, required this.bannerUrl, required this.quizzes});

  final String id;
  final String name;
  final String description;
  final String code;
  final String thumbnailUrl;
  final String bannerUrl;
  final List<QuizSummary> quizzes;
}

class QuizSummary {
  QuizSummary({required this.id, required this.name, required this.setName, required this.durationMinutes, required this.optionCount});

  final String id;
  final String name;
  final String setName;
  final int durationMinutes;
  final int optionCount;

  factory QuizSummary.fromJson(Map<String, dynamic> json) {
    return QuizSummary(
      id: json['id'].toString(),
      name: json['name'] as String? ?? 'Quiz',
      setName: json['setName'] as String? ?? '',
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      optionCount: (json['optionCount'] as num?)?.toInt() ?? 4,
    );
  }

  String get title => setName.isNotEmpty ? '$name - $setName' : name;
  String get details => '$optionCount options · $durationMinutes min';
}
