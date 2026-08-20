import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docu_mind/features/splash/presentation/pages/splash_page.dart';

/// Wraps the app with a splash screen that shows during initialization.
///
/// Displays [SplashPage] while the app loads, then transitions to the
/// main app shell using a cross-fade animation.
class SplashWrapper extends ConsumerStatefulWidget {
  const SplashWrapper({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends ConsumerState<SplashWrapper>
    with SingleTickerProviderStateMixin {
  bool _showSplash = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
  }

  void _onSplashComplete() {
    // Fade out splash, fade in app
    _fadeController.forward().then((_) {
      if (mounted) {
        setState(() => _showSplash = false);
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashPage(onInitializationComplete: _onSplashComplete);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child,
    );
  }
}
