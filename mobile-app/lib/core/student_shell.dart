import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentShell extends StatelessWidget {
  const StudentShell({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      drawer: const StudentDrawer(),
      body: child,
    );
  }
}

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.school_outlined, size: 38),
                  SizedBox(height: 10),
                  Text('Exam Prep', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                  Text('Prepare, practice, improve'),
                ],
              ),
            ),
            const Divider(height: 1),
            DrawerItem(icon: Icons.home_outlined, label: 'Home', path: '/'),
            DrawerItem(icon: Icons.person_outline, label: 'User Profile', path: '/profile'),
            DrawerItem(icon: Icons.info_outline, label: 'About', path: '/about'),
            DrawerItem(icon: Icons.verified_outlined, label: 'Version', path: '/version'),
            const Divider(height: 1),
            DrawerItem(icon: Icons.login, label: 'Login', path: '/login'),
            DrawerItem(icon: Icons.person_add_alt_1_outlined, label: 'Register', path: '/register'),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({required this.icon, required this.label, required this.path, super.key});

  final IconData icon;
  final String label;
  final String path;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () => context.go(path),
    );
  }
}
