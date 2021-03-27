import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/res/colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;

  CustomTextField({this.hintText, this.isPassword});
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.070,
      width: width * 0.678,
      child: TextFormField(
        cursorColor: Color(purpleColor),
        obscureText: widget.isPassword ? true : false,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: widget.hintText == null ? '' : widget.hintText,
          hintStyle: TextStyle(
            fontFamily: "SF Pro Display",
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xff4d0cbb),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(48.0)),
            borderSide:
                BorderSide(width: width * 0.004, color: Color(greyishColor)),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(48.0)),
            borderSide:
                BorderSide(width: width * 0.004, color: Color(greyishColor)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(48.0)),
            borderSide:
                BorderSide(width: width * 0.004, color: Color(greyishColor)),
          ),
        ),
      ),
    );
  }
}
