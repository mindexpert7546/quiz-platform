import 'package:flutter/material.dart';
import '../../core/app_drawer.dart';

class PurchasesScreen extends StatelessWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchases')),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Purchases', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              SizedBox(height: 16),
              Text('Your purchased quizzes and mock tests will appear here.', style: TextStyle(fontSize: 16, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}
