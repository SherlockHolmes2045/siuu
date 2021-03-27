import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/view/pages/devices.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_ble_messenger/res/colors.dart';
import 'package:flutter_ble_messenger/screens/Messages/chat.dart';
import 'package:flutter_ble_messenger/screens/Nearby.dart';
import 'package:flutter_ble_messenger/screens/chat_list.dart';

import '../find_room.dart';
import 'loader.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> with SingleTickerProviderStateMixin {
  TabController _tabController;

  bool nearbyChat = false;

  Widget appBarTrailing;
  bool roomTalkScreen;
  @override
  void initState() {
    super.initState();
    roomTalkScreen = false;

    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
    appBarTrailing = Row(
      children: [
        SvgPicture.asset('assets/svg/clock.svg'),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SvgPicture.asset('assets/svg/coffee-cup.svg'),
        ),
      ],
    );
  }

  void _handleTabSelection() {
    final double width = MediaQuery.of(context).size.width;
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          setState(() {
            roomTalkScreen = false;
            appBarTrailing = Row(
              children: [
                sizedBox(),
                SizedBox(width: width * 0.024),
                SvgPicture.asset('assets/svg/coffee-cup.svg'),
              ],
            );
          });

          break;
        case 1:
          setState(() {
            nearbyChat = true;
            roomTalkScreen = false;
            appBarTrailing = Row(
              children: [
                sizedBox(),
                SizedBox(width: width * 0.024),
                SvgPicture.asset('assets/svg/user.svg'),
              ],
            );
          });

          break;
        case 2:
          setState(
            () {
              roomTalkScreen = true;
              appBarTrailing = Row(
                children: [
                  SvgPicture.asset('assets/svg/user.svg'),
                  SizedBox(width: width * 0.024),
                  SvgPicture.asset('assets/svg/coffee-cup.svg'),
                ],
              );
            },
          );

          break;
      }
    }
  }

  SizedBox sizedBox() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.060,
      height: height * 0.032,
      child: Stack(
        children: [
          SvgPicture.asset('assets/svg/clock.svg'),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: height * 0.016,
              width: width * 0.027,
              decoration: BoxDecoration(
                gradient: linearGradient,
                border: Border.all(
                  width: width * 0.002,
                  color: Color(0xffffffff),
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "1",
                  style: TextStyle(
                    fontFamily: "Segoe UI",
                    fontSize: 5,
                    color: Color(0xffffffff),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool unreadMessage = false;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * 0.2194),
          child: Column(
            children: [
              Container(
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
                            SvgPicture.asset('assets/svg/Camera.svg'),
                            Text(
                              "Messages",
                              style: TextStyle(
                                fontFamily: "Segoe UI",
                                fontSize: 19,
                                color: Color(0xffffffff),
                              ),
                            ),
                            appBarTrailing
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: Color(0xff4D0CBB),
                unselectedLabelStyle: TextStyle(
                  fontFamily: "Segoe UI",
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
                unselectedLabelColor: Color(0xff7e7e7e),
                labelStyle: TextStyle(
                  fontFamily: "Segoe UI",
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
                labelColor: Color(0xff4d0cbb),
                tabs: [
                  Tab(text: 'Chat'),
                  Tab(text: 'Nearby'),
                  Tab(text: 'RoomTalk'),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ChatList(),
            Devices(),
            FindRoom(),
          ],
        ),
      ),
    );
  }

  ListView buildListView() {
    return ListView(
      children: [
        buildListTile(
            image: "person1",
            title: 'Eizea Liam',
            subtitle: 'Sounds good catch uoi later mate.',
            trailing: 'Now'),
        buildListTile(
            image: "person1",
            title: 'Eizea Liam',
            subtitle: 'Sounds good catch uoi later mate.',
            trailing: 'Yesterday'),
        buildListTile(
            image: "person1",
            title: 'Eizea Liam',
            subtitle: 'Sounds good catch uoi later mate.',
            trailing: 'Now'),
        buildListTile(
            image: "person1",
            title: 'Eizea Liam',
            subtitle: 'Sounds good catch uoi later mate.',
            trailing: 'Now'),
        buildListTile(
            image: "person1",
            title: 'Eizea Liam',
            subtitle: 'Sounds good catch uoi later mate.',
            trailing: 'Now'),
        buildListTile(
            image: "person1",
            title: 'Eizea Liam',
            subtitle: 'Sounds good catch uoi later mate.',
            trailing: 'Now'),
        buildListTile(
            image: "person1",
            title: 'Eizea Liam',
            subtitle: 'Sounds good catch uoi later mate.',
            trailing: 'Now'),
        buildListTile(
            image: "person1",
            title: 'Eizea Liam',
            subtitle: 'Sounds good catch uoi later mate.',
            trailing: 'Now'),
      ],
    );
  }

  Column buildListTile(
      {String image, String title, String subtitle, String trailing}) {
    return Column(
      children: [
        ListTile(
          onLongPress: () {
            setState(() {
              unreadMessage = true;
            });
          },
          onTap: () {
            if (nearbyChat == true && roomTalkScreen == false) {
              Navigator.of(context).pushNamed(
                '/loader',
                arguments: Loader(
                  name: title,
                  isRoomTalk: false,
                ),
              );
            } else {
              roomTalkScreen
                  ? Navigator.of(context).pushNamed(
                      '/chat',
                      arguments: Chat(
                        name: title,
                        isRoomTalk: true,
                      ),
                    )
                  : Navigator.of(context).pushNamed(
                      '/chat',
                      arguments: Chat(
                        name: title,
                        isRoomTalk: false,
                      ),
                    );
            }
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
              color: unreadMessage ? Color(0xff4D0CBB) : Color(0xffaaa5a5),
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
}
