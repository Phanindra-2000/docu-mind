import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docu_mind/core/theme/app_colors.dart';
import 'package:docu_mind/core/theme/app_spacing.dart';
import 'package:docu_mind/features/chat/domain/entities/message.dart';
import 'package:docu_mind/features/chat/presentation/providers/chat_provider.dart';
import 'package:docu_mind/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:docu_mind/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:docu_mind/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:docu_mind/features/chat/presentation/widgets/chat_welcome.dart';

/// Full-screen chat page with modern conversational UI.
class ChatPage extends ConsumerStatefulWidget {
  final String? filename;

  const ChatPage({super.key, this.filename});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  bool _showScrollDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final atBottom = _scrollController.offset >=
        _scrollController.position.maxScrollExtent - 100;
    if (_showScrollDown != !atBottom) {
      setState(() => _showScrollDown = !atBottom);
    }
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();
    ref.read(chatProvider.notifier).send(text, filename: widget.filename);
    _textController.clear();

    // Scroll to bottom after a short delay to allow the new message to render.
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);
    final chatNotifier = ref.read(chatProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkGradient : null,
          color: isDark ? null : AppColors.backgroundLight,
        ),
        child: Column(
          children: [
            // ── Custom AppBar ──────────────────────────────
            _ChatAppBar(
              filename: widget.filename,
              statusBarHeight: statusBarHeight,
              onClear: () {
                HapticFeedback.mediumImpact();
                chatNotifier.clear();
              },
              onBack: () => Navigator.of(context).pop(),
            ),

            // ── Messages ──────────────────────────────────
            Expanded(
              child: messages.isEmpty
                  ? const ChatWelcome()
                  : _MessageList(
                      messages: messages,
                      scrollController: _scrollController,
                      isLoading: chatNotifier.isLoading,
                    ),
            ),

            // ── Scroll to bottom button ───────────────────
            if (_showScrollDown)
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: _ScrollToBottomButton(onTap: _scrollToBottom),
                ),
              ),

            // ── Input ─────────────────────────────────────
            ChatInputBar(
              controller: _textController,
              onSend: _sendMessage,
              isSending: chatNotifier.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom chat app bar with back button, title, and actions.
class _ChatAppBar extends StatelessWidget {
  final String? filename;
  final double statusBarHeight;
  final VoidCallback onClear;
  final VoidCallback onBack;

  const _ChatAppBar({
    required this.filename,
    required this.statusBarHeight,
    required this.onClear,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.9)
            : AppColors.surfaceLight.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.dividerDark : AppColors.divider,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: onBack,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Assistant',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      filename != null ? 'Analyzing: $filename' : 'Ready to help',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textTertiaryDark
                            : AppColors.textTertiaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              // Actions
              IconButton(
                icon: const Icon(Icons.delete_sweep_rounded, size: 20),
                onPressed: onClear,
                tooltip: 'Clear chat',
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1);
  }
}

/// Scrollable message list with auto-scroll.
class _MessageList extends StatefulWidget {
  final List<Message> messages;
  final ScrollController scrollController;
  final bool isLoading;

  const _MessageList({
    required this.messages,
    required this.scrollController,
    required this.isLoading,
  });

  @override
  State<_MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<_MessageList> {
  @override
  Widget build(BuildContext context) {
    final itemCount = widget.messages.length + (widget.isLoading ? 1 : 0);

    return ListView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Typing indicator
        if (index == widget.messages.length && widget.isLoading) {
          return const TypingIndicator()
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.2);
        }

        final message = widget.messages[index];
        final showAvatar = index == 0 ||
            widget.messages[index - 1].role != message.role;

        return ChatBubble(
          message: message,
          showAvatar: showAvatar,
        ).animate().fadeIn(
              duration: 300.ms,
              delay: Duration(milliseconds: min(index * 50, 300)),
            ).slideY(begin: 0.1);
      },
    );
  }
}

/// Floating scroll-to-bottom button.
class _ScrollToBottomButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ScrollToBottomButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(0.8, 0.8));
  }
}
