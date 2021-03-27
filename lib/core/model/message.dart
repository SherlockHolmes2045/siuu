import 'package:flutter/material.dart';

class Message {
  //Message content
  String message;
  //User who sent message, 0-current user, 1-other user
  int user;
  String name;
  bool isBold;
  String ip;
  String type;
  int time;

  Message({
    @required this.message,
    this.user,
    this.name,
    this.isBold = false,
    this.ip,
    this.type,
    this.time
  });

  Map<String, dynamic> toMap() {
    return {
      'user' : user,
      'name' : name,
      'isBold': isBold,
      'ip' : ip,
      'message': message,
      'type' : type,
      'time' : time
    };
  }

  Message.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    name = json['name'];
    ip = json['ip'];
    type = json['type'];
    isBold = json['isBold'];
    time = json['time'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['name'] = this.name;
    data['ip'] = this.ip;
    data['type'] = this.type;
    data['time'] = this.time;
    data['isBold'] = this.isBold;
    data['user'] = this.user;
    return data;
  }
}
