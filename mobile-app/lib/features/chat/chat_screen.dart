import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: Color(0xFFE8F7EC),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                color: Color(0xFF19A55A),
                size: 42,
              ),
            ),
            SizedBox(height: 18),
            Text(
              'Chat will update soon.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
