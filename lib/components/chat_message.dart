import 'package:flutter/cupertino.dart';

class ChatMessage {
  String author;
  String messageContent;
  String messageType;
  // DateTime time;
  ChatMessage(
      {required this.author,
        required this.messageContent,
        required this.messageType,
        // required this.time
      });
}
