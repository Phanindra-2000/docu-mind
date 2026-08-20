import 'package:flutter/material.dart';

/// Semantic color tokens for the app.
///
/// Follows Material 3 color system with custom brand overrides.
abstract final class AppColors {
  // ── Brand ────────────────────────────────────────────────
  static const Color primary = Color(0xFF6366F1);       // Indigo 500
  static const Color primaryLight = Color(0xFF818CF8);   // Indigo 400
  static const Color primaryDark = Color(0xFF4F46E5);    // Indigo 600
  static const Color secondary = Color(0xFF8B5CF6);      // Violet 500
  static const Color accent = Color(0xFF06B6D4);         // Cyan 500

  // ── Gradient ─────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Light Theme ──────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF1F5F9);
  static const Color cardLight = Color(0xFFFFFFFF);

  // ── Dark Theme ───────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceVariantDark = Color(0xFF334155);
  static const Color cardDark = Color(0xFF1E293B);

  // ── Text ─────────────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textTertiaryLight = Color(0xFF94A3B8);

  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);

  // ── Chat Bubbles ─────────────────────────────────────────
  static const Color userBubbleLight = Color(0xFF6366F1);
  static const Color assistantBubbleLight = Color(0xFFFFFFFF);
  static const Color userBubbleDark = Color(0xFF6366F1);
  static const Color assistantBubbleDark = Color(0xFF1E293B);

  // ── Status ───────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ── Misc ─────────────────────────────────────────────────
  static const Color divider = Color(0xFFE2E8F0);
  static const Color dividerDark = Color(0xFF334155);
  static const Color shimmer = Color(0xFFE2E8F0);
  static const Color shimmerDark = Color(0xFF334155);
  static const Color overlay = Color(0x80000000);
}
