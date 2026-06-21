import 'package:flutter/material.dart';
import '../../core/app_drawer.dart';

class RateScreen extends StatelessWidget {
  const RateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate')),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Rate the App', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              SizedBox(height: 16),
              Text('Thank you for using Exam Prep. Please rate the app and help us improve.', style: TextStyle(fontSize: 16, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}
