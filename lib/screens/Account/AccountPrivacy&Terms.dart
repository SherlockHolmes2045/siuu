import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountPrivacyAndTerms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          SizedBox(height: height * 0.043),
          //SvgPicture.asset('assets/svg/lightningIcon2.svg'),
          SizedBox(height: height * 0.073),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas metus nisl, cursus sit amet pellentesque id, volutpat quis sapien.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Segoe UI",
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: Color(0xff544d4d),
            ),
          )
        ],
      ),
    );
  }
}
