import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/message_model.dart';
import '../models/conversation_model.dart';
import '../services/gemini_service.dart';
import '../../gemini_cli/services/remote_gemini_service.dart';

const String _geminiApiKey = 'YOUR_GEMINI_API_KEY'; // Replace with actual API key

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService(apiKey: _geminiApiKey);
});

final remoteGeminiServiceProvider = Provider<RemoteGeminiService>((ref) {
  return RemoteGeminiService();
});

final conversationsProvider = StateNotifierProvider<ConversationsNotifier, List<ConversationModel>>((ref) {
  return ConversationsNotifier();
});

final currentConversationProvider = StateProvider<ConversationModel?>((ref) => null);

final isLoadingProvider = StateProvider<bool>((ref) => false);

class ConversationsNotifier extends StateNotifier<List<ConversationModel>> {
  ConversationsNotifier() : super([]);

  void addConversation(ConversationModel conversation) {
    state = [conversation, ...state];
  }

  void updateConversation(ConversationModel updatedConversation) {
    state = state.map((conversation) {
      return conversation.id == updatedConversation.id
          ? updatedConversation
          : conversation;
    }).toList();
  }

  void deleteConversation(String conversationId) {
    state = state.where((conversation) => conversation.id != conversationId).toList();
  }

  ConversationModel? getConversation(String id) {
    try {
      return state.firstWhere((conversation) => conversation.id == id);
    } catch (e) {
      return null;
    }
  }
}

final chatActionsProvider = Provider<ChatActions>((ref) {
  return ChatActions(ref);
});

class ChatActions {
  final Ref _ref;
  const ChatActions(this._ref);

  Future<void> sendMessage(String content, {ConversationModel? conversation}) async {
    final geminiService = _ref.read(geminiServiceProvider);
    final conversationsNotifier = _ref.read(conversationsProvider.notifier);
    
    _ref.read(isLoadingProvider.notifier).state = true;

    try {
      // Create or get conversation
      ConversationModel currentConversation;
      if (conversation == null) {
        currentConversation = ConversationModel(
          id: const Uuid().v4(),
          title: _generateTitle(content),
          messages: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        conversationsNotifier.addConversation(currentConversation);
        _ref.read(currentConversationProvider.notifier).state = currentConversation;
      } else {
        currentConversation = conversation;
      }

      // Add user message
      final userMessage = MessageModel(
        id: const Uuid().v4(),
        content: content,
        type: MessageType.user,
        timestamp: DateTime.now(),
      );

      final updatedMessages = [...currentConversation.messages, userMessage];
      currentConversation = currentConversation.copyWith(
        messages: updatedMessages,
        updatedAt: DateTime.now(),
      );
      
      conversationsNotifier.updateConversation(currentConversation);
      _ref.read(currentConversationProvider.notifier).state = currentConversation;

      // Generate AI response
      final String response;

      // Check for keywords to trigger remote analysis
      if (content.contains('코드 분석') || content.contains('프로젝트 분석') || content.contains('SWE')) {
        final remoteGeminiService = _ref.read(remoteGeminiServiceProvider);
        // TODO: Make the remote project path configurable through the UI or settings.
        const remotePath = '/path/to/remote/project';
        response = await remoteGeminiService.analyzeCodebase(remotePath);
      } else {
        // Use local Gemini API for other requests
        response = await geminiService.generateResponse(
          prompt: content,
          conversationHistory: currentConversation.messages,
        );
      }

      // Add AI message
      final aiMessage = MessageModel(
        id: const Uuid().v4(),
        content: response,
        type: MessageType.assistant,
        timestamp: DateTime.now(),
      );

      final finalMessages = [...updatedMessages, aiMessage];
      currentConversation = currentConversation.copyWith(
        messages: finalMessages,
        updatedAt: DateTime.now(),
      );

      conversationsNotifier.updateConversation(currentConversation);
      _ref.read(currentConversationProvider.notifier).state = currentConversation;

    } catch (e) {
      // Add error message
      final errorMessage = MessageModel(
        id: const Uuid().v4(),
        content: '오류가 발생했습니다: $e',
        type: MessageType.error,
        timestamp: DateTime.now(),
      );

      if (conversation != null) {
        final updatedMessages = [...conversation.messages, errorMessage];
        final updatedConversation = conversation.copyWith(
          messages: updatedMessages,
          updatedAt: DateTime.now(),
        );
        conversationsNotifier.updateConversation(updatedConversation);
      }
    } finally {
      _ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  String _generateTitle(String content) {
    if (content.length <= 30) return content;
    return '${content.substring(0, 30)}...';
  }
}
