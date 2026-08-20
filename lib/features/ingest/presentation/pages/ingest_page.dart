import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:docu_mind/core/theme/app_colors.dart';
import 'package:docu_mind/core/theme/app_spacing.dart';
import 'package:docu_mind/core/utils/file_upload.dart';
import 'package:docu_mind/features/ingest/presentation/providers/ingest_provider.dart';

/// Modern upload page with visual feedback.
class IngestPage extends ConsumerStatefulWidget {
  const IngestPage({super.key});

  @override
  ConsumerState<IngestPage> createState() => _IngestPageState();
}

class _IngestPageState extends ConsumerState<IngestPage>
    with SingleTickerProviderStateMixin {
  String? _selectedFileName;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // Required for web — gives us bytes
    );

    if (result == null || result.files.isEmpty) return;

    final pickedFile = result.files.single;
    final name = pickedFile.name;

    FileUpload fileUpload;

    if (kIsWeb) {
      // Web: use bytes (path is always null on web)
      if (pickedFile.bytes == null) return;
      fileUpload = FileUpload(name: name, bytes: pickedFile.bytes);
    } else {
      // Native: use file path
      if (pickedFile.path == null) return;
      fileUpload = FileUpload(name: name, path: pickedFile.path);
    }

    setState(() => _selectedFileName = name);

    if (mounted) {
      await ref.read(ingestProvider.notifier).ingest(fileUpload);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ingestState = ref.watch(ingestProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload PDF',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xxl),

              // ── Upload Area ───────────────────────────
              _buildUploadContent(ingestState, isDark),

              const SizedBox(height: AppSpacing.xxl),

              // ── Tips ──────────────────────────────────
              _buildTips(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadContent(AsyncValue<dynamic> ingestState, bool isDark) {
    if (ingestState is AsyncLoading) {
      return _buildUploadingState(isDark);
    }

    if (ingestState is AsyncError) {
      // Show error then allow retry
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ingestState.error.toString()),
              backgroundColor: AppColors.error,
            ),
          );
          ref.read(ingestProvider.notifier).reset();
        }
      });
      return _buildUploadArea(isDark);
    }

    // AsyncData
    final result = ingestState.value;
    if (result != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(result.message)),
                ],
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          );
          ref.read(ingestProvider.notifier).reset();
          setState(() => _selectedFileName = null);
        }
      });
    }

    return _buildUploadArea(isDark);
  }

  Widget _buildUploadArea(bool isDark) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return GestureDetector(
          onTap: _pickFile,
          child: Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceVariantDark
                  : AppColors.surfaceVariantLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              border: Border.all(
                color: AppColors.primary.withValues(
                  alpha: 0.2 + 0.1 * _pulseController.value,
                ),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.cloud_upload_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Tap to select a PDF',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Supports .pdf files',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiaryLight,
                  ),
                ),
                if (_selectedFileName != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      _selectedFileName!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95)),
        );
      },
    );
  }

  Widget _buildUploadingState(bool isDark) {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Uploading & processing...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This may take a moment',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildTips(bool isDark) {
    final tips = [
      ('📄', 'PDF files are processed using RAG'),
      ('💬', 'Ask questions about your documents'),
      ('🔒', 'Files are processed securely'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How it works',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: AppSpacing.md),
        ...tips.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Text(entry.value.$1, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: AppSpacing.md),
                Text(
                  entry.value.$2,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: 300 + entry.key * 100));
        }),
      ],
    );
  }
}
