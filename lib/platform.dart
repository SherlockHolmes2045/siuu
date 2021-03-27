import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PlatformTest extends StatefulWidget {
  @override
  _PlatformTestState createState() => _PlatformTestState();
}
class _PlatformTestState extends State<PlatformTest> {
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  final String title = "Platform";
  String response = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission(Permission.location);

  }

  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              response
            ),
            new RaisedButton(
              child: new Text('Move to Native World!'),
              onPressed: () async{
                response = "";
                try {
                  final List<String> result = await  platform.invokeMethod('getDevices');
                    print(result);
                  //print(response);
                } on PlatformException catch (e) {
                  response = "Failed to Invoke: '${e.message}'.";
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _showNativeView() async {
    String response = "";
    try {
      final String result = await  platform.invokeMethod('helloFromNativeCode');
      return response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "message":
        debugPrint(call.arguments);
        return new Future.value("");
    }
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
  }
}