import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

class CodeEditorPanel extends ConsumerStatefulWidget {
  const CodeEditorPanel({super.key});

  @override
  ConsumerState<CodeEditorPanel> createState() => _CodeEditorPanelState();
}

class _CodeEditorPanelState extends ConsumerState<CodeEditorPanel> {
  final _controller = TextEditingController();
  String _selectedLanguage = 'dart';
  
  final List<String> _languages = [
    'dart',
    'javascript',
    'typescript',
    'python',
    'java',
    'kotlin',
    'swift',
    'html',
    'css',
    'json',
    'yaml',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          left: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.code, size: 20),
                const SizedBox(width: 8),
                const Text(
                  '코드 에디터',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: _selectedLanguage,
                  underline: const SizedBox.shrink(),
                  items: _languages.map((language) {
                    return DropdownMenuItem(
                      value: language,
                      child: Text(language.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedLanguage = value);
                    }
                  },
                ),
              ],
            ),
          ),
          
          // Editor
          Expanded(
            child: Stack(
              children: [
                // Code Input
                TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    hintText: '코드를 입력하거나 붙여넣으세요...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
                
                // Syntax Highlighting Overlay (if needed)
                if (_controller.text.isNotEmpty)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: HighlightView(
                          _controller.text,
                          language: _selectedLanguage,
                          theme: githubTheme,
                          padding: EdgeInsets.zero,
                          textStyle: const TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 14,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement code analysis
                    },
                    icon: const Icon(Icons.analytics),
                    label: const Text('분석'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement code execution/preview
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('실행'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
