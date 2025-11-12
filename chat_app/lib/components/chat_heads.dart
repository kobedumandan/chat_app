import 'package:flutter/material.dart';

class ChatHead extends StatelessWidget {
  final String text;
  final Color color;
  final void Function()? onTap;
  
  const ChatHead({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Expanded(
        child: Column(
          
        ),
      ),
    );
  }
}