import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_ble_messenger/custom/audio.dart';
import 'package:flutter_ble_messenger/custom/customAppBars/appBar3.dart';
import 'package:flutter_ble_messenger/database/discussion_dao.dart';
import 'package:flutter_ble_messenger/model/discussion.dart';
import 'package:flutter_ble_messenger/res/colors.dart';
import 'package:flutter_ble_messenger/utils/message_type.dart';
import 'dart:io' as Io;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_image/flutter_native_image.dart';


class Chat extends StatefulWidget {
  final String name;
  final String chatId;
  final String bleAddress;
  final LocalFileSystem localFileSystem;

  Chat({this.name,this.chatId,this.bleAddress})
      :
        this.localFileSystem = LocalFileSystem();

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  String audioText = "Maintenez pour enregister";
  BluetoothConnection connection;
  bool recordMode = false;
  List<Map<String, dynamic>> chats = new List<Map<String, dynamic>>();
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;


  static const platform = const MethodChannel('samples.flutter.dev/battery');
  static const _channel_message =
      const EventChannel('com.sherlock2045.eventchannel/messages');

  TextEditingController messageEditingController = new TextEditingController();

  Widget chatMessages(BuildContext context) {
    return chats.isNotEmpty
        ? Container(
            height: MediaQuery.of(context).size.height / 1.42,
            child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Text(
                        DateFormat('dd MMM kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                chats[index]["time"])),
                        style: TextStyle(
                          fontFamily: "Segoe UI",
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Color(0xff5b055e),
                        ),
                      ),
                      chats[index]["type"] == Status.TEXT
                          ? MessageTile(
                              message: chats[index]["message"],
                              sendByMe: chats[index]["sendBy"],
                            )
                          : chats[index]["type"] == Status.IMAGE
                              ? ImageTile(
                                  path: chats[index]["path"],
                                  sendByMe: chats[index]["sendBy"],
                                  byte: chats[index]["byte"],
                                )
                              : AudioTile(path: chats[index]["path"],sendByMe:chats[index]["sendBy"],byte: chats[index]["byte"],)
                    ],
                  );
                }),
          )
        : Container();
  }

  Widget appBarMain(BuildContext context) {
    return AppBar(
      title: Text(widget.name),
      elevation: 0.0,
      centerTitle: true,
      backgroundColor: Color(0xff5b055e),
    );
  }


  addMessage(Status status, {String path = ""}) async {
    DiscussionDao discussionDao = new DiscussionDao();
    if (Status.TEXT == status) {
      if (messageEditingController.text.isNotEmpty) {
        Map<String, dynamic> chatMessageMap = {
          "sendBy": true,
          "message": messageEditingController.text,
          'time': DateTime.now().millisecondsSinceEpoch,
          'type': status,
          'path': path,
          'byte': false
        };
        await platform.invokeMethod("sendMessage", {"message": messageEditingController.text, "type": "text"});
        setState(() {
          chats.add(chatMessageMap);
          discussionDao.insert(Discussion(chatMessageMap['sendBy'],chatMessageMap['message'],chatMessageMap['time'],"text",chatMessageMap['path'],chatMessageMap['byte'],widget.chatId));
          messageEditingController.text = "";
        });
      }
    } else if (Status.IMAGE == status) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": true,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
        'type': status,
        'path': path,
        'byte': false
      };
      final image = Io.File(path).readAsBytesSync();
      send(image);
      String imageStr = base64.encode(image);
      print(imageStr);
      /*await platform
          .invokeMethod("sendMessage", {"message": imageStr, "type": "image"});*/
      setState(() {
        chats.add(chatMessageMap);
        discussionDao.insert(Discussion(chatMessageMap['sendBy'],chatMessageMap['message'],chatMessageMap['time'],"image",chatMessageMap['path'],chatMessageMap['byte'],widget.chatId));
        messageEditingController.text = "";
      });
    }else if (Status.AUDIO == status){
      Map<String, dynamic> chatMessageMap = {
        "sendBy": true,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
        'type': status,
        'path': path,
        'byte': false
      };
      setState(() {
        chats.add(chatMessageMap);
        discussionDao.insert(Discussion(chatMessageMap['sendBy'],chatMessageMap['message'],chatMessageMap['time'],"image",chatMessageMap['path'],chatMessageMap['byte'],widget.chatId));
        messageEditingController.text = "";
      });
    }
  }

  pushReceivedMessage(String message, String type) {
    DiscussionDao discussionDao = new DiscussionDao();
    switch (type) {
      case "image":
        {
          Map<String, dynamic> chatMessageMap = {
            "sendBy": false,
            "message": message,
            "time": DateTime.now().millisecondsSinceEpoch,
            "type": Status.IMAGE,
            "path": message,
            "byte": true
          };
          setState(() {
            chats.add(chatMessageMap);
            discussionDao.insert(Discussion(chatMessageMap['sendBy'],chatMessageMap['message'],chatMessageMap['time'],"image",chatMessageMap['path'],chatMessageMap['byte'],widget.chatId));
          });
        }
        break;
      case "text":
        {
          Map<String, dynamic> chatMessageMap = {
            "sendBy": false,
            "message": message,
            'time': DateTime.now().millisecondsSinceEpoch,
            'type': Status.TEXT,
            'path': null,
            'byte': false
          };
          setState(() {
            chats.add(chatMessageMap);
            discussionDao.insert(Discussion(chatMessageMap['sendBy'],chatMessageMap['message'],chatMessageMap['time'],"text",chatMessageMap['path'],chatMessageMap['byte'],widget.chatId));
          });
        }
        break;
    }
  }

  getMessages() async{

    DiscussionDao discussionDao = new DiscussionDao();
    List<Discussion> messages = List<Discussion>();
    discussionDao.getAll(widget.chatId).then((value){
      messages = value;
      List<Map<String, dynamic>> savedChats = new List<Map<String, dynamic>>();

      messages.forEach((element) {
        switch (element.type) {
          case "image":
            {
              Map<String, dynamic> chatMessageMap = {
                "sendBy": element.sendBy,
                "message": element.message,
                "time": element.time,
                "type": Status.IMAGE,
                "path": element.path,
                "byte": element.byte
              };
              savedChats.add(chatMessageMap);
            }
            break;
          case "text":
            {
              Map<String, dynamic> chatMessageMap = {
                "sendBy": element.sendBy,
                "message": element.message,
                "time": element.time,
                "type": Status.TEXT,
                "path": element.path,
                "byte": element.byte
              };
              savedChats.add(chatMessageMap);
            }
            break;
        }
      });
      setState(() {
        print("chargement des anciens messages");
        chats = savedChats;
      });
    });
  }

  Future send(Uint8List data) async {
    connection.output.add(data);
    await connection.output.allSent;
  }
  initBluetooth() async{
    try {
      connection = await BluetoothConnection.toAddress(widget.bleAddress);
      print('Connected to the device');

      connection.input.listen((Uint8List data) {
        print('Data incoming: ${ascii.decode(data)}');
        pushReceivedMessage(base64.encode(data), "image");

      }).onDone(() {
        print('Disconnected by remote request');
      });
    }
    catch (exception) {
      print('Cannot connect, exception occured ' + exception.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    print("bleaddress " + widget.bleAddress);
    _init();
    getMessages();
    initBluetooth();
    _enableTimer();
  }

  @override
  void dispose() {
    _disableTimer();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    /*chats.add({
      "sendBy": true,
      "message": "Lorem ipsum",
      "time": DateTime.now().millisecondsSinceEpoch,
    });
    chats.add({
      "sendBy": true,
      "message": "Lorem ipsum",
      "time": DateTime.now().millisecondsSinceEpoch,
    });*/

    /*print(base64.encode(Io.File("/storage/emulated/0/Pictures/Wallpaper/wallpaper_06.jpg").readAsBytesSync()));
    String foo = b64.split('.')[0];*/
    /*chats.add({
      "sendBy": false,
      "message": "/storage/emulated/0/1.jpg",
      "time": DateTime.now().millisecondsSinceEpoch,
      "type": Status.IMAGE,
      "byte": false,
      "path": "/storage/emulated/0/1.jpg",
    });*/
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.1755),
        child: AppBar3(
          title: widget.name,
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(context),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    height: height * 0.075,
                    width: width * 0.902,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: width * 0.002,
                        color: Color(0xff5b055e),
                      ),
                      borderRadius: BorderRadius.circular(26.00),
                    ),
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                                style: TextStyle(
                                  fontFamily: "Segoe UI",
                                  fontSize: 15,
                                  color: Color(0xff4d0cbb),
                                ),
                                controller: messageEditingController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20),
                                  border: InputBorder.none,
                                  hintText: "Hey…",
                                  hintStyle: TextStyle(
                                    fontFamily: "Segoe UI",
                                    fontSize: 15,
                                    color: Color(0xff4d0cbb),
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              addMessage(Status.TEXT);
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
                                child:
                                    SvgPicture.asset('assets/svg/icon - send.svg')),
                          ),
                          GestureDetector(
                            onTap: () async {

                              Io.File result =
                                  await FilePicker.getFile(type: FileType.image,);
                              print("path " + result.path);
                              double sizeInMb = result.lengthSync() / (1024 * 1024);
                              if(sizeInMb <= 1){
                                Io.File compressedFile = await FlutterNativeImage.compressImage(result.path,
                                    quality: 5);
                                addMessage(Status.IMAGE, path: compressedFile.path);
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
                            onTap: ()  {
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
                        ],
                      ),
                    ),
                  ),
                ),
                recordMode ? GestureDetector(
                  onLongPress: (){
                    _start();
                  },
                  onLongPressEnd: (longPressEndDetails){
                    _stop();
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/20),
                        child: Text(
                          audioText,
                          style: TextStyle(
                            fontSize: 20.0
                          ),
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
                        )
                      ),
                    ],
                  ),
                ) : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        Io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (Io.Platform.isIOS) {
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
    File file = widget.localFileSystem.file(result.path);
    addMessage(Status.AUDIO,path: result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
      audioText = "Maintenez pour enregister";
      recordMode = false;
    });
  }

  StreamSubscription _timerSubscription;

  void _enableTimer() {
    if (_timerSubscription == null) {
      _timerSubscription =
          _channel_message.receiveBroadcastStream().listen(_updateTimer);
    }
  }

  Text buildTimeText(String time) {
    return Text(
      time,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontWeight: FontWeight.w300,
        fontSize: 14,
        color: Color(0xff5b055e),
      ),
    );
  }

  void _disableTimer() {
    if (_timerSubscription != null) {
      _timerSubscription.cancel();
      _timerSubscription = null;
    }
  }

  void _updateTimer(timer) {
    debugPrint("Timer $timer");
    var dispatch = timer.split(" ");
    //print(timer.substring(0, timer.lastIndexOf(" ")));
    pushReceivedMessage(timer.substring(0, timer.lastIndexOf(" ")), dispatch[dispatch.length - 1]);
  }
}
class AudioTile extends StatefulWidget {
  final String path;
  final bool byte;
  final bool sendByMe;

  AudioTile(
  {@required this.path,@required this.byte,@required this.sendByMe}
  );

  @override
  _AudioTileState createState()  => _AudioTileState();

}

class _AudioTileState extends State<AudioTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: widget.sendByMe ? 0 : 24,
        right: widget.sendByMe ? 24 : 0),
    alignment:
    widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
    child: MyAudioPlayer(filePath: widget.path,)
    );
  }
}
class ImageTile extends StatefulWidget {
  final String path;
  final bool sendByMe;
  final bool byte;
  ImageTile(
      {@required this.path, @required this.sendByMe, @required this.byte});
  @override
  _ImageTileState createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        width: 250,
        padding: EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: widget.sendByMe ? 0 : 24,
            right: widget.sendByMe ? 24 : 0),
        alignment:
            widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            margin: widget.sendByMe
                ? EdgeInsets.only(left: 30)
                : EdgeInsets.only(right: 30),
            padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.00),
              gradient: widget.sendByMe ? greyGradient : linearGradient,
              image: DecorationImage(
                  image: widget.byte
                      ? MemoryImage(base64.decode(widget.path))
                      : FileImage(Io.File(widget.path)),
                  fit: BoxFit.cover),
            )));
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    double minValue = 8.0;
    return Column(
      crossAxisAlignment: sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: sendByMe
              ? EdgeInsets.only(right: 0.0, bottom: minValue * 2, left: 200.0)
              : EdgeInsets.only(right: 200.0, bottom: minValue * 2, left: 0.0),
          padding: EdgeInsets.all(minValue),
          height: 55.0,
          decoration: BoxDecoration(
        borderRadius: sendByMe
        ? BorderRadius.only(
        topLeft: Radius.circular(minValue * 4),
        bottomLeft: Radius.circular(minValue * 4),
        topRight: Radius.circular(minValue * 4))
        : BorderRadius.only(
        bottomLeft: Radius.circular(minValue * 4),
        topRight: Radius.circular(minValue * 4)
        ),
        gradient: sendByMe ? greyGradient : linearGradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: sendByMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(message,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: "Segoe UI",
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
