import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final int maxTextLength;
  final bool showAllText;
  final VoidCallback? onSuffixPressed;
  final Function(String)? onUserTagPressed;

  CustomText({
    Key? key,
    required this.text,
    this.fontSize = 14,
    this.textColor = Colors.black,
    this.maxTextLength = 300,
    this.showAllText = false,
    this.onSuffixPressed,
    this.onUserTagPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: _buildStyledText(),
    );
  }

  TextSpan _buildStyledText() {
    final List<TextSpan> spans = [];
    final mentionRegex = RegExp(r'(@\w+)');
    final hashtagRegex = RegExp(r'(#\w+)');

    // スペースも含めてキャプチャするために正規表現を利用
    final matches = RegExp(r'(@\w+|\#\w+|\s+|[^@\#\s]+)').allMatches(text);

    int currentLength = 0;

    for (var match in matches) {
      final word = match.group(0)!; // マッチした単語

      if (!showAllText && currentLength >= maxTextLength) {
        spans.add(
          TextSpan(
            text: "... もっと見る",
            style: const TextStyle(color: Colors.pink),
            recognizer: TapGestureRecognizer()..onTap = onSuffixPressed,
          ),
        );
        break;
      }

      if (mentionRegex.hasMatch(word)) {
        spans.add(
          TextSpan(
            text: word, // メンション
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                onUserTagPressed?.call(word);
              },
          ),
        );
      } else if (hashtagRegex.hasMatch(word)) {
        spans.add(
          TextSpan(
            text: word, // ハッシュタグ
            style: const TextStyle(color: Colors.green),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: word, // 通常テキストやスペース
            style: TextStyle(color: textColor),
          ),
        );
      }

      currentLength += word.length;
    }

    return TextSpan(children: spans);
  }
}
