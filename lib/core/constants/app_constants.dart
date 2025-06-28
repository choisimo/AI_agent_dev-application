class AppConstants {
  // App Info
  static const String appName = 'Gemini Dev Agent';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI-powered Flutter development assistant';

  // API
  static const String geminiApiVersion = 'v1beta';
  static const String geminiApiBaseUrl = 'https://generativelanguage.googleapis.com/$geminiApiVersion';
  
  // Storage Keys
  static const String userBoxKey = 'user_box';
  static const String conversationsBoxKey = 'conversations_box';
  static const String projectsBoxKey = 'projects_box';
  static const String settingsBoxKey = 'settings_box';

  // File Extensions
  static const List<String> codeFileExtensions = [
    '.dart',
    '.js',
    '.ts',
    '.py',
    '.java',
    '.kt',
    '.swift',
    '.html',
    '.css',
    '.json',
    '.yaml',
    '.yml',
  ];

  // Supported Languages
  static const Map<String, String> supportedLanguages = {
    'dart': 'Dart',
    'javascript': 'JavaScript',
    'typescript': 'TypeScript',
    'python': 'Python',
    'java': 'Java',
    'kotlin': 'Kotlin',
    'swift': 'Swift',
    'html': 'HTML',
    'css': 'CSS',
    'json': 'JSON',
    'yaml': 'YAML',
  };

  // Default Code Templates
  static const String defaultDartCode = '''
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: const Center(
        child: Text('Hello, World!'),
      ),
    );
  }
}
''';

  // Error Messages
  static const String networkErrorMessage = '네트워크 연결을 확인해주세요.';
  static const String unknownErrorMessage = '알 수 없는 오류가 발생했습니다.';
  static const String authErrorMessage = '인증에 실패했습니다.';
  static const String fileErrorMessage = '파일 처리 중 오류가 발생했습니다.';

  // Success Messages
  static const String saveSuccessMessage = '성공적으로 저장되었습니다.';
  static const String deleteSuccessMessage = '성공적으로 삭제되었습니다.';
  static const String updateSuccessMessage = '성공적으로 업데이트되었습니다.';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxMessageLength = 4000;
  static const int maxProjectNameLength = 50;
  static const int maxConversationTitleLength = 100;

  // UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);
  static const Duration longTimeout = Duration(minutes: 2);
}
