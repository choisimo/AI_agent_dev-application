import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/chat_sidebar.dart';
import '../widgets/chat_view.dart';
import '../widgets/code_editor_panel.dart';
import '../widgets/preview_panel.dart';
import '../../providers/chat_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  bool _showCodeEditor = false;
  bool _showPreview = false;

  @override
  Widget build(BuildContext context) {
    final currentConversation = ref.watch(currentConversationProvider);
    
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          const SizedBox(
            width: 280,
            child: ChatSidebar(),
          ),
          
          // Main Chat Area
          Expanded(
            flex: _showCodeEditor || _showPreview ? 1 : 2,
            child: Column(
              children: [
                // App Bar
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Text(
                        currentConversation?.title ?? 'Gemini Dev Agent',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.code,
                          color: _showCodeEditor 
                              ? Theme.of(context).primaryColor 
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _showCodeEditor = !_showCodeEditor;
                          });
                        },
                        tooltip: '코드 에디터',
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.preview,
                          color: _showPreview 
                              ? Theme.of(context).primaryColor 
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPreview = !_showPreview;
                          });
                        },
                        tooltip: '미리보기',
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                
                // Chat View
                const Expanded(
                  child: ChatView(),
                ),
              ],
            ),
          ),
          
          // Code Editor Panel
          if (_showCodeEditor)
            const SizedBox(
              width: 400,
              child: CodeEditorPanel(),
            ),
          
          // Preview Panel
          if (_showPreview)
            const SizedBox(
              width: 350,
              child: PreviewPanel(),
            ),
        ],
      ),
    );
  }
}
