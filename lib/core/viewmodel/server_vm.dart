import 'dart:developer';
import 'dart:io';
import 'dart:convert' show json, utf8;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:flutter_ble_messenger/core/model/message.dart';
import 'package:flutter_ble_messenger/core/model/tcpData.dart';
import 'package:flutter_ble_messenger/database/roomtalk_dao.dart';
import 'package:flutter_ble_messenger/screens/roomtalk.dart';

class ServerViewModel extends ChangeNotifier {
  List<Message> _messageList = [];
  List<Message> get messageList => _messageList;
  String errorMessage = '';

  ServerSocket _server;
  ServerSocket get server => _server;

  Socket _socket;
  Socket get socket => _socket;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  final TextEditingController ip = new TextEditingController();
  final TextEditingController port = new TextEditingController();
  final TextEditingController name = new TextEditingController();
  final TextEditingController msg = new TextEditingController();

  set server(ServerSocket val) {
    _server = val;
    notifyListeners();
  }

  set socket(Socket val) {
    _socket = val;
    notifyListeners();
  }

  void initState() async {
    if (!Platform.isMacOS) {
      ip.text = await GetIp.ipAddress;
    } else {
      ip.text = '';
    }

    port.text = "4000";
    errorMessage = '';
    RoomTalkDao roomTalkDao = new RoomTalkDao();
    roomTalkDao.getAll().then((value) {
      _messageList = value;
    });
  }

  getTCPData() {
    return TCPData(ip: ip.text, port: int.parse(port.text), name: name.text);
  }

  void startServer(context,String ipAdress,String portNumber,String userName) async {
    RoomTalkDao roomTalkDao = new RoomTalkDao();
    /*if (ip.text == null || ip.text.isEmpty) {
      errorMessage = "IP Address cant be empty!";
      print("here");
      //notifyListeners();
    } else if (port.text == null || port.text.isEmpty) {
      errorMessage = "Port cant be empty!";
      //notifyListeners();
    } else if (name.text == null || name.text.isEmpty) {
      errorMessage = "Name cant be empty!";
      //notifyListeners();
    } else {*/
      errorMessage = "";
      //notifyListeners();
      try {
        port.text = portNumber;
        ip.text = ipAdress;
        name.text = userName;
        _server = await ServerSocket.bind(ip.text, int.parse(port.text),
            shared: true);
        //notifyListeners();

        if (_server != null) {
          _server.listen((Socket _) {
            _socket = _;
            _.listen((List<int> data) {
              try {
                String result = new String.fromCharCodes(data);

                if (result.contains('name')) {
                  var message = Message.fromJson(json.decode(result));
                  inspect(message);
                  print(result);
                  _messageList.insert(
                      0,
                      Message(
                          message: message.message,
                          name: message.name,
                          type: message.type,
                          user: message.ip == getTCPData().ip ? 0 : 1,
                          time: message.time,
                          ip: message.ip
                      ));
                  roomTalkDao.insert(Message(
                      message: message.message,
                      name: message.name,
                      type: message.type,
                      user: message.ip == getTCPData().ip ? 0 : 1,
                      time: message.time,
                      ip: message.ip
                  ));
                  notifyListeners();
                }
                _.add(data);
              } catch (e) {
                print(e.toString());
              }
              notifyListeners();
            });
          });

          print('Started: ${server.address.toString()}');
          print(ip.text);
          connectToServer(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RoomTalk(tcpData: getTCPData(),
              isHost: true,) ),
          );
        }
      } catch (e) {
        print(e.toString());
      }
    //}
  }

  connectToServer(context, {bool isHost = true}) async {
    RoomTalkDao roomTalkDao = new RoomTalkDao();
    if (ip.text == null || ip.text.isEmpty) {
      errorMessage = "IP Address cant be empty!";
      notifyListeners();
    } else if (port.text == null || port.text.isEmpty) {
      errorMessage = "Port cant be empty!";
      notifyListeners();
    } else if (name.text == null || name.text.isEmpty) {
      errorMessage = "Name cant be empty!";
      notifyListeners();
    } else {
      try {
        _isLoading = true;
       // notifyListeners();
        _socket = await Socket.connect(ip.text, int.parse(port.text))
            .timeout(Duration(seconds: 1), onTimeout: () {
          throw "TimeOUt";
        });
       // notifyListeners();
        // listen to the received data event stream
        String ipAddress = await GetIp.ipAddress;
        _socket.listen((List<int> data) {
          try {
            String result = new String.fromCharCodes(data);

            if (result.contains('name')) {
              var message = Message.fromJson(json.decode(result));
              print(result);
              _messageList.insert(
                  0,
                  Message(
                      message: message.message,
                      name: message.name,
                      user: ipAddress == message.ip ? 0 : 1,
                      type: message.type,
                      time: message.time,
                      ip: message.ip
                  ));
              inspect(message);
              notifyListeners();
              roomTalkDao.insert(Message(
                message: message.message,
                name: message.name,
                user: ipAddress == message.ip ? 0 : 1,
                type: message.type,
                time: message.time,
                ip: message.ip
              ));
            }
          } catch (e) {
            print(e.toString());
          }
        });
        print('connected');
        if (!isHost)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RoomTalk(tcpData: TCPData(
                ip: ip.text, port: int.parse(port.text), name: name.text),)
          ));
        _isLoading = false;
       // notifyListeners();
      } catch (e) {
        _isLoading = false;
        //notifyListeners();
        //showErrorDialog(context, error: e.toString());
        print(e.toString());
      }
    }
  }

  closeSocket() async {
    await _socket.close();
  }

  void sendMessage(context, TCPData tcpData,String type,{bool isHost,String messages}) async{
    RoomTalkDao roomTalkDao = new RoomTalkDao();
    String senderIp = "";
    if (!Platform.isMacOS) senderIp = await GetIp.ipAddress;
    print(senderIp);
    var message = Uint8List.fromList(json.encode(
        Message(message: messages !=null ? messages : msg.text, name: tcpData?.name ?? '',ip: senderIp,type: type,time: DateTime.now().millisecondsSinceEpoch).toJson()).codeUnits);

    if (isHost) {
      print("host");
      _messageList.insert(
        0,
        Message(message: messages !=null ? messages :msg.text, name: tcpData?.name,user: 0,type: type,time: DateTime.now().millisecondsSinceEpoch),
      );
      notifyListeners();
    }

    try {
      _socket.add(message);
      roomTalkDao.insert(Message(message: messages !=null ? messages :msg.text, name: tcpData?.name ?? '',ip: senderIp,type: type,time: DateTime.now().millisecondsSinceEpoch));
      msg.clear();
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  @override
  void dispose() {
    closeSocket();
    _server.close();
    super.dispose();
  }

}
