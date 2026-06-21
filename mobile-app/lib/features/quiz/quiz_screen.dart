import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_client.dart';
import '../../core/app_drawer.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({required this.quizId, super.key});
  final String quizId;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int index = 0;
  int secondsLeft = 1200;
  Timer? timer;
  late final Future<List<QuestionItem>> _questionsFuture;
  final selected = <int, String>{};

  @override
  void initState() {
    super.initState();
    _questionsFuture = _fetchQuestions();
  }

  Future<List<QuestionItem>> _fetchQuestions() async {
    final dio = ref.read(dioProvider);
    final response = await dio.get('/public/quizzes/${widget.quizId}/questions');
    final data = response.data as List<dynamic>;
    final questions = data.cast<Map<String, dynamic>>().map(QuestionItem.fromJson).toList();
    if (questions.isNotEmpty) {
      _startTimer(defaultSeconds: questions.length * 60);
    }
    return questions;
  }

  void _startTimer({required int defaultSeconds}) {
    secondsLeft = defaultSeconds;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (secondsLeft == 0) {
        timer?.cancel();
        context.go('/result');
      } else {
        setState(() => secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz ${widget.quizId}'),
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: FutureBuilder<List<QuestionItem>>(
          future: _questionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Unable to load quiz questions.\n${snapshot.error}', textAlign: TextAlign.center),
                ),
              );
            }

            final questions = snapshot.data!;
            if (questions.isEmpty) {
              return const Center(child: Text('No questions were found for this quiz.'));
            }

            final current = questions[index];
            final minutes = (secondsLeft ~/ 60).toString().padLeft(2, '0');
            final seconds = (secondsLeft % 60).toString().padLeft(2, '0');
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(value: (index + 1) / questions.length),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: Text('Question ${index + 1} of ${questions.length}', style: const TextStyle(fontWeight: FontWeight.w700))),
                      Text('$minutes:$seconds', style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(current.questionText, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),
                  RadioGroup<String>(
                    groupValue: selected[index],
                    onChanged: (value) => setState(() => selected[index] = value ?? ''),
                    child: Column(
                      children: current.options.map((option) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: RadioListTile<String>(
                            value: option,
                            title: Text(option),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: index == 0 ? null : () => setState(() => index--),
                        icon: const Icon(Icons.chevron_left),
                      ),
                      const SizedBox(width: 8),
                      const Spacer(),
                      FilledButton(
                        onPressed: index == questions.length - 1
                            ? () => context.go('/result')
                            : () => setState(() => index++),
                        child: Text(index == questions.length - 1 ? 'Submit' : 'Next'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class QuestionItem {
  QuestionItem({required this.id, required this.questionText, required this.options});

  final String id;
  final String questionText;
  final List<String> options;

  factory QuestionItem.fromJson(Map<String, dynamic> json) {
    final optionValues = <String>[];
    void addOption(String? value) {
      if (value != null && value.trim().isNotEmpty) {
        optionValues.add(value.trim());
      }
    }

    addOption(json['optionA'] as String?);
    addOption(json['optionB'] as String?);
    addOption(json['optionC'] as String?);
    addOption(json['optionD'] as String?);
    addOption(json['optionE'] as String?);

    return QuestionItem(
      id: json['id'].toString(),
      questionText: json['questionText'] as String? ?? 'Question text not available',
      options: optionValues.isNotEmpty ? optionValues : ['No options available'],
    );
  }
}
