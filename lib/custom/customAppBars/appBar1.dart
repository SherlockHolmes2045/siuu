import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_ble_messenger/res/colors.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  CustomAppbar({this.title});
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        gradient: linearGradient,
      ),
      child: Column(
        children: [
          Container(
            height: height * 0.058,
          ),
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
                        Navigator.of(context).pushNamed('/camera');
                      },
                      child: SvgPicture.asset('assets/svg/Camera.svg')),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/ConnectionLostScreen');
                    },
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: "Segoe UI",
                        fontSize: 19,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/search');
                        },
                        child: SizedBox(
                          height: height * 0.029,
                          width: width * 0.048,
                          child: SvgPicture.asset('assets/svg/search.svg',
                              fit: BoxFit.contain, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: width * 0.04),
                      InkWell(
                        onTap: () {},
                        child: SvgPicture.asset('assets/svg/menu.svg'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
