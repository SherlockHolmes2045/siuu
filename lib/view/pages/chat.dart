import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_ble_messenger/controller/devices_controller.dart';
import 'package:flutter_ble_messenger/controller/messages_controller.dart';
import 'package:flutter_ble_messenger/view/widgets/chat/chat_audio.dart';
import 'package:flutter_ble_messenger/view/widgets/chat/chat_bubble.dart';
import 'package:flutter_ble_messenger/view/widgets/chat/chat_image.dart';
import 'package:flutter_ble_messenger/view/widgets/common/show_alert_dialog_box.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class Chat extends StatefulWidget {
  final String deviceId;
  final String deviceUsername;
  final String appUser;

  const Chat({
    Key key,
    this.deviceId,
    this.deviceUsername,
    this.appUser,
  }) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ScrollController _scrollController;
  File compressedFile;
  bool recordMode = false;
  String audioText = "Maintenez pour enregister";
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  final _messageController = TextEditingController();
  File audio;

  @override
  void initState() {
    _init();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.deviceUsername}',
            overflow: TextOverflow.ellipsis,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Flexible(
              child: GetX<MessagesController>(
                init: MessagesController(),
                builder: (controller) {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _scrollToBottom());

                  var conversation = controller.messages
                      .where((device) =>
                          device.fromId == widget.deviceId &&
                              device.toUsername == widget.appUser ||
                          device.toId == widget.deviceId &&
                              device.fromUsername == widget.appUser)
                      .toList();

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: conversation.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (conversation[index].type == "text") {
                        return ChatBubble(
                            message: conversation[index],
                            deviceUsername: widget.deviceUsername,
                            appUser: widget.appUser);
                      } else if (conversation[index].type == "image") {
                        return ChatImage(
                            message: conversation[index],
                            deviceUsername: widget.deviceUsername,
                            appUser: widget.appUser);
                      } else {
                        return ChatAudio(
                            message: conversation[index],
                            deviceUsername: widget.deviceUsername,
                            appUser: widget.appUser);
                      }
                    },
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: _buildTextComposer(context),
            ),
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
    );
  }

  Widget _buildTextComposer(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.text,
                controller: _messageController,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]),
                  ),
                  hintText: 'Send a message',
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 20,
                  ),
                ),
                style: TextStyle(fontSize: 20),
                onEditingComplete: () {
                  onSendButtonPress(
                    controller: _messageController,
                    context: context,
                  );
                },
              ),
            ),
            SizedBox(
              width: 8,
            ),
            GestureDetector(
              onTap: () {
                onSendButtonPress(
                    controller: _messageController,
                    context: context,
                    type: " text");
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
                  child: SvgPicture.asset('assets/svg/icon - send.svg')),
            ),
            GestureDetector(
              onTap: () async {
                File result = await FilePicker.getFile(
                  type: FileType.image,
                );
                print("path " + result.path);
                double sizeInMb = result.lengthSync() / (1024 * 1024);
                if (sizeInMb <= 3) {
                  compressedFile = await FlutterNativeImage.compressImage(
                      result.path,
                      quality: 10);
                  _messageController.text = "image";
                  onSendButtonPress(
                      controller: _messageController,
                      context: context,
                      type: " image");
                }
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
            /*ClipOval(
              child: Material(
                borderRadius: BorderRadius.circular(50),
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).buttonColor.withOpacity(0.4),
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).buttonColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      splashColor: Colors.greenAccent[400],
                      highlightColor: Colors.greenAccent[400],
                      icon: const Icon(
                        Icons.arrow_upward_sharp,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        onSendButtonPress(
                          controller: _messageController,
                          context: context,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  void onSendButtonPress(
      {BuildContext context,
      TextEditingController controller,
      String type}) async {
    if (controller.text.isNotEmpty) {
      var connectionState;
      if (type == " text") {
        connectionState = await DevicesController(context).sendMessage(
          toId: widget.deviceId,
          toUsername: widget.deviceUsername,
          fromUsername: widget.appUser,
          type: "text",
          message: controller.text + " text",
        );
      } else if (type == " image") {
        List<int> imageBytes = compressedFile.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        connectionState = await DevicesController(context).sendMessage(
          toId: widget.deviceId,
          toUsername: widget.deviceUsername,
          fromUsername: widget.appUser,
          type: "image",
          message: base64Image + " image",
        );
      } else if (type == " audio") {
        print("cas audio");
        List<int> audioBytes = audio.readAsBytesSync();
        print(Uint8List.fromList(audioBytes));
        String base64Audio = base64Encode(audioBytes);
        connectionState = await DevicesController(context).sendMessage(
          toId: widget.deviceId,
          toUsername: widget.deviceUsername,
          fromUsername: widget.appUser,
          type: "audio",
          message: base64Audio + " audio",
        );
      }
      if (!connectionState) {
        showAlertDialogBox(
          context: context,
          header: 'Connection Status',
          message:
              'The message is not sent.\n${widget.deviceUsername} is offline at the moment.',
          actionButtons: [
            OutlinedButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }

      controller.clear();
    }
  }

  _init() async {
    try {
      print("dans le try");
      if (await FlutterAudioRecorder.hasPermissions) {
        print("dans le if");
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

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = File(result.path);
    setState(() {
      audio = file;
    });
    _messageController.text = "audio";
    onSendButtonPress(
        controller: _messageController, context: context, type: " audio");
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
      audioText = "Maintenez pour enregister";
      recordMode = false;
    });
  }
}
