import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title will update soon.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _HomeTileData(
        title: 'All Exam\nQuiz',
        subtitle: '| Test Karo',
        icon: Icons.quiz_outlined,
        backgroundColor: const Color(0xFFE7F2FF),
        iconColor: const Color(0xFF1D7DEB),
        onTap: () => context.go('/exams'),
      ),
      _HomeTileData(
        title: 'Syllabus',
        icon: Icons.menu_book_rounded,
        backgroundColor: const Color(0xFFE8F7EC),
        iconColor: const Color(0xFF19A55A),
        onTap: () => _showComingSoon(context, 'Syllabus'),
      ),
      _HomeTileData(
        title: 'All Exam\nPYQ',
        icon: Icons.description_outlined,
        backgroundColor: const Color(0xFFF0EAFF),
        iconColor: const Color(0xFF6750D8),
        onTap: () => _showComingSoon(context, 'All Exam PYQ'),
      ),
      _HomeTileData(
        title: 'Current\nAffairs',
        icon: Icons.newspaper_rounded,
        backgroundColor: const Color(0xFFFFF2DF),
        iconColor: const Color(0xFF6B7280),
        onTap: () => _showComingSoon(context, 'Current Affairs'),
      ),
      _HomeTileData(
        title: 'Test Karo',
        icon: Icons.desktop_windows_outlined,
        backgroundColor: const Color(0xFFE4F2FF),
        iconColor: const Color(0xFF1677E8),
        onTap: () => context.go('/exams'),
      ),
      _HomeTileData(
        title: 'Job Alerts',
        icon: Icons.work_rounded,
        backgroundColor: const Color(0xFFF7E9FB),
        iconColor: const Color(0xFF7C4A38),
        onTap: () => _showComingSoon(context, 'Job Alerts'),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      children: [
        const _HeroBanner(),
        const SizedBox(height: 26),
        GridView.builder(
          itemCount: tiles.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.48,
          ),
          itemBuilder: (context, index) => _HomeTile(data: tiles[index]),
        ),
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 212,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF111111), Color(0xFF30220A), Color(0xFF050505)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -26,
              bottom: -22,
              child: Icon(Icons.train_rounded,
                  size: 172, color: Colors.orange.withValues(alpha: 0.36)),
            ),
            Positioned(
              left: 20,
              top: 18,
              right: 122,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ALP CBT-2',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'कैसे करें बैच',
                    style: TextStyle(
                        color: Color(0xFFFFC107),
                        fontSize: 34,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),
                  const _BannerChip(text: 'CBT-2 (PART A & B)'),
                  const SizedBox(height: 10),
                  const _BannerChip(
                      text: 'Live Recorded Class  |  Test Series'),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                          color: const Color(0xFFFFD600), width: 1.5),
                    ),
                    child: const Text(
                      'Join Now',
                      style: TextStyle(
                          color: Color(0xFFFFB300),
                          fontSize: 24,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 18,
              bottom: 0,
              child: Icon(Icons.person_rounded,
                  color: const Color(0xFFFFC766).withValues(alpha: 0.92),
                  size: 172),
            ),
            Positioned(
              right: 14,
              bottom: 14,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD22E),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text('By Ashutosh Sir',
                    style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerChip extends StatelessWidget {
  const _BannerChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: const Color(0xFFFFD600).withValues(alpha: 0.55)),
      ),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800)),
    );
  }
}

class _HomeTileData {
  const _HomeTileData({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;
}

class _HomeTile extends StatelessWidget {
  const _HomeTile({required this.data});

  final _HomeTileData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: data.onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: data.backgroundColor,
                child: Icon(data.icon, color: data.iconColor, size: 38),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF070B2A),
                        fontSize: 21,
                        height: 1.18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (data.subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        data.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF1681F2),
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
