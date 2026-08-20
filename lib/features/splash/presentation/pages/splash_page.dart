import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:docu_mind/core/theme/app_spacing.dart';

/// Animated splash screen shown while the app initializes.
///
/// Displays the DocuMind logo with a staggered entrance animation,
/// shimmer effect on the tagline, and a pulsing loading indicator.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key, this.onInitializationComplete});

  /// Called when the splash animation completes and the app is ready.
  final VoidCallback? onInitializationComplete;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();

    // Subtle background gradient animation
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Auto-navigate after animation completes
    _startNavigationTimer();
  }

  void _startNavigationTimer() {
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) {
        widget.onInitializationComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, _) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Color.lerp(
                          const Color(0xFF1E1B4B),
                          const Color(0xFF312E81),
                          _bgController.value,
                        )!,
                        const Color(0xFF0F0D2E),
                        Color.lerp(
                          const Color(0xFF312E81),
                          const Color(0xFF1E1B4B),
                          _bgController.value,
                        )!,
                      ]
                    : [
                        Color.lerp(
                          const Color(0xFF4F46E5),
                          const Color(0xFF6366F1),
                          _bgController.value,
                        )!,
                        const Color(0xFF4338CA),
                        Color.lerp(
                          const Color(0xFF6366F1),
                          const Color(0xFF4F46E5),
                          _bgController.value,
                        )!,
                      ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // ── Logo ──────────────────────────────
                  _buildLogo(),

                  const SizedBox(height: AppSpacing.xxl),

                  // ── App Name ──────────────────────────
                  _buildAppName(),

                  const SizedBox(height: AppSpacing.sm),

                  // ── Tagline ───────────────────────────
                  _buildTagline(),

                  const Spacer(flex: 2),

                  // ── Loading Indicator ─────────────────
                  _buildLoadingIndicator(),

                  const SizedBox(height: AppSpacing.xxl),

                  // ── Version ───────────────────────────
                  _buildVersion(),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          'assets/images/splash_icon.png',
          width: 100,
          height: 100,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.auto_awesome,
            size: 60,
            color: Colors.white,
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 200.ms)
        .scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(1, 1),
          duration: 800.ms,
          delay: 200.ms,
          curve: Curves.elasticOut,
        )
        .then()
        .shimmer(
          duration: 1200.ms,
          delay: 600.ms,
          color: Colors.white.withValues(alpha: 0.3),
        );
  }

  Widget _buildAppName() {
    return Text(
      'DocuMind',
      style: const TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 600.ms)
        .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 600.ms);
  }

  Widget _buildTagline() {
    return Text(
      'AI-Powered Document Intelligence',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.white.withValues(alpha: 0.8),
        letterSpacing: 0.5,
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 900.ms)
        .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 900.ms)
        .then(delay: 400.ms)
        .shimmer(
          duration: 1500.ms,
          color: Colors.white.withValues(alpha: 0.4),
        );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 36,
      height: 36,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.white.withValues(alpha: 0.8),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 1400.ms)
        .then(delay: 200.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 600.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildVersion() {
    return Text(
      'v1.0.0',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white.withValues(alpha: 0.5),
        letterSpacing: 1.5,
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 1600.ms);
  }
}
