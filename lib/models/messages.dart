import 'package:chat_app/constants.dart';

class Message {
  final String content;
  final String id;

  Message({
    required this.content,
    required this.id,
  });

  factory Message.fromJson(
    Map<String, dynamic> json,
  ) {
    return Message(
      content: json[kMessageText] as String,
      id: json[kId] as String,
    );
  }
}
