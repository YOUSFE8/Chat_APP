import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildMessageBubbleSender({
  required String messageText,
  bool isSender = true,
  required bool showTail,
}) {
  final bubbleColor = Color(0xFF9575CD),
      textStyle = TextStyle(
        color: Colors.white,
        fontSize: 16,
      );

  return BubbleSpecialThree(
    text: messageText,
    color: bubbleColor,
    tail: showTail,
    isSender: isSender,
    textStyle: textStyle,
  );
}
