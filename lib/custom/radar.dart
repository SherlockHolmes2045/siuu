import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_ble_messenger/model/device.dart';
import 'package:flutter_ble_messenger/database/chat_dao.dart';
import 'package:flutter_ble_messenger/model/chat.dart' as chatModel;
import 'package:flutter/services.dart';
import 'package:flutter_ble_messenger/res/colors.dart';
import 'package:flutter_ble_messenger/screens/Messages/chat_custom.dart';
class Radar extends StatefulWidget {
  List<Device> devices = new List<Device>();
  Widget buttonSearch;
  bool isSearching;
  Radar(this.devices,this.buttonSearch,this.isSearching);
  @override
  _RadarState createState() => _RadarState();
}

class _RadarState extends State<Radar> {
  String img = "assets/images/person1.png";
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  List<Widget> peers = new List<Widget>();
  int start = 5;

  List<Widget> buildPeers(double size) {
    peers = [];
    start = 5;
    setState(() {
      peers.add(
        Container(
          height: size,
        ),
      );
      peers.add(
        RadarCircle(1.0),
      );
      peers.add(
        RadarCircle(0.8),
      );
      peers.add(
        RadarCircle(0.6),
      );
      peers.add(
        RadarCircle(0.25),
      );
      peers.add(
        Positioned(
          top: size / 2,
          child: Container(
            width: size,
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      );
      peers.add(
        Positioned(
          left: (size - 16) / 2,
          top: 8,
          child: Container(
            height: size - 16,
            width: 1,
            color: Colors.grey[200],
          ),
        ),
      );
      peers.add(
        Positioned(
          top: size / 2 - 20,
          left: (size - 16) / 2 - 20,
          child: widget.isSearching ?
          SpinKitCircle(
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                    gradient: linearGradient,
                  shape: BoxShape.circle
                ),
              );
            },
          ) : widget.buttonSearch,
          ),
        );
    });
    if (widget.devices != null)
      widget.devices.forEach((element) {
        setState(() {
          peers.add(
            Positioned(
                top: size / start,
                left: size / 4,
                child: InkWell(
                    /*onTap: () async {
                      await platform.invokeMethod("connectToPeer",
                          {"address": element.deviceAddres});
                      ChatDao chatDao = new ChatDao();
                      chatDao.findChat(element.deviceAddres).then((value){
                        if(value.isEmpty){
                          print("enregistrement de la discussion");
                          chatDao.insert(chatModel.Chat(element.deviceAddres,element.deviceName)).then((onValue) {
                            return;
                          });
                        }
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Chat(name: element.deviceName,chatId: element.deviceAddres,bleAddress: element.bleAddres,)),
                      );
                    },*/
                  child: Pic(
                    image: img,
                    color: Colors.orange,
                    gradient: linearGradient,
                  ),
                ),
              ),
          );
        });
        start += 4;
      });
    return peers;
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width - 16;
    double height = MediaQuery.of(context).size.height - 32;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Stack(
              children: buildPeers(size),
            ),
          ),
        ),
      ),
    );
  }
}

class Pic extends StatelessWidget {
  final String image;
  final Color color;
  Gradient gradient;
  Pic({this.image, this.color,this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        //gradient: gradient,
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(0xff4D0CBB),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        child: Image.asset(image),
      ),
    );
  }
}

class RadarCircle extends StatelessWidget {
  final double factor;

  RadarCircle(this.factor);

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width - 16;
    return Positioned(
      top: size * (1 - factor) / 2,
      left: size * (1 - factor) / 2,
      bottom: size * (1 - factor) / 2,
      right: size * (1 - factor) / 2,
      child: Container(
        width: size * factor,
        height: size * factor,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey[200],
          ),
        ),
      ),
    );
  }
}
