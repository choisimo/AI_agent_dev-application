import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/chat_provider.dart';

class ChatInput extends ConsumerStatefulWidget {
  const ChatInput({super.key});

  @override
  ConsumerState<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<ChatInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    final chatActions = ref.read(chatActionsProvider);
    final currentConversation = ref.read(currentConversationProvider);
    
    chatActions.sendMessage(text.trim(), conversation: currentConversation);
    
    _controller.clear();
    setState(() => _isComposing = false);
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Attachment Button
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: isLoading ? null : () {
              // TODO: Implement file attachment
            },
            tooltip: '파일 첨부',
          ),
          
          // Text Input
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                enabled: !isLoading,
                decoration: InputDecoration(
                  hintText: isLoading ? 'AI가 응답 중입니다...' : '메시지를 입력하세요...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onChanged: (text) {
                  setState(() => _isComposing = text.trim().isNotEmpty);
                },
                onSubmitted: _handleSubmitted,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Send Button
          Container(
            decoration: BoxDecoration(
              color: _isComposing && !isLoading
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
              icon: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.grey[600]!,
                        ),
                      ),
                    )
                  : const Icon(Icons.send),
              color: _isComposing && !isLoading ? Colors.white : Colors.grey[600],
              onPressed: _isComposing && !isLoading
                  ? () => _handleSubmitted(_controller.text)
                  : null,
              tooltip: '전송',
            ),
          ),
        ],
      ),
    );
  }
}
