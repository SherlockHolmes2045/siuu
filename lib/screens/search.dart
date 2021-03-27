import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_ble_messenger/custom/customAppBars/appBar3.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(width, height * 0.1755),
          child: AppBar3(
            title: 'Search',
          ),
        ),
        body: SizedBox(
          height: height,
          child: Column(
            children: [
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
                  Tab(text: 'Suggestions'),
                  Tab(text: 'Followers'),
                  Tab(text: 'Follows'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    buildListView(height: height, width: width),
                    buildListView(height: height, width: width),
                    buildListView(height: height, width: width),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

ListView buildListView({double height, double width}) {
  return ListView(
    children: [
      buildListTile(
          height: height,
          width: width,
          image: "person1",
          title: 'Eizea Liam',
          subtitle: 'California',
          trailing: 'Now'),
      buildListTile(
          height: height,
          width: width,
          image: "person1",
          title: 'Eizea Liam',
          subtitle: 'California',
          trailing: 'Now'),
      buildListTile(
          height: height,
          width: width,
          image: "person1",
          title: 'Eizea Liam',
          subtitle: 'California',
          trailing: 'Now'),
      buildListTile(
          height: height,
          width: width,
          image: "person1",
          title: 'Eizea Liam',
          subtitle: 'California',
          trailing: 'Now'),
      buildListTile(
          height: height,
          width: width,
          image: "person1",
          title: 'Eizea Liam',
          subtitle: 'California',
          trailing: 'Now'),
      buildListTile(
          height: height,
          width: width,
          image: "person1",
          title: 'Eizea Liam',
          subtitle: 'California',
          trailing: 'Now'),
      buildListTile(
          height: height,
          width: width,
          image: "person1",
          title: 'Eizea Liam',
          subtitle: 'California',
          trailing: 'Now'),
      buildListTile(
          height: height,
          width: width,
          image: "person1",
          title: 'Eizea Liam',
          subtitle: 'California',
          trailing: 'Now'),
    ],
  );
}

Column buildListTile(
    {String image,
    String title,
    String subtitle,
    String trailing,
    double height,
    double width}) {
  return Column(
    children: [
      ListTile(
          leading: SizedBox(
            height: height * 0.070,
            width: width * 0.116,
            child: Stack(
              children: [
                Positioned.fill(child: Image.asset('assets/images/$image.png')),
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: SizedBox(
                    height: height * 0.011,
                    width: width * 0.019,
                    child: SvgPicture.asset('assets/svg/active.svg'),
                  ),
                ),
              ],
            ),
          ),
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
              color: Color(0xffaaa5a5),
            ),
          ),
          trailing: Container(
            height: height * 0.045,
            width: width * 0.238,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              border: Border.all(
                width: width * 0.002,
                color: Color(0xff4d0cbb),
              ),
              borderRadius: BorderRadius.circular(16.00),
            ),
            child: Center(
              child: Text(
                "suivre",
                style: TextStyle(
                  fontFamily: "Segoe UI",
                  fontSize: 15,
                  color: Color(0xff4d0cbb),
                ),
              ),
            ),
          )),
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
