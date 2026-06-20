import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/student_shell.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const exams = [
    {'id': '1', 'name': 'BPSC TRE 4.0', 'meta': 'Computer Science, GK, Mathematics'},
    {'id': '2', 'name': 'SSC CGL', 'meta': 'Quant, Reasoning, English'},
    {'id': '3', 'name': 'Banking', 'meta': 'Prelims and Mains practice'},
  ];

  @override
  Widget build(BuildContext context) {
    return StudentShell(
      title: 'Exam Prep',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Choose Exam', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          for (final exam in exams)
            Card(
              child: ListTile(
                leading: const Icon(Icons.school_outlined),
                title: Text(exam['name']!),
                subtitle: Text(exam['meta']!),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/exam/${exam['id']}'),
              ),
            ),
          const SizedBox(height: 20),
          const SectionTitle(title: 'Featured Quizzes'),
          QuizTile(title: 'Java Basics', subtitle: '25 questions - 20 min - 4 options', onTap: () => context.go('/quiz-detail/1')),
          QuizTile(title: 'Java OOP Practice', subtitle: '30 questions - 25 min - 5 options', onTap: () => context.go('/quiz-detail/2')),
          const SizedBox(height: 20),
          const SectionTitle(title: 'Latest Mock Tests'),
          QuizTile(title: 'BPSC TRE Mock Test 1', subtitle: '120 questions - 120 min - 5 options', onTap: () => context.go('/quiz-detail/mock-1')),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      );
}

class QuizTile extends StatelessWidget {
  const QuizTile({required this.title, required this.subtitle, required this.onTap, super.key});
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.play_arrow_rounded),
        onTap: onTap,
      ),
    );
  }
}
