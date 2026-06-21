import 'package:flutter/material.dart';
import '../../core/app_drawer.dart';

class HelpFeedbackScreen extends StatelessWidget {
  const HelpFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Feedback')),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Help & Feedback', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              SizedBox(height: 16),
              Text('Need help or want to send feedback? Reach out to our support team from here.', style: TextStyle(fontSize: 16, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}
