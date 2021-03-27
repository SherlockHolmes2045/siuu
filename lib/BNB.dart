import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_ble_messenger/res/colors.dart';
import 'package:flutter_ble_messenger/screens/Messages/Message.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    Widget child;
    child = Message();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox.expand(child: child),
          Positioned(
            bottom: 0,
            child: Container(
              color: Colors.white,
              width: width,
              child: Row(
                children: [
                  buildBottomNavigationBarItem(
                      iconPath: "assets/svg/message.svg",
                      index: 1,
                      title: 'Message'),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                setState(() {
                  _index = 4;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  height: height * 0.102,
                  width: width * 0.170,
                  decoration: BoxDecoration(
                      gradient: linearGradient, shape: BoxShape.circle),
                  child: Center(
                    child: SvgPicture.asset('assets/svg/lightningIcon.svg'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//custom nav bar item
  GestureDetector buildBottomNavigationBarItem(
      {String iconPath, int index, String title}) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        setState(() {
          _index = index;
        });
      },
      child: Container(
        width: width * 0.170,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: SvgPicture.asset(
                iconPath,
              ),
            ),
            if (title != null)
              FittedBox(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Segoe UI",
                    fontSize: 12,
                    color: Color(0xff78849e),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
