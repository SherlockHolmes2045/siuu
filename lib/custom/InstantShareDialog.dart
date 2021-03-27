import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_ble_messenger/res/colors.dart';

class InstantShareDialog extends StatelessWidget {
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Dialog(
      insetPadding: EdgeInsets.fromLTRB(50.0, 0, 50.0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      backgroundColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          gradient: linearGradient,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        height: height * 0.2,
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Spacer(
                  flex: 2,
                ),
                buildRow(
                    height: height,
                    width: width,
                    text: 'Instant Share',
                    image: 'share'),
                Spacer(),
                Divider(
                  color: Colors.white10,
                  thickness: 1,
                ),
                Spacer(),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/expressYourself");
                    },
                    child: buildRow(
                        height: height,
                        width: width,
                        text: 'Express yourself',
                        image: 'expressIcon')),
                Spacer(
                  flex: 2,
                ),
              ],
            )),
      ),
    );
  }

//custom row
  Row buildRow({String image, String text, double height, double width}) {
    return Row(
      children: [
        SizedBox(
          height: height * 0.035,
          width: width * 0.058,
          child: SvgPicture.asset(
            'assets/svg/$image.svg',
            color: Colors.white,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          width: width * 0.072,
        ),
        buildText(text)
      ],
    );
  }

  Text buildText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontWeight: FontWeight.w300,
        fontSize: 17,
        color: Color(0xffffffff),
      ),
    );
  }
}
