import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

import '../../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  const MessageBubble.loading({super.key}) : message = const MessageModel(
    id: 'loading',
    content: '',
    type: MessageType.assistant,
    timestamp: null,
  ) as MessageModel;

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;
    final isLoading = message.id == 'loading';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: _getAvatarColor(context),
              child: Icon(
                _getAvatarIcon(),
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
          ],
          
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getBubbleColor(context, isUser),
                borderRadius: BorderRadius.circular(16).copyWith(
                  topLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  topRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isLoading
                  ? _buildLoadingContent()
                  : _buildMessageContent(context),
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '생각 중...',
          style: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    if (message.type == MessageType.code) {
      return _buildCodeContent(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MarkdownBody(
          data: message.content,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              color: message.type == MessageType.user ? Colors.white : Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
            code: TextStyle(
              backgroundColor: Colors.grey[100],
              fontFamily: 'JetBrainsMono',
              fontSize: 13,
            ),
            codeblockDecoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
          ),
          builders: {
            'code': CodeElementBuilder(),
          },
        ),
        
        if (message.type != MessageType.user) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTimestamp(message.timestamp),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: message.content));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('메시지가 복사되었습니다'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Icon(
                  Icons.copy,
                  size: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCodeContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.code,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              message.codeLanguage ?? 'Code',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.copy, size: 16),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: message.content));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('코드가 복사되었습니다'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: HighlightView(
            message.content,
            language: message.codeLanguage ?? 'dart',
            theme: githubTheme,
            padding: EdgeInsets.zero,
            textStyle: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Color _getBubbleColor(BuildContext context, bool isUser) {
    if (isUser) {
      return Theme.of(context).primaryColor;
    }
    
    switch (message.type) {
      case MessageType.error:
        return Colors.red[50]!;
      case MessageType.code:
        return Colors.blue[50]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Color _getAvatarColor(BuildContext context) {
    switch (message.type) {
      case MessageType.assistant:
        return Theme.of(context).primaryColor;
      case MessageType.system:
        return Colors.orange;
      case MessageType.error:
        return Colors.red;
      case MessageType.code:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getAvatarIcon() {
    switch (message.type) {
      case MessageType.assistant:
        return Icons.auto_awesome;
      case MessageType.system:
        return Icons.settings;
      case MessageType.error:
        return Icons.error;
      case MessageType.code:
        return Icons.code;
      default:
        return Icons.help;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}시간 전';
    } else {
      return '${timestamp.month}/${timestamp.day} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final String language = element.attributes['class']?.replaceFirst('language-', '') ?? 'dart';
    final String code = element.textContent;
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: HighlightView(
        code,
        language: language,
        theme: githubTheme,
        padding: const EdgeInsets.all(12),
        textStyle: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 13,
        ),
      ),
    );
  }
}
