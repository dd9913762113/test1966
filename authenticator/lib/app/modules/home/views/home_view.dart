import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          // child: Text(Get.find<TPlayController>().title.value),
          child: ListView(
              children: [
                ListTile(
                leading: Icon(Icons.car_rental),
                title: Text('scanner'),
                trailing: Icon(Icons.more_vert),
                onTap: () async {
                  print('sheep');
                  // Get.toNamed(Routes.);
                  // Navigator.of(context).pop();
                  // HomeBindings();
                  // final isPermanentlyDenied = await Permission.calendar.isPermanentlyDenied;
                  // final isPhoto = await Permission.photos.isPermanentlyDenied;
                  // if(isPermanentlyDenied && isPhoto){
                  //   Get.toNamed(Routes.A_SCANNER, arguments: "11");
                  // }
                  // controller.getPermissionPush();
                  if(Platform.isAndroid || Platform.isIOS || Platform.isMacOS){
                    Get.toNamed(Routes.A_SCANNER, arguments: "11");
                  }
                },
                ),
              ],
          ),
        ),

        ),

    );
  }
}
