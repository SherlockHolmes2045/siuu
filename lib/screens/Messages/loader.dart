import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'chat.dart';

class Loader extends StatefulWidget {
  final bool isRoomTalk;
  final String name;
  Loader({this.name, this.isRoomTalk});
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(milliseconds: 5000),
      () => Navigator.of(context).pushNamed(
        '/chat',
        arguments: Chat(
          name: widget.name,
          isRoomTalk: widget.isRoomTalk,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Color(0xffFD0767),
          size: 100,
          // size: 100,
          // itemCount: 7,
        ),
      ),
    );
  }
}
