import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<Map<String, String>> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('student_name') ?? 'Guest User',
      'email': prefs.getString('student_email') ?? 'guest@example.com',
      'mobile': prefs.getString('student_mobile') ?? 'Not available',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: FutureBuilder<Map<String, String>>(
          future: _loadProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final profile = snapshot.data ?? {
              'name': 'Guest User',
              'email': 'guest@example.com',
              'mobile': 'Not available',
            };
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Profile Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 24),
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Full Name'),
                    subtitle: Text(profile['name']!),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Email'),
                    subtitle: Text(profile['email']!),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone_android),
                    title: const Text('Mobile No'),
                    subtitle: Text(profile['mobile']!),
                  ),
                  const SizedBox(height: 24),
                  const Text('Your account settings and profile data will appear here.', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
