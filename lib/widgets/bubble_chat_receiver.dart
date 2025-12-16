import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildMessageBubbleReceiver({
  required String messageText,
  bool isSender = false,
  required bool showTail,
}) {
  final bubbleColor = Color(0xFF5E35B1),
      textStyle = TextStyle(
        color: Colors.white,
        fontSize: 16,
      );

  return BubbleSpecialThree(
    text: messageText,
    color: bubbleColor,
    tail: showTail,
    textStyle: textStyle,
    isSender: false,
  );
}
