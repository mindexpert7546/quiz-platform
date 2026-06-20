import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/about/about_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/exam/exam_detail_screen.dart';
import 'features/home/home_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/version/version_screen.dart';
import 'features/quiz/quiz_detail_screen.dart';
import 'features/quiz/quiz_screen.dart';
import 'features/results/result_screen.dart';

void main() {
  runApp(const ProviderScope(child: ExamPrepApp()));
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
      GoRoute(path: '/version', builder: (context, state) => const VersionScreen()),      GoRoute(path: '/exam/:id', builder: (context, state) => ExamDetailScreen(examId: state.pathParameters['id']!)),
      GoRoute(path: '/quiz-detail/:id', builder: (context, state) => QuizDetailScreen(quizId: state.pathParameters['id']!)),
      GoRoute(path: '/quiz/:id', builder: (context, state) => QuizScreen(quizId: state.pathParameters['id']!)),
      GoRoute(path: '/result', builder: (context, state) => const ResultScreen()),
    ],
  );
});

class ExamPrepApp extends ConsumerWidget {
  const ExamPrepApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Exam Prep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
      ),
      routerConfig: router,
    );
  }
}
