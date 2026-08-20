import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:docu_mind/core/theme/app_colors.dart';
import 'package:docu_mind/core/theme/app_spacing.dart';
import 'package:docu_mind/features/chat/domain/entities/message.dart';

/// Modern chat message bubble with actions.
class ChatBubble extends StatefulWidget {
  final Message message;
  final bool showAvatar;

  const ChatBubble({
    super.key,
    required this.message,
    this.showAvatar = true,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool _showActions = false;

  bool get _isUser => widget.message.role == MessageRole.user;
  bool get _isSystem => widget.message.role == MessageRole.system;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isSystem) {
      return _SystemMessage(text: widget.message.content);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment:
            _isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!_isUser) ...[
            // Assistant avatar
            if (widget.showAvatar)
              _Avatar(isDark: isDark)
            else
              const SizedBox(width: AppSpacing.avatarMd + AppSpacing.sm),
            const SizedBox(width: AppSpacing.sm),
          ],
          // Bubble
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                HapticFeedback.mediumImpact();
                setState(() => _showActions = !_showActions);
              },
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: Column(
                  crossAxisAlignment: _isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width *
                            AppSpacing.chatBubbleMaxWidth,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: _isUser
                            ? AppColors.userBubbleLight
                            : isDark
                                ? AppColors.assistantBubbleDark
                                : AppColors.assistantBubbleLight,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(AppSpacing.radiusLg),
                          topRight: const Radius.circular(AppSpacing.radiusLg),
                          bottomLeft: Radius.circular(
                            _isUser ? AppSpacing.radiusLg : AppSpacing.sm,
                          ),
                          bottomRight: Radius.circular(
                            _isUser ? AppSpacing.sm : AppSpacing.radiusLg,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: !_isUser
                            ? Border.all(
                                color: isDark
                                    ? AppColors.dividerDark
                                    : AppColors.divider,
                                width: 0.5,
                              )
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.message.content,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: _isUser
                                  ? Colors.white
                                  : isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            _formatTime(widget.message.timestamp),
                            style: TextStyle(
                              fontSize: 11,
                              color: _isUser
                                  ? Colors.white.withValues(alpha: 0.6)
                                  : isDark
                                      ? AppColors.textTertiaryDark
                                      : AppColors.textTertiaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Action bar
                    if (_showActions)
                      _ActionBar(
                        isUser: _isUser,
                        onCopy: _copyToClipboard,
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (_isUser) const SizedBox(width: AppSpacing.sm),
        ],
      ),
    );
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.message.content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
    setState(() => _showActions = false);
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

/// Assistant avatar with gradient.
class _Avatar extends StatelessWidget {
  final bool isDark;

  const _Avatar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.avatarMd,
      height: AppSpacing.avatarMd,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: const Icon(
        Icons.psychology_rounded,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}

/// Copy/retry action bar below a message.
class _ActionBar extends StatelessWidget {
  final bool isUser;
  final VoidCallback onCopy;

  const _ActionBar({required this.isUser, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionChip(
            icon: Icons.copy_rounded,
            label: 'Copy',
            onTap: onCopy,
          ),
          if (!isUser) ...[
            const SizedBox(width: AppSpacing.xs),
            _ActionChip(
              icon: Icons.refresh_rounded,
              label: 'Retry',
              onTap: () {
                // TODO: Implement retry
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            const SizedBox(width: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// System/error message.
class _SystemMessage extends StatelessWidget {
  final String text;

  const _SystemMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 14, color: AppColors.error),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
