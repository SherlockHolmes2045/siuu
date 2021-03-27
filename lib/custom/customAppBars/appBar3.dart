import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_ble_messenger/res/colors.dart';

class AppBar3 extends StatelessWidget {
  final String title;
  AppBar3({this.title});
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        gradient: linearGradient,
      ),
      child: Column(
        children: [
          Container(height: height * 0.0585),
          Container(
            height: height * 0.117,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/messages');
                    },
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontSize: 19,
                      color: Color(0xffffffff),
                    ),
                  ),
                  SvgPicture.asset('assets/svg/menu.svg'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
