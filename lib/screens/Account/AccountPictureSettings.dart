import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountPictureSettings extends StatefulWidget {
  @override
  _AccountPictureSettingsState createState() => _AccountPictureSettingsState();
}

class _AccountPictureSettingsState extends State<AccountPictureSettings> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildColumn(label: 'Photo de profile', image: 'photo1'),
          SizedBox(height: height * 0.043),
          buildColumn(label: 'Photo de couverture', image: 'photo2'),
        ],
      ),
    );
  }

//custom column
  Column buildColumn({String label, String image}) {
    final double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: "Segoe UI",
            fontSize: 13,
            color: Color(0xff7e7e7e),
          ),
        ),
        SizedBox(height: height * 0.029),
        Stack(
          children: [
            //Image.asset('assets/images/$image.png'),
            Positioned(
              top: 5,
              right: 10,
              child: Row(
                children: [
                  /*SvgPicture.asset('assets/svg/attachment.svg'),
                  SvgPicture.asset('assets/svg/cross.svg')*/
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
