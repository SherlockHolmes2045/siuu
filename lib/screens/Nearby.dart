import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ble_messenger/model/device.dart';
import '../events.dart';
import 'package:flutter_ble_messenger/custom/radar.dart';

class Nearby extends StatefulWidget {
  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  List<Device> devices = new List<Device>();
  List<Device> result = new List<Device>();
  bool isSearching = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initstate");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Radar(
              !isSearching ? result : devices,
              CircleAvatar(
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                      running = false;
                    });
                    activateDiscovery();
                    runPlayground();
                    Timer(Duration(seconds: 15),(){
                      if(devices.isEmpty){
                        setState(() {
                          running = true;
                          runPlayground();
                          isSearching = false;
                          result = devices;
                        });
                      }
                    });
                  },
                ),
              ),
              isSearching)
          /*ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              itemCount: devices.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(devices[index].deviceName),
                  onTap: () async {
                    await platform.invokeMethod("connectToPeer",
                        {"address": devices[index].deviceAddres});
                    ChatDao chatDao = new ChatDao();
                   chatDao.findChat(devices[index].deviceAddres).then((value){
                     if(value.isEmpty){
                       print("enregistrement de la discussion");
                       chatDao.insert(chatModel.Chat(devices[index].deviceAddres,devices[index].deviceName)).then((onValue) {
                         return;
                       });
                     }
                   });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Chat(name: devices[index].deviceName,chatId: devices[index].deviceAddres,bleAddress: devices[index].bleAddres,)),
                    );
                  },
                );
              })*/
          ),
    );
  }

  Future<void> activateDiscovery() async {
    await platform.invokeMethod('discover');
  }

  bool running = false;
  void runPlayground() async {
    if (running) return;

    var cancel = startListening((msg) async {
      if (msg != null) {
        Map<dynamic, dynamic> result =
            await platform.invokeMethod('getDevices');
        setState(() {
          print(result.entries);
          /*devices = result.entries
              .map((element) => Device(
                  element.key['name'],
                  element.value["address"].split(" ")[0],
                  element.value["address"].split(" ")[1]))
              .toList();*/
        });
      }
    });
    //cancel();
  }
}
