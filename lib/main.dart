import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/view/pages/welcome.dart';
import 'package:flutter_ble_messenger/view/widgets/common/custom_scroll_behavior.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/services/providerRegistrar.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_ble_messenger/route_generator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  createDb();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
          (_) {
            runApp(MyApp());
          },
  );
}

/*class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.native,
      theme: ThemeData(
        backgroundColor: Colors.white,
        primaryColor: Color(0xFF6c65f8),
        buttonColor: Color(0xFF69f0ae),
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black54),
      ),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
            behavior: CustomScrollBehavior(), child: child);
      },
      home: Welcome(),
    );
  }
}*/
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return MultiProvider(
                providers: registerProviders,
                child:  MaterialApp(
                  initialRoute: '/',
                  onGenerateRoute: RouteGenerator.generateRoute,
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primarySwatch: Colors.purple,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                )
            );
          },
        );
      },
    );
  }
}
createDb() async{
  Directory tempDir = await getApplicationDocumentsDirectory();

  final File file = File('${tempDir.path}/suiu.db');

  file.exists().then((isThere) {

    if (!isThere) {
      file.create();
    }

  });
}
