import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AccountDetails extends StatefulWidget {
  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          // custom account details column
          buildAccountDetailsColumn(
            title: 'Member since',
            trailing: 'Guest',
          ),
          buildAccountDetailsColumn(
            title: 'Last seen',
            trailing: 'Add location',
          ),
          buildAccountDetailsColumn(
            title: 'Email',
            trailing: 'loremipsum@gmail.com',
          ),
          buildAccountDetailsColumn(
            title: 'Gender',
            trailing: 'Add location',
          ),
          buildAccountDetailsColumn(
            title: 'Born at',
            trailing: 'Add location',
          ),
          buildAccountDetailsColumn(
            title: 'Status',
            trailing: 'Add location',
          ),
          buildAccountDetailsColumn(
            title: 'Occupation',
            trailing: 'Add location',
          ),
          buildAccountDetailsColumn(
            title: 'Religion',
            trailing: 'Add location',
          ),
          buildAccountDetailsColumn(
            title: 'Pascal incline',
            trailing: 'Add location',
          ),
        ],
      ),
    );
  }

  Column buildAccountDetailsColumn({String title, String trailing}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(height: height * 0.014),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: "Segoe UI",
                fontSize: 13,
                color: Color(0xff544d4d),
              ),
            ),
            Row(
              children: [
                SvgPicture.asset('assets/svg/eye.svg'),
                SizedBox(width: width * 0.012),
                Text(
                  trailing,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Segoe UI",
                    fontSize: 13,
                    color: Color(0xff4d0cbb),
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(height: height * 0.014),
        Divider(
          color: Color(0xff707070),
          thickness: 1,
        )
      ],
    );
  }
}
