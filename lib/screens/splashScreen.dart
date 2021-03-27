import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_ble_messenger/res/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(milliseconds: 5000),
      () => Navigator.of(context).pushReplacementNamed('/login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                FadeIn(
                  child: SizedBox(
                    height: height * 0.146,
                    width: width * 0.291,
                    child: Image.asset(
                      'assets/images/Siu.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  // Optional paramaters
                  duration: Duration(milliseconds: 4000),
                  curve: Curves.easeIn,
                ),
                SizedBox(height: height * 0.073),
                SpinKitWave(
                  itemCount: 7,
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(gradient: linearGradient),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
