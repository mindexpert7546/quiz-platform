import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_drawer.dart';

class MainShell extends StatelessWidget {
  MainShell({required this.child, required this.location, super.key});

  final Widget child;
  final String location;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String get _title {
    if (location == '/') {
      return 'Kundan Classes';
    }
    if (location.startsWith('/exams')) {
      return 'All Exam Quiz';
    }
    if (location.startsWith('/exam/') && location.contains('/subject/')) {
      return 'Choose Set';
    }
    if (location.startsWith('/exam/')) {
      return 'Choose Subject';
    }
    if (location.startsWith('/quiz-detail/')) {
      return 'Quiz Instructions';
    }
    if (location.startsWith('/activities')) {
      return 'Activities';
    }
    if (location.startsWith('/chat')) {
      return 'Chat';
    }
    if (location.startsWith('/profile')) {
      return 'User Profile';
    }
    return 'Kundan Classes';
  }

  bool get _isHome => location == '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _ShellHeader(
              title: _title,
              isHome: _isHome,
              onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            Expanded(child: child),
            _BottomNavBar(location: location),
          ],
        ),
      ),
    );
  }
}

class _ShellHeader extends StatelessWidget {
  const _ShellHeader({
    required this.title,
    required this.isHome,
    required this.onMenuTap,
  });

  final String title;
  final bool isHome;
  final VoidCallback onMenuTap;

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/quiz-detail/')) {
      context.go('/exams');
    } else if (location.startsWith('/exam/') && location.contains('/subject/')) {
      final examId = location.split('/')[2];
      context.go('/exam/$examId');
    } else if (location.startsWith('/exam/')) {
      context.go('/exams');
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      child: SizedBox(
        height: 58,
        child: Row(
          children: [
            if (isHome)
              IconButton(
                onPressed: onMenuTap,
                icon: const Icon(Icons.menu_rounded, size: 34),
              )
            else
              IconButton(
                onPressed: () => _goBack(context),
                icon: const Icon(Icons.arrow_back_rounded, size: 30),
              ),
            Expanded(
              child: Text(
                title,
                textAlign: isHome ? TextAlign.center : TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF070B2A),
                  fontSize: isHome ? 28 : 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (isHome) ...[
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search_rounded, size: 34),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_rounded, size: 30),
              ),
            ] else
              IconButton(
                onPressed: onMenuTap,
                icon: const Icon(Icons.menu_rounded, size: 30),
              ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.location});

  final String location;

  bool _isSelected(String route) {
    if (route == '/') {
      return location == '/';
    }
    return location.startsWith(route);
  }

  @override
  Widget build(BuildContext context) {
    const items = [
      _BottomNavItem(Icons.home_rounded, 'Home', '/'),
      _BottomNavItem(Icons.checklist_rounded, 'Activities', '/activities'),
      _BottomNavItem(Icons.chat_bubble_outline_rounded, 'Chat', '/chat'),
      _BottomNavItem(Icons.person_outline_rounded, 'Profile', '/profile'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: InkWell(
                onTap: () {
                  if (!_isSelected(item.route)) {
                    context.go(item.route);
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      color: _isSelected(item.route)
                          ? const Color(0xFF1681F2)
                          : const Color(0xFF777B8B),
                      size: 29,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        color: _isSelected(item.route)
                            ? const Color(0xFF1681F2)
                            : const Color(0xFF777B8B),
                        fontWeight: _isSelected(item.route)
                            ? FontWeight.w800
                            : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BottomNavItem {
  const _BottomNavItem(this.icon, this.label, this.route);

  final IconData icon;
  final String label;
  final String route;
}
