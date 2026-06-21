import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_config.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _displayValue(String? value, String fallback) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? fallback : trimmed;
  }

  String _displayName(String? name, String? email) {
    final trimmedName = name?.trim();
    if (trimmedName != null && trimmedName.isNotEmpty) {
      return trimmedName;
    }
    final trimmedEmail = email?.trim();
    if (trimmedEmail != null && trimmedEmail.isNotEmpty) {
      return trimmedEmail.split('@').first;
    }
    return 'Guest User';
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.authTokenKey);
    await prefs.remove('student_name');
    await prefs.remove('student_email');
    await prefs.remove('student_mobile');
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            final prefs = snapshot.data;
            final isLoggedIn = prefs?.getString(AppConfig.authTokenKey) != null;
            final email = _displayValue(prefs?.getString('student_email'), 'guest@example.com');
            final name = _displayName(prefs?.getString('student_name'), prefs?.getString('student_email'));

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFF2563EB)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(radius: 28, backgroundColor: Colors.white, child: Icon(Icons.person, size: 32, color: Color(0xFF2563EB))),
                      const SizedBox(height: 16),
                      Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(email, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
                _buildListTile(context, Icons.home, 'Home', '/'),
                _buildListTile(context, Icons.person, 'My Profile', '/profile'),
                _buildListTile(context, Icons.shopping_bag, 'Purchases', '/purchases'),
                _buildListTile(context, Icons.help_outline, 'Help & Feedback', '/help-feedback'),
                _buildListTile(context, Icons.card_giftcard, 'Refer & Earn', '/refer-earn'),
                _buildListTile(context, Icons.star_rate, 'Rate', '/rate'),
                _buildListTile(context, Icons.share, 'Share', '/share'),
                const Spacer(),
                if (isLoggedIn)
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      Navigator.pop(context);
                      await _logout();
                    },
                  )
                else
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text('Login'),
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/login');
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
