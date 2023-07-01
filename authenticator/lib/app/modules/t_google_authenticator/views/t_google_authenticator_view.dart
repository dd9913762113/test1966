import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recognition_qrcode/recognition_qrcode.dart';
import '../../../../util/logger.dart';
import '../../../routes/app_pages.dart';
import '../controllers/t_google_authenticator_controller.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'totp.dart';
import 'base32.dart';

class TGoogleAuthenticatorView extends GetView<TGoogleAuthenticatorController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的验证器"),
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   tooltip: 'Navigation',
        //   onPressed: () => {
        //     debugPrint('Navigation button is pressed.'),
        //     showScannerOrPhoto(context),
        //   }
        // ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.qr_code_scanner),
        //     tooltip: 'Search',
        //     onPressed: () => {
        //       debugPrint('Search button is pressed.'),
        //       Get.toNamed(Routes.A_SCANNER)
        //     }
        //   ),
        // ],
      ),
      body: Obx(() {
        return Container(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            itemCount: controller.names.value.isEmpty ? 1 : controller.names
                .value.length,
            itemBuilder: (context, index) {
              if (controller.names.value.isEmpty) {
                return ElevatedButton(
                  child: Text("添加您的验证码"),
                  onPressed: () {
                    showScannerOrPhoto(context);
                  },
                );
              }
              return GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: TOTP(controller.codes.value[index])
                            .now()));
                  },
                  onLongPress: () async {
                    controller.delCode(controller.names.value[index]);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        controller.names.value[index],
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(TOTP(controller.codes.value[index]).now(),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline4),
                          CircularProgressIndicator(
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                            value: controller.leftTime.value / 30,
                          ),
                        ],
                      ),
                    ],
                  ));
            },
            separatorBuilder: (context, index) => Divider(),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showScannerOrPhoto(context);
        },
        tooltip: '添加您的验证码',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> showMyDialog() async {

    Get.dialog(AlertDialog(
      title: Text('添加您的验证码'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Form(
              // key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: controller.namesController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: '输入code别名',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return '输入code别名';
                      }
                      // controller.name.value = value;
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: controller.codesController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: '输入您的授权码',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return '输入您的授权码';
                      }
                      if (!base32.isValid(value)) {
                        return '您输入的代码无法解析';
                      }
                      logger.info("value =  $value");
                      // controller.code.value = value;
                      return null;
                    },
                    // controller: controller.codesController,
                    // validator: controller.validator,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          Get.back();
                        },
                        child: const Text('取消'),

                      ),
                      ElevatedButton(
                        onPressed: () {
                          print("key value =  ${controller.namesController.text}  ${controller.codesController.text}");

                          controller.addCode(controller.namesController.text ,controller.codesController.text);
                          Get.back();
                        },
                        child: const Text('添加'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  delTip(BuildContext context) async {

      final result = await showOkAlertDialog(
        context: context,
        title: '友情提示',
        message: '复制成功',

        barrierDismissible: false,
      );
      logger.info(result);
  }

  // Future<void> showScannerOrPhoto(BuildContext context) async {
  showScannerOrPhoto(BuildContext context) async {
    final result = await showModalActionSheet<String>(
      context: context,
      title: '请选择',
      actions: [
        const SheetAction(
          // icon: Icons.info,
          label: '相机',
          key: 'helloKey',
        ),
        const SheetAction(
          // icon: Icons.info,
          label: '相册',
          key: 'helloKey1',
        ),
        const SheetAction(
          // icon: Icons.info,
          label: '手动输入',
          key: 'helloKey2',
        ),
      ],
      cancelLabel: "取消"
    );
    // logger.info(result);
    switch(result) {
      case 'helloKey': {
        // logger.info("打开相机");
        var result = await Get.toNamed(Routes.A_SCANNER, parameters: {
          "url":  "",
        });
        /// 接收返回值
        if(result != null) {
          String collect = result["collect"];
          if (collect.isNotEmpty) {
            logger.info("接收返回值 = $result");
            controller.showResultAddCode(collect);
          }
        }
      } break;

      case 'helloKey1': {
        logger.info("打开相册");
        controller.pickImageFile();

      }break;
      case 'helloKey2': {
        logger.info("手动输入");
        showMyDialog();

      }break;
      default: {
        logger.info("自由退出");
      } break;
    }

  }

  // 取消 确定
  showDialog(BuildContext context) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: 'Title',
      message: 'This is message.',
      defaultType: OkCancelAlertDefaultType.cancel,
    );
    logger.info(result);
  }


}
