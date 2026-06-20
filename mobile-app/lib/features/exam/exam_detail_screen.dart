import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExamDetailScreen extends StatelessWidget {
  const ExamDetailScreen({required this.examId, super.key});
  final String examId;

  @override
  Widget build(BuildContext context) {
    final subjects = ['Computer Science', 'Mathematics', 'General Knowledge'];
    return Scaffold(
      appBar: AppBar(title: const Text('BPSC TRE 4.0')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Full exam preparation', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                SizedBox(height: 8),
                Text('Subject quizzes, mock tests, notes, and performance reports.'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Subjects', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          for (final subject in subjects)
            Card(
              child: ListTile(
                title: Text(subject),
                subtitle: const Text('Quizzes, topics, and notes'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.go('/quiz-detail/mock-1'),
            icon: const Icon(Icons.assignment_outlined),
            label: const Text('View Latest Mock Test'),
          ),
        ],
      ),
    );
  }
}
