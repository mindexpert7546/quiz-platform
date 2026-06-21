import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/about/about_screen.dart';
import 'features/activities/activities_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/chat/chat_screen.dart';
import 'features/exam/exam_detail_screen.dart';
import 'features/exam/exam_list_screen.dart';
import 'features/exam/subject_quiz_sets_screen.dart';
import 'features/home/home_screen.dart';
import 'features/help_feedback/help_feedback_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/purchases/purchases_screen.dart';
import 'features/rate/rate_screen.dart';
import 'features/refer_earn/refer_earn_screen.dart';
import 'features/share/share_screen.dart';
import 'features/version/version_screen.dart';
import 'features/quiz/quiz_detail_screen.dart';
import 'features/quiz/quiz_screen.dart';
import 'features/results/result_screen.dart';
import 'core/main_shell.dart';

void main() {
  runApp(const ProviderScope(child: ExamPrepApp()));
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            MainShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
              path: '/activities',
              builder: (context, state) => const ActivitiesScreen()),
          GoRoute(
              path: '/chat', builder: (context, state) => const ChatScreen()),
          GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen()),
          GoRoute(
              path: '/exams',
              builder: (context, state) => const ExamListScreen()),
          GoRoute(
              path: '/exam/:id',
              builder: (context, state) =>
                  ExamDetailScreen(examId: state.pathParameters['id']!)),
          GoRoute(
            path: '/exam/:examId/subject/:subjectId',
            builder: (context, state) => SubjectQuizSetsScreen(
              examId: state.pathParameters['examId']!,
              subjectId: state.pathParameters['subjectId']!,
            ),
          ),
          GoRoute(
              path: '/quiz-detail/:id',
              builder: (context, state) =>
                  QuizDetailScreen(quizId: state.pathParameters['id']!)),
        ],
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen()),
      GoRoute(
          path: '/purchases',
          builder: (context, state) => const PurchasesScreen()),
      GoRoute(
          path: '/help-feedback',
          builder: (context, state) => const HelpFeedbackScreen()),
      GoRoute(
          path: '/refer-earn',
          builder: (context, state) => const ReferEarnScreen()),
      GoRoute(path: '/rate', builder: (context, state) => const RateScreen()),
      GoRoute(path: '/share', builder: (context, state) => const ShareScreen()),
      GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
      GoRoute(
          path: '/version', builder: (context, state) => const VersionScreen()),
      GoRoute(
          path: '/quiz/:id',
          builder: (context, state) =>
              QuizScreen(quizId: state.pathParameters['id']!)),
      GoRoute(
          path: '/result', builder: (context, state) => const ResultScreen()),
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
      ),
      routerConfig: router,
    );
  }
}
