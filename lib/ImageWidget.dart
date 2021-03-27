import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/core/model/message.dart';
import 'package:flutter_ble_messenger/res/colors.dart';
import 'package:flutter_ble_messenger/utils/margin.dart';

class ImageWidget extends StatelessWidget {
  final Message message;

  const ImageWidget({
    Key key,
    @required this.message,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double minValue = 8.0;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Directionality(
          textDirection: message.user != null && message.user == 0
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const YMargin(20),
              Container(
                //   width: screenWidth(context, percent: 0.6),
                margin: message.user != null && message.user == 0
                    ? EdgeInsets.only(right: 0.0, bottom: minValue * 2, left: 200.0)
                    : EdgeInsets.only(right: 200.0, bottom: minValue * 2, left: 0.0),
                decoration: BoxDecoration(
                  borderRadius: message.user != null && message.user == 0
                      ? BorderRadius.only(
                      topLeft: Radius.circular(minValue * 4),
                      bottomLeft: Radius.circular(minValue * 4),
                      topRight: Radius.circular(minValue * 4))
                      : BorderRadius.only(
                      bottomLeft: Radius.circular(minValue * 4),
                      topRight: Radius.circular(minValue * 4)
                  ),
                  gradient: message.user != null && message.user == 0
                      ? greyGradient
                      : linearGradient,
                ),
                padding: EdgeInsets.all(14),
                child: message?.isBold ?? false
                    ? Column(
                  children: <Widget>[
                    Container(
                        height: 7,
                        width: 30,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator()))
                  ],
                )
                    : Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(base64Decode(message.message)),
                      fit: BoxFit.cover
                    )
                  ),
                )
              ),
              const YMargin(5),
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  message.user != null && message.user == 0
                      ? "Vous"
                      : message.name ?? '',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                      fontWeight: FontWeight.w200),
                ),
              )
            ],
          )),
    );
  }
}
