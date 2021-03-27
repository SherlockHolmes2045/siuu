import 'package:flutter_ble_messenger/utils/message_type.dart';

class Discussion{
  final bool sendBy;
  final String message;
  final int time;
  final String type;
  final String path;
  final bool byte;
  final String chatId;

  Discussion(this.sendBy,this.message,this.time,this.type,this.path,this.byte,this.chatId);


  Map<String, dynamic> toMap() {
    return {
      'sendBy': sendBy,
      'message': message,
      'time' : time,
      'type' : type,
      'path' : path,
      'byte' : byte,
      'chatId': chatId
    };
  }

  Discussion.fromJson(Map<String, dynamic> json)
      : chatId = json['chatId'],
        sendBy = json['sendBy'],
        message = json['message'],
        type = json['type'],
        path = json['path'],
        time = json['time'],
        byte = json['byte'];

}