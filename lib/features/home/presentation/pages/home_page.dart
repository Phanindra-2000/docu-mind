import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:docu_mind/core/theme/app_colors.dart';
import 'package:docu_mind/core/theme/app_spacing.dart';
import 'package:docu_mind/features/home/presentation/widgets/quick_action_card.dart';
import 'package:docu_mind/features/home/presentation/widgets/stat_card.dart';
import 'package:docu_mind/features/home/presentation/widgets/recent_document_tile.dart';
import 'package:docu_mind/features/documents/presentation/providers/documents_provider.dart';

/// Dashboard home page with quick actions and recent activity.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDocuments = ref.watch(documentsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ────────────────────────────────────
            SliverToBoxAdapter(
              child: _Header(isDark: isDark),
            ),

            // ── Quick Actions ─────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),

            // ── Action Cards ──────────────────────────────
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  children: [
                    QuickActionCard(
                      icon: Icons.chat_bubble_rounded,
                      label: 'New Chat',
                      gradient: AppColors.primaryGradient,
                      onTap: () => context.push('/chat'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    QuickActionCard(
                      icon: Icons.cloud_upload_rounded,
                      label: 'Upload PDF',
                      gradient: AppColors.accentGradient,
                      onTap: () => context.push('/upload'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    QuickActionCard(
                      icon: Icons.folder_open_rounded,
                      label: 'Documents',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                      ),
                      onTap: () => context.push('/documents'),
                    ),
                  ],
                ),
              ),
            ),

            // ── Stats ─────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  top: AppSpacing.xl,
                  bottom: AppSpacing.md,
                ),
                child: Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: asyncDocuments.when(
                loading: () => const SizedBox.shrink(),
                error: (_, e) => const SizedBox.shrink(),
                data: (docs) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          value: '${docs.length}',
                          label: 'Documents',
                          icon: Icons.description_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: StatCard(
                          value: 'Ready',
                          label: 'AI Status',
                          icon: Icons.check_circle_rounded,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: StatCard(
                          value: '∞',
                          label: 'Chats',
                          icon: Icons.forum_rounded,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                ),
              ),
            ),

            // ── Recent Documents ──────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  top: AppSpacing.xl,
                  bottom: AppSpacing.md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Documents',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/documents'),
                      child: const Text('See all'),
                    ),
                  ],
                ),
              ),
            ),

            // ── Document List ─────────────────────────────
            asyncDocuments.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: AppColors.error),
                      const SizedBox(height: AppSpacing.lg),
                      Text(error.toString()),
                      const SizedBox(height: AppSpacing.lg),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(documentsProvider.notifier).refresh(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (documents) {
                if (documents.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_file_rounded,
                            size: 64,
                            color: isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textTertiaryLight,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'No documents yet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Upload a PDF to get started',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textTertiaryDark
                                  : AppColors.textTertiaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.xs,
                        ),
                        child: RecentDocumentTile(
                          document: documents[index],
                          onTap: () => context.push(
                            '/chat',
                            extra: documents[index].filename,
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(
                            delay: Duration(
                                milliseconds: 100 + index * 50),
                          )
                          .slideX(begin: 0.05);
                    },
                    childCount: documents.length.clamp(0, 5),
                  ),
                );
              },
            ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xxl),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dashboard header with greeting and search.
class _Header extends StatelessWidget {
  final bool isDark;

  const _Header({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting 👋',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ).animate().fadeIn().slideX(begin: -0.05),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'What would you like to explore?',
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ).animate().fadeIn(delay: 100.ms),
                  ],
                ),
              ),
              // Profile avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Search bar
          GestureDetector(
            onTap: () => context.push('/documents'),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceVariantDark
                    : AppColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(
                  color: isDark ? AppColors.dividerDark : AppColors.divider,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 22,
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiaryLight,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Search documents...',
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
          ),
        ],
      ),
    );
  }
}
