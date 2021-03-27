import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/res/colors.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final double width;
  final double height;

  final double borderRadius;
  CustomButton({this.label, this.height, this.borderRadius, this.width});
  @override
  Widget build(BuildContext context) {
    //custom button
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: linearGradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Segoe UI",
              fontSize: 15,
              color: Color(0xffffffff),
            )),
      ),
    );
  }
}
