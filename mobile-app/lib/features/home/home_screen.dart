import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam Prep')),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Choose Exam', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _ExamCard(
              title: 'BPSC TRE 4.0',
              subtitle: 'Computer Science, GK, Mathematics',
              onTap: () => context.go('/exam/1'),
            ),
            _ExamCard(
              title: 'SSC CGL',
              subtitle: 'Quant, Reasoning, English',
              onTap: () => context.go('/exam/2'),
            ),
            _ExamCard(
              title: 'Banking',
              subtitle: 'Prelims and Mains practice',
              onTap: () => context.go('/exam/3'),
            ),
            const SizedBox(height: 24),
            const Text('Featured Quizzes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _QuizCard(
              title: 'Java Basics',
              details: '25 questions · 20 min · 4 options',
              onTap: () => context.go('/quiz-detail/1'),
            ),
            _QuizCard(
              title: 'Java OOP Practice',
              details: '30 questions · 25 min · 5 options',
              onTap: () => context.go('/quiz-detail/2'),
            ),
            const SizedBox(height: 24),
            const Text('Latest Mock Tests', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _QuizCard(
              title: 'BPSC TRE Mock Test 1',
              details: '120 questions · 120 min · 5 options',
              onTap: () => context.go('/quiz-detail/3'),
            ),
          ],
        ),
      ),
    );
  }
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
