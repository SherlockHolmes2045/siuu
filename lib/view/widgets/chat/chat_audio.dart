import 'dart:convert';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/controller/dates_controller.dart';
import 'package:flutter_ble_messenger/model/message.dart';
import 'package:flutter_ble_messenger/res/colors.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:path_provider/path_provider.dart';

class ChatAudio extends StatefulWidget {
  final Message message;
  final String deviceUsername;
  final String appUser;

  const ChatAudio({Key key, this.message, this.deviceUsername, this.appUser})
      : super(key: key);

  @override
  _ChatAudioState createState() => _ChatAudioState();
}

class _ChatAudioState extends State<ChatAudio> {
  bool _play = false;
  String path;
  Future<String> saveFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".wav");
   // await file.writeAsBytes(widget.message.message);
    return file.path;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveFile().then((value){
      setState(() {
        path = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double defaultWidth = width * 2 / 3;
    double minValue = 8.0;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Align(
        alignment:
            widget.message.sent ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: widget.message.sent
              ? EdgeInsets.only(right: 0.0, bottom: minValue * 2, left: 200.0)
              : EdgeInsets.only(right: 200.0, bottom: minValue * 2, left: 0.0),
          padding: EdgeInsets.all(minValue),
          decoration: BoxDecoration(
            gradient: widget.message.sent ? greyGradient : linearGradient,
            /*borderRadius: message.sent
                ? BorderRadius.only(
                topLeft: Radius.circular(minValue * 4),
                bottomLeft: Radius.circular(minValue * 4),
                topRight: Radius.circular(minValue * 4))
                : BorderRadius.only(
                bottomLeft: Radius.circular(minValue * 4),
                topRight: Radius.circular(minValue * 4)
            ),*/
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                offset: Offset(10, 10),
                color: Colors.black12,
              ),
            ],
          ),
          constraints: BoxConstraints(maxWidth: defaultWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: widget.message.sent
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  height: 200,
                  width: 350,
                  child: AudioWidget.file(
                      child: RaisedButton(
                          child: Text(
                            _play ? "pause" : "play",
                          ),
                          onPressed: () {
                            setState(() {
                              _play = !_play;
                            });
                          }),
                      path: path)),
              SizedBox(height: 15),
              Text(
                DatesController()
                    .getVerboseDateTimeRepresentation(widget.message.dateTime),
                style: TextStyle(
                  fontSize: 16,
                  color: widget.message.sent
                      ? Colors.grey[300]
                      : Colors.grey.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
