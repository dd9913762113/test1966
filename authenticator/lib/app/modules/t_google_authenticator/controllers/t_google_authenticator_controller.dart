import 'dart:async';
import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recognition_qrcode/recognition_qrcode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../util/logger.dart';
import '../views/base32.dart';
import '../../../../../util/otpauth_migration/otpauth_migration.dart';

import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class TGoogleAuthenticatorController extends GetxController {
  //TODO: Implement TGoogleAuthenticatorController

  final count = 0.obs;
  late BuildContext contextVC;

  final leftTime = 30.obs;
  final names = <String>[].obs;
  final codes = <String>[].obs;
  String name = "";
  String code = "";

  final namesController = TextEditingController();
  final codesController = TextEditingController();
  // final otpAuthParser = OtpAuthMigration();

  Timer? timer;

  final picker = ImagePicker();
  final otpAuthParser = OtpAuthMigration();

  final JPush jpush = JPush();


  @override
  void onInit() {
    super.onInit();

    _retrieveData();
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      leftTime.value = DateTime.now().second % 30;
      _retrieveData();
    });
  }

  Future<void> _retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var keys = prefs.getKeys();
    // print("_retrieveData keys = $keys");
    names.value.clear();
    codes.value.clear();
    keys.forEach((element) {
      names.value.add(element);
      codes.value.add(prefs.getString(element) ?? "");
    });
    names.refresh();
    codes.refresh();

  }

  @override
  void onReady() {
    super.onReady();
    initPlatformState();
  }

  @override
  void onClose() {
    timer?.cancel();
  }
  void increment() => count.value++;


  addCode(String key, value) async {
    if (key.isEmpty) {
      return 'Please enter code name';
    }

    if (value == null || value.isEmpty) {
      return 'Please enter auth code';
    }
    if (!base32.isValid(value)) {
      return 'The code you entered cannot be parsed';
    }
    print("key value = $key  $value");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value).then((value) => {
      if (value) {
        Get.defaultDialog(title: "添加 成功",middleText: "$key 添加成功")
      }else{
        Get.defaultDialog(title: "添加 失败",middleText: "$key 添加失败")
      }

    });
  }

  delCode(String key) async {

    BuildContext context = Get.context ?? contextVC;
    final result = await showOkCancelAlertDialog(
      context: context,
      title: '友情提示',
      message: "确定删除验证码？",
      okLabel: "确定",
      cancelLabel: "取消",
    );
    if(result == OkCancelResult.ok){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(key).then((value) => {
        if (value) {
          print(" 删除验证码 "),
          _retrieveData(),
        }
      });
    }else{
      print(" 取消删除验证码 ");
    }

    print(" _delCode ");
  }


  pickImageFile() {
    try {
      picker.getImage(source: ImageSource.gallery).then((value) {
        if(value == null) return;
        logger.info("valuevalue = $value");
        RecognitionQrcode.recognition(value?.path).then((result) {
          if(result == null) return;
          // logger.info("RecognitionQrcode: $result");
          logger.info(" $result \n\n  ${result["value"]}");
          showResultAddCode(result["value"]);
        });
      });
    } on Exception catch (_, e) {
      logger.info("Error $e");
    }
    var uri = Uri.parse("http://www.flydean.com/doc#dart");
    logger.info(" ${uri.scheme} ${uri.host} 3= ${uri.path} 4= ${uri.fragment} 5= ${uri.origin} 6= ${uri.pathSegments} ");
  }

  showResultAddCode(String result) {

    List<String> uris = otpAuthParser.decode(result);
    logger.info("urisuris = $uris");
    uris.forEach((str){
      // logger.info(str);
      String string = Uri.decodeFull(str);
      List<String> mm = string.split("?secret=");
      String str1 = mm.last;
      mm.addAll(str1.split("&issuer="));

      print(" m == $mm");

      String value = mm[2];

      String name = mm.first.split("otpauth://totp/").last;
      print("\n name = ${name}  value = ${value}  \n\n ");
      addCode(name,value);
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;

    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
            print("flutter onReceiveNotification: $message");

          }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");

      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");

      }, onReceiveNotificationAuthorization:
          (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");

      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    jpush.setup(
      appKey: "d49d3019e2e65129bda98ad9",
      channel: "theChannel",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      print("flutter get registration id : $rid");
    });

    jpush.isNotificationEnabled().then((bool value) {
      logger.info("通知授权是否打开: $value");
      // if(!value) {
      //   Future.delayed(Duration(seconds: 3), ()
      //   {
      //     print("延时3秒执行");
      //     jpush.openSettingsForNotification();
      //   });
      // }

    }).catchError((onError) {
      logger.info("通知授权是否打开: ${onError.toString()}");

    });
  }

}


/*
 *   key value =  qwe123@gmail.com  OF3WKMJSGNAGO3LBNFWC4Y3PNU======
 * */