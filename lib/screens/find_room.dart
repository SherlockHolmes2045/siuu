import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:flutter_ble_messenger/core/viewmodel/server_vm.dart';
import 'package:flutter_ble_messenger/custom/radar_group.dart';
import 'package:provider/provider.dart';

class FindRoom extends StatefulWidget {
  @override
  _FindRoomState createState() => _FindRoomState();
}

class _FindRoomState extends State<FindRoom> {
  bool serverFound = false;
  String ipAddress = "";
  bool isSearching = false;
  List<String> groups = List<String>();
  @override
  void initState() {
    context.read<ServerViewModel>().initState();
    getIpAdress();
    super.initState();
  }

  getIpAdress() async{
    if (!Platform.isMacOS) {
      setState(() async{

        ipAddress = await GetIp.ipAddress;
      });
    }
  }

  Future<dynamic> fetchServer(provider, BuildContext context) async {
    String ipAddress = "";
    if (!Platform.isMacOS) {
      ipAddress = await GetIp.ipAddress;
    }
    List<String> ipBreak = ipAddress.split(".");
    String network = ipAddress.substring(0, ipAddress.lastIndexOf("."));
    String networkPart = ipBreak[ipBreak.length - 1];

    int networkPartInt = int.parse(networkPart);
    provider.port.text = "4000";
    provider.name.text = "test";
    Socket socket;
    //print(ipAddress);
    for (int i = 1; i <= 255; i++) {
      if (i != networkPartInt) {
        String ipTest = network + "." + i.toString();

        socket = await Socket.connect(ipTest, int.parse("4000")).then((value) {
          provider.ip.text = ipTest;
          provider.port.text = "4000";
          provider.name.text = "test";
          print("success");
          setState(() {
            groups.add(ipTest);
          });
          serverFound = true;
        }).timeout(Duration(milliseconds: 80), onTimeout: () {
          //print("timeout");
          return;
        }).catchError((onError) {
          //print(onError);
          return;
        });
      }
      //if (serverFound) break;
      if(!serverFound && i == 255) {
        provider.ip.text = ipAddress;
        provider.port.text = "4000";
        provider.name.text = "test";
        break;
      }
    }
    print("recherche termninée");
    return serverFound ? provider.ip.text : ipAddress;
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ServerViewModel>();
    return Scaffold(
        body: RadarGroup(
            groups,
            CircleAvatar(
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isSearching = true;
                  });
                  fetchServer(provider, context).then((value){
                    if (!serverFound) {
                      print("creating server...");
                      provider.ip.text = value;
                      provider.port.text = "4000";
                      provider.name.text = "test";
                      provider.startServer(context,value,"4000","test");
                    } else {
                      //provider.connectToServer(context, isHost: false);
                      setState(() {
                        isSearching = false;
                      });
                    }
                  });
                }
                  /*setState(() {
                    isSearching = true;
                  });
                  if(groups.isEmpty){
                    provider.ip.text = ipAddress;
                    provider.port.text = "4000";
                    provider.name.text = "test";
                    provider.startServer(context,ipAddress,"4000","test");
                  }*/

              ),
            ),
            isSearching,
          provider,
          ipAddress,
          serverFound
        )/*FutureBuilder(
            future: fetchServer(provider, context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("future finished");
                if (!serverFound) {
                  print(snapshot.data);
                  print("creating server...");
                  provider.ip.text = snapshot.data;
                  provider.port.text = "4000";
                  provider.name.text = "test";
                  provider.startServer(context,snapshot.data,"4000","test");
                } else {
                  provider.connectToServer(context, isHost: false);
                }
                return Container();
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Chargement..."),
                      SpinKitThreeBounce(
                        color: Colors.redAccent,
                      )
                    ],
                  ),
                );
              }
            })*/
    );
  }
}
