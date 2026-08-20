import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:docu_mind/core/router/app_shell.dart';
import 'package:docu_mind/features/chat/presentation/pages/chat_page.dart';
import 'package:docu_mind/features/documents/presentation/pages/documents_page.dart';
import 'package:docu_mind/features/ingest/presentation/pages/ingest_page.dart';
import 'package:docu_mind/features/home/presentation/pages/home_page.dart';

/// Centralized route definitions.
abstract final class AppRouter {
  static final router = GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: false,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
              transitionsBuilder: _fadeTransition,
            ),
          ),
          GoRoute(
            path: '/documents',
            name: 'documents',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const DocumentsPage(),
              transitionsBuilder: _fadeTransition,
            ),
          ),
          GoRoute(
            path: '/upload',
            name: 'upload',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const IngestPage(),
              transitionsBuilder: _slideUpTransition,
            ),
          ),
        ],
      ),
      // Chat is a full-screen route outside the shell
      GoRoute(
        path: '/chat',
        name: 'chat',
        pageBuilder: (context, state) {
          final filename = state.extra as String?;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ChatPage(filename: filename),
            transitionsBuilder: _slideLeftTransition,
          );
        },
      ),
    ],
  );

  static Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      child: child,
    );
  }

  static Widget _slideUpTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween(begin: const Offset(0, 0.05), end: Offset.zero)
        .chain(CurveTween(curve: Curves.easeOutCubic));
    return SlideTransition(
      position: animation.drive(tween),
      child: FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      ),
    );
  }

  static Widget _slideLeftTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.easeOutCubic));
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
