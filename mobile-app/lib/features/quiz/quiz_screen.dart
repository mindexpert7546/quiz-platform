import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_drawer.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({required this.quizId, super.key});
  final String quizId;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int index = 0;
  int secondsLeft = 1200;
  late final Timer timer;
  final selected = <int, String>{};
  final marked = <int>{};

  final questions = const [
    'Which Java keyword prevents a class from being inherited?',
    'Which normal form removes transitive dependency?',
    'Which protocol is used to translate domain names to IP addresses?',
  ];

  final options = const ['final', 'static', 'private', 'sealed', 'abstract'];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsLeft == 0) {
        context.go('/result');
      } else {
        setState(() => secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[index];
    final minutes = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsLeft % 60).toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz ${widget.quizId}'),
        actions: [Center(child: Padding(padding: const EdgeInsets.only(right: 16), child: Text('$minutes:$seconds')))],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: (index + 1) / questions.length),
            const SizedBox(height: 20),
            Text('Question ${index + 1} of ${questions.length}', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text(question, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 18),
            for (final option in options)
              Card(
                child: RadioListTile<String>(
                  value: option,
                  groupValue: selected[index],
                  onChanged: (value) => setState(() => selected[index] = value!),
                  title: Text(option),
                ),
              ),
            const Spacer(),
            Row(
              children: [
                IconButton.filledTonal(onPressed: index == 0 ? null : () => setState(() => index--), icon: const Icon(Icons.chevron_left)),
                const SizedBox(width: 8),
                IconButton.filledTonal(onPressed: () => setState(() => marked.add(index)), icon: const Icon(Icons.bookmark_add_outlined)),
                const Spacer(),
                FilledButton(
                  onPressed: index == questions.length - 1 ? () => context.go('/result') : () => setState(() => index++),
                  child: Text(index == questions.length - 1 ? 'Submit' : 'Next'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
