import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_client.dart';
import '../../core/app_config.dart';
import '../../core/app_drawer.dart';

class QuizDetailScreen extends ConsumerStatefulWidget {
  const QuizDetailScreen({required this.quizId, super.key});
  final String quizId;

  @override
  ConsumerState<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends ConsumerState<QuizDetailScreen> {
  bool _isLoggedIn = false;
  late final Future<QuizDetail> _quizFuture;

  @override
  void initState() {
    super.initState();
    _quizFuture = _fetchQuizDetails();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _isLoggedIn = prefs.getString(AppConfig.authTokenKey) != null;
    });
  }

  Future<QuizDetail> _fetchQuizDetails() async {
    final dio = ref.read(dioProvider);
    final response = await dio.get('/public/quizzes/${widget.quizId}');
    final data = response.data as Map<String, dynamic>;
    return QuizDetail(
      id: data['id'].toString(),
      name: data['name'] as String? ?? 'Quiz',
      setName: data['setName'] as String? ?? '',
      examName: data['examName'] as String? ?? '',
      subjectName: data['subjectName'] as String? ?? '',
      topicName: data['topicName'] as String? ?? '',
      durationMinutes: (data['durationMinutes'] as num?)?.toInt() ?? 0,
      optionCount: (data['optionCount'] as num?)?.toInt() ?? 4,
      accessType: data['accessType'] as String? ?? 'FREE',
      questionCount: (data['questionCount'] as num?)?.toInt() ?? 0,
    );
  }

  void _handleAction(BuildContext context) {
    if (_isLoggedIn) {
      context.go('/quiz/${widget.quizId}');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Details')),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: FutureBuilder<QuizDetail>(
          future: _quizFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Failed to load quiz details.\n${snapshot.error}', textAlign: TextAlign.center),
                ),
              );
            }

            final quiz = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(quiz.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 10),
                        Text('${quiz.examName} • ${quiz.subjectName}${quiz.topicName.isNotEmpty ? ' • ${quiz.topicName}' : ''}'),
                        const SizedBox(height: 16),
                        DetailRow(label: 'Quiz Set', value: quiz.setName.isNotEmpty ? quiz.setName : 'Standard'),
                        DetailRow(label: 'Questions', value: '${quiz.questionCount}'),
                        DetailRow(label: 'Duration', value: '${quiz.durationMinutes} minutes'),
                        DetailRow(label: 'Options', value: '${quiz.optionCount} options'),
                        DetailRow(label: 'Access', value: quiz.accessType),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () => _handleAction(context),
                  icon: Icon(_isLoggedIn ? Icons.play_arrow : Icons.login),
                  label: Text(_isLoggedIn ? 'Start Quiz' : 'Login or Register to Attend'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class QuizDetail {
  QuizDetail({required this.id, required this.name, required this.setName, required this.examName, required this.subjectName, required this.topicName, required this.durationMinutes, required this.optionCount, required this.accessType, required this.questionCount});

  final String id;
  final String name;
  final String setName;
  final String examName;
  final String subjectName;
  final String topicName;
  final int durationMinutes;
  final int optionCount;
  final String accessType;
  final int questionCount;

  String get title => setName.isNotEmpty ? '$name - $setName' : name;
}

class DetailRow extends StatelessWidget {
  const DetailRow({required this.label, required this.value, super.key});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
