import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/screens/auth_screen.dart';
import '../features/chat/presentation/screens/main_screen.dart';
import '../features/auth/providers/auth_provider.dart';
import 'theme/app_theme.dart';

class GeminiDevAgentApp extends ConsumerWidget {
  const GeminiDevAgentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return MaterialApp(
      title: 'Gemini Dev Agent',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: authState.when(
        data: (user) => user != null ? const MainScreen() : const AuthScreen(),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => const AuthScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
