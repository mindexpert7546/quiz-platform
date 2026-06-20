import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Score', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('82%', style: TextStyle(fontSize: 46, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.primary)),
                  const SizedBox(height: 12),
                  const Text('41 / 50 marks'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const ResultRow(label: 'Correct Answers', value: '41'),
          const ResultRow(label: 'Wrong Answers', value: '9'),
          const ResultRow(label: 'Time Taken', value: '18m 42s'),
          const ResultRow(label: 'Rank', value: '#24'),
          const SizedBox(height: 20),
          FilledButton(onPressed: () => context.go('/'), child: const Text('Back to Home')),
        ],
      ),
    );
  }
}

class ResultRow extends StatelessWidget {
  const ResultRow({required this.label, required this.value, super.key});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
