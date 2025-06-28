import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/chat_provider.dart';
import 'message_bubble.dart';
import 'chat_input.dart';

class ChatView extends ConsumerWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentConversation = ref.watch(currentConversationProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Column(
      children: [
        // Messages
        Expanded(
          child: currentConversation == null
              ? _buildWelcomeScreen(context)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: currentConversation.messages.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == currentConversation.messages.length && isLoading) {
                      return const MessageBubble.loading();
                    }
                    
                    final message = currentConversation.messages[index];
                    return MessageBubble(message: message);
                  },
                ),
        ),
        
        // Input
        const ChatInput(),
      ],
    );
  }

  Widget _buildWelcomeScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.auto_awesome,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Gemini Dev Agent에 오신 것을 환영합니다!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Flutter 앱 개발을 도와드릴 준비가 되었습니다.\n무엇을 만들어볼까요?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildSuggestionChip(
                context,
                '로그인 화면 만들어줘',
                Icons.login,
              ),
              _buildSuggestionChip(
                context,
                '상품 목록 페이지 만들어줘',
                Icons.shopping_cart,
              ),
              _buildSuggestionChip(
                context,
                'Firebase 연동 방법 알려줘',
                Icons.cloud,
              ),
              _buildSuggestionChip(
                context,
                '이 코드 분석해줘',
                Icons.code,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(BuildContext context, String text, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(text),
      onPressed: () {
        // TODO: Implement suggestion tap
      },
    );
  }
}
