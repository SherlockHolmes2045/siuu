import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/controller/dates_controller.dart';
import 'package:flutter_ble_messenger/controller/devices_controller.dart';
import 'package:flutter_ble_messenger/view/animations/fade.dart';
import 'package:flutter_ble_messenger/view/widgets/common/sliver_app_bar_title.dart';
import 'package:flutter_ble_messenger/view/widgets/devices/device_card.dart';
import 'package:get/get.dart';

class Devices extends StatelessWidget {
  final greetingsController = Get.put(DatesController());
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: MessengerBody(),
        ),
        ),
    );
  }
}

class MessengerBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<DevicesController>(
      init: DevicesController(context),
      builder: (controller) {
        print(controller.devices);
        return controller.devices.isNotEmpty
            ? Center(
              child: ListView.builder(
                  itemCount: controller.devices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return DeviceCard(
                      device: controller.devices[index],
                      username: controller.username.value,
                    );
                  },
                ),
            )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).buttonColor),
                ),
              );
      },
    );
  }
}
