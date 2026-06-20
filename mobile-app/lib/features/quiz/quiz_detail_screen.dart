import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuizDetailScreen extends StatelessWidget {
  const QuizDetailScreen({required this.quizId, super.key});
  final String quizId;

  @override
  Widget build(BuildContext context) {
    final isFiveOption = quizId == '2' || quizId == 'mock-1';
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isFiveOption ? 'Java OOP Practice' : 'Java Basics', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  const Text('BPSC TRE 4.0 - Computer Science - Java'),
                  const SizedBox(height: 16),
                  DetailRow(label: 'Quiz Set', value: isFiveOption ? 'Set 2' : 'Set 1'),
                  DetailRow(label: 'Questions', value: isFiveOption ? '30' : '25'),
                  DetailRow(label: 'Duration', value: isFiveOption ? '25 minutes' : '20 minutes'),
                  DetailRow(label: 'Options', value: isFiveOption ? '5 options' : '4 options'),
                  DetailRow(label: 'Access', value: isFiveOption ? 'Paid' : 'Free'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => context.go('/login'),
            icon: const Icon(Icons.login),
            label: const Text('Login or Register to Attend'),
          ),
        ],
      ),
    );
  }
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
