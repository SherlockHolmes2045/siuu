import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ConnectionLostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Lottie.asset('assets/lottie/pageNotFound.json'),
                ),
                Align(
                  alignment: Alignment(0, 0.9),
                  child: new Text(
                    "OOPS! ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontSize: 40,
                      color: Color(0xff605454),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Spacer(),
                new AutoSizeText(
                  "Hi ! It seems you are not \nconnected. But don’t worry, \nyou can try nearby chats !!!",
                  maxFontSize: 25,
                  maxLines: 3,
                  minFontSize: 20,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Segoe UI",
                    color: Color(0xffB2ADAD),
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new Container(
                      height: height * 0.073,
                      width: width * 0.413,
                      decoration: BoxDecoration(
                        color: Color(0xff4d0cbb),
                        borderRadius: BorderRadius.circular(32.00),
                      ),
                      child: Center(
                        child: new Text(
                          "NEARBY CHAT",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Segoe UI",
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      height: height * 0.073,
                      width: width * 0.413,
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        border: Border.all(
                          width: 2.00,
                          color: Color(0xff4d0cbb),
                        ),
                        borderRadius: BorderRadius.circular(32.00),
                      ),
                      child: Center(
                        child: new Text(
                          "RETURN HOME",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Segoe UI",
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Color(0xff4d0cbb),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
