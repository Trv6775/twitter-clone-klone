import 'package:flutter/material.dart';
import 'package:twitter_klone_clone/theme/theme.dart';

class HashtagText extends StatelessWidget {
  final String text;

  const HashtagText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];
    text.split('').forEach((element) {
      if (element.startsWith('#')) {
        textSpans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Pallete.blueColor,
            ),
          ),
        );
      } else if (element.startsWith('www.') || element.startsWith('https://')) {
        textSpans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              fontSize: 18,
              color: Pallete.blueColor,
            ),
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        );
      }
    });
    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}
