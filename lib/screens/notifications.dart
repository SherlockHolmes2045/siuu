import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/custom/customAppBars/appBar1.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool unreadNotification = false;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var buildListTile2 = buildListTile(
        image: "person1",
        title: 'Eizea Liam',
        subtitle: 'Sounds good catch uoi later mate.',
        trailing: 'Now');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.1755),
        child: CustomAppbar(
          title: 'Notifications',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildListTile2,
            buildListTile2,
            buildListTile2,
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: buildText(
                          color: 0xff000000,
                          fontSize: 16,
                          label: 'Suggestions for you'),
                    ),
                    buildCustomSuggestionListTile(height, width),
                    buildCustomSuggestionListTile(height, width),
                    buildCustomSuggestionListTile(height, width),
                    buildCustomSuggestionListTile(height, width),
                    buildCustomSuggestionListTile(height, width),
                  ],
                ),
              ),
            ),
            buildListTile2,
            buildListTile2,
            buildListTile2,
            buildListTile2,
            buildListTile2,
            buildListTile2,
            buildListTile2,
          ],
        ),
      ),
    );
  }

  Padding buildCustomSuggestionListTile(double height, double width) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        height: height * 0.073,
        child: ListTile(
          dense: true,
          leading: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/profile-picture.png',
                ),
                fit: BoxFit.fill,
              ),
              shape: BoxShape.circle,
            ),
            height: height * 0.070,
            width: width * 0.1166,
          ),
          title: buildText(
            color: 0xff000000,
            fontSize: 16,
            label: "John Doe",
          ),
          subtitle: buildText(
            color: 0xff7e7e7e,
            fontSize: 10,
            label: "@anysiuuser",
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: height * 0.033,
                width: width * 0.226,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  border: Border.all(
                    width: 1.00,
                    color: Color(0xff4d0cbb),
                  ),
                  borderRadius: BorderRadius.circular(8.00),
                ),
                child: Center(
                  child: buildText(
                    color: 0xff4d0cbb,
                    fontSize: 8,
                    label: "FOLLOW",
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.0121,
              ),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.close,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column buildListTile(
      {String image, String title, String subtitle, String trailing}) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            setState(() {
              unreadNotification = true;
            });
          },
          leading: Image.asset('assets/images/$image.png'),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: "Segoe UI",
              fontSize: 18,
              color: Color(0xff5e5e5e),
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontFamily: "Segoe UI",
              fontWeight: FontWeight.w300,
              fontSize: 17,
              color: unreadNotification ? Color(0xff4D0CBB) : Color(0xffaaa5a5),
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                trailing,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: "Segoe UI",
                  fontSize: 13,
                  color: Color(0xff5e5e5e),
                ),
              ),
            ],
          ),
        ),
        Divider(
          endIndent: 10,
          indent: 80,
          // thickness: 1,
          color: Color(
            0xff959CA7,
          ),
        ),
      ],
    );
  }

  Text buildText({String label, double fontSize, int color}) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontSize: fontSize,
        color: Color(color),
      ),
    );
  }
}
