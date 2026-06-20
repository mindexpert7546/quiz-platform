import 'package:flutter/material.dart';
import '../../core/app_drawer.dart';

class VersionScreen extends StatelessWidget {
  const VersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Version')),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('App Version', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              SizedBox(height: 20),
              Text('Exam Prep v1.0.0', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('Build Number: 1', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('This version includes the latest exam list, quiz details, and profile modules.', style: TextStyle(fontSize: 16, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}
