import 'package:flutter/material.dart';
import '../../core/app_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('About Exam Prep', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              SizedBox(height: 16),
              Text('Exam Prep helps you prepare for competitive exams with curated quizzes, mock tests, and topic-based practice.', style: TextStyle(fontSize: 16, height: 1.5)),
              SizedBox(height: 24),
              Text('Features', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              SizedBox(height: 12),
              Text('- Home dashboard for quick access', style: TextStyle(fontSize: 16, height: 1.4)),
              Text('- User profile and account management', style: TextStyle(fontSize: 16, height: 1.4)),
              Text('- About and version information', style: TextStyle(fontSize: 16, height: 1.4)),
              Text('- Exam list, quiz details, and result tracking', style: TextStyle(fontSize: 16, height: 1.4)),
            ],
          ),
        ),
      ),
    );
  }
}
