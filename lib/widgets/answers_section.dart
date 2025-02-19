import 'package:bot/services/chat_web_service.dart';
import 'package:bot/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnswerSection extends StatefulWidget {
  const AnswerSection({super.key});

  @override
  State<AnswerSection> createState() => _AnswerSectionState();
}

class _AnswerSectionState extends State<AnswerSection> {
  String fullResponse = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnswerChunks();
  }

  void _fetchAnswerChunks() {
    ChatWebService().contentStream.listen((dataChunk) {
      setState(() {
        fullResponse += dataChunk['data'];
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Answer',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Skeletonizer(
          enabled: isLoading,
          child: SingleChildScrollView(
            child: Markdown(
              data: fullResponse.isEmpty ? 'Loading...' : fullResponse,
              shrinkWrap: true,
              styleSheet:
                  MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                codeblockDecoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                code: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
