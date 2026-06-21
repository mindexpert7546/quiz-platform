import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_client.dart';
import '../../core/app_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final Future<HomeData> _homeDataFuture;

  @override
  void initState() {
    super.initState();
    _homeDataFuture = _fetchHomeData();
  }

  Future<HomeData> _fetchHomeData() async {
    final dio = ref.read(dioProvider);
    final examsResponse = await dio.get('/public/exams', queryParameters: {'page': 0, 'size': 10});
    final quizzesResponse = await dio.get('/public/quizzes', queryParameters: {'page': 0, 'size': 20});

    final exams = _parseExamList(examsResponse.data);
    final quizzes = _parseQuizList(quizzesResponse.data);
    return HomeData(exams: exams, quizzes: quizzes);
  }

  List<ExamItem> _parseExamList(dynamic data) {
    final content = (data['content'] as List).cast<Map<String, dynamic>>();
    return content.map(ExamItem.fromJson).toList();
  }

  List<QuizItem> _parseQuizList(dynamic data) {
    final content = (data['content'] as List).cast<Map<String, dynamic>>();
    return content.map(QuizItem.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam Prep')),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: FutureBuilder<HomeData>(
          future: _homeDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Failed to load exams and quizzes.\n${snapshot.error}', textAlign: TextAlign.center),
                ),
              );
            }

            final homeData = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Choose Exam', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                for (final exam in homeData.exams)
                  _ExamCard(
                    title: exam.name,
                    subtitle: exam.description,
                    onTap: () => context.go('/exam/${exam.id}'),
                  ),
                const SizedBox(height: 24),
                const Text('Featured Quizzes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                for (final quiz in homeData.quizzes)
                  _QuizCard(
                    title: quiz.displayTitle,
                    details: quiz.details,
                    onTap: () => context.go('/quiz-detail/${quiz.id}'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class HomeData {
  HomeData({required this.exams, required this.quizzes});

  final List<ExamItem> exams;
  final List<QuizItem> quizzes;
}

class ExamItem {
  ExamItem({required this.id, required this.name, required this.description});

  final String id;
  final String name;
  final String description;

  factory ExamItem.fromJson(Map<String, dynamic> json) {
    return ExamItem(
      id: json['id'].toString(),
      name: json['name'] as String? ?? 'Untitled Exam',
      description: json['description'] as String? ?? 'No description available.',
    );
  }
}

class QuizItem {
  QuizItem({required this.id, required this.name, required this.setName, required this.durationMinutes, required this.optionCount});

  final String id;
  final String name;
  final String setName;
  final int durationMinutes;
  final int optionCount;

  factory QuizItem.fromJson(Map<String, dynamic> json) {
    return QuizItem(
      id: json['id'].toString(),
      name: json['name'] as String? ?? 'Untitled Quiz',
      setName: json['setName'] as String? ?? '',
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      optionCount: (json['optionCount'] as num?)?.toInt() ?? 4,
    );
  }

  String get displayTitle => setName.isNotEmpty ? '$name - $setName' : name;
  String get details => '$optionCount options · $durationMinutes min';
}

class _ExamCard extends StatelessWidget {
  const _ExamCard({required this.title, required this.subtitle, required this.onTap});

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  const _QuizCard({required this.title, required this.details, required this.onTap});

  final String title;
  final String details;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(details),
        trailing: const Icon(Icons.play_arrow),
        onTap: onTap,
      ),
    );
  }
}
