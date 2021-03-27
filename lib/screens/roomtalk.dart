import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file/local.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ble_messenger/ImageWidget.dart';
import 'package:flutter_ble_messenger/core/model/tcpData.dart';
import 'package:flutter_ble_messenger/core/viewmodel/server_vm.dart';
import 'package:flutter_ble_messenger/custom/customAppBars/appBar3.dart';
import 'package:flutter_ble_messenger/utils/margin.dart';
import '../messageWidget.dart';

class RoomTalk extends StatefulWidget {
  final TCPData tcpData;
  final bool isHost;

  const RoomTalk({Key key, @required this.tcpData, this.isHost = false})
      : super(key: key);
  @override
  _RoomTalkState createState() => _RoomTalkState();
}

class _RoomTalkState extends State<RoomTalk> {
  ServerViewModel serverProvider;
  String audioText = "Maintenez pour enregister";
  bool recordMode = false;
  LocalFileSystem localFileSystem = LocalFileSystem();
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
        audioText = "Enregistre...";
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = localFileSystem.file(result.path);
    final audio = File(result.path).readAsBytesSync();
    String audioStr = base64.encode(audio);
    serverProvider.sendMessage(
      context,
      widget?.tcpData,
      "audio",
      isHost: widget.isHost,
      messages: audioStr,
    );
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
      audioText = "Maintenez pour enregister";
      recordMode = false;
    });
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  void dispose() {
    if (widget.isHost) serverProvider.server.close();
    serverProvider.closeSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    serverProvider = context.watch<ServerViewModel>();
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    print(widget.isHost);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/messages');
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(width, height * 0.1755),
          child: AppBar3(
            title: "Room talk",
          ),
        ),
        body: Container(
          width: screenWidth(context),
          height: screenHeight(context),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  reverse: true,
                  children: <Widget>[
                    for (var messageItem in serverProvider.messageList)
                      messageItem.type == "text"
                          ? MessageWidget(message: messageItem)
                          : ImageWidget(message: messageItem),
                  ],
                ),
              ),
              const YMargin(20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.grey[400].withOpacity(0.1),
                      offset: Offset(0, 13),
                      blurRadius: 30)
                ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const XMargin(20),
                    Expanded(
                      //width: screenWidth(context, percent: 0.43),
                      child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            border: InputBorder.none,
                            hintText: "Hey...",
                            hintStyle: TextStyle(
                              fontFamily: "Segoe UI",
                              fontSize: 15,
                              color: Color(0xff4d0cbb),
                            ),
                          ),
                          style:
                              TextStyle(color: Color(0xff4d0cbb), fontSize: 15.0),
                          controller: serverProvider.msg,
                          autofocus: false),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        File result = await FilePicker.getFile(
                          type: FileType.image,
                        );
                        double sizeInMb = result.lengthSync() / (1024 * 1024);
                        if(sizeInMb <= 3) {
                          result = await FlutterNativeImage.compressImage(result.path,
                              quality: 10);
                        }
                        final image = File(result.path).readAsBytesSync();
                        String imageStr = base64Encode(image);
                        serverProvider.sendMessage(context, widget?.tcpData,"image",
                            isHost: widget.isHost, messages: imageStr);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight),
                            borderRadius: BorderRadius.circular(40)),
                        padding: EdgeInsets.all(12),
                        child: SvgPicture.asset('assets/svg/Camera2.svg'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          recordMode = true;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight),
                            borderRadius: BorderRadius.circular(40)),
                        padding: EdgeInsets.all(12),
                        child: SvgPicture.asset('assets/svg/Voice.svg'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (serverProvider.msg.text != null &&
                            serverProvider.msg.text.isNotEmpty &&
                            widget.tcpData != null)
                          serverProvider.sendMessage(
                            context,
                            widget?.tcpData,
                            "text",
                            isHost: widget.isHost,
                          );
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight),
                            borderRadius: BorderRadius.circular(40)),
                        padding: EdgeInsets.all(12),
                        child: SvgPicture.asset('assets/svg/icon - send.svg'),
                      ),
                    ),
                  ],
                ),
              ),
              const YMargin(30),
              recordMode
                  ? GestureDetector(
                      onLongPress: () {
                        _start();
                      },
                      onLongPressEnd: (longPressEndDetails) {
                        _stop();
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height / 20),
                            child: Text(
                              audioText,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          Container(
                              alignment: Alignment.bottomCenter,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 7,
                              child: Container(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  radius: 35.0,
                                  child: Icon(
                                    Icons.mic,
                                    size: 30.0,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
