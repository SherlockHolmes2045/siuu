import 'dart:typed_data';

class Message {
  final bool sent;
  final String toId;
  final String toUsername;
  final String fromId;
  final String fromUsername;
  final Uint8List message;
  final DateTime dateTime;
  String type;

  Message(
      {this.sent,
      this.toId,
      this.toUsername,
      this.fromId,
      this.fromUsername,
      this.message,
      this.dateTime,
        this.type
      });
}
