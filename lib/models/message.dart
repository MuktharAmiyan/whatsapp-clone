// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:whatsapp_ui/common/enums/message_enum.dart';

class Message {
  final String senderId;
  final String reviverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String replaiedMessage;
  final String repliedTo;
  final MessageEnum replayMessageType;
  Message({
    required this.senderId,
    required this.reviverId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.replaiedMessage,
    required this.repliedTo,
    required this.replayMessageType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'reviverId': reviverId,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'replaiedMessage': replaiedMessage,
      'repliedTo': repliedTo,
      'replayMessageType': replayMessageType.type,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      reviverId: map['reviverId'] as String,
      text: map['text'] as String,
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
      replaiedMessage: map['replaiedMessage'] as String,
      repliedTo: map['repliedTo'] as String,
      replayMessageType: (map['replayMessageType'] as String).toEnum(),
    );
  }
}
