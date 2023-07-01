import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../util/logger.dart';

class AScannerController extends GetxController {
  //TODO: Implement AScannerController

  final count = 0.obs;
  MobileScannerController msc = MobileScannerController();

  final msArguments = MobileScannerArguments(hasTorch: false, size: Size.zero).obs;
  final barcode1 = Barcode(rawValue: '').obs;
  String displayValue = "";
  BarcodeCapture? capture1;
  late BuildContext contextVC;

  Future<void> onDetect(BarcodeCapture barcode) async {
    capture1 = barcode;
    barcode1.value = barcode.barcodes.first;
    if (displayValue == barcode1.value.displayValue) {
      return;
    }
    displayValue = barcode1.value.displayValue ?? "";
    update();
    String str =  barcode1.value.displayValue ?? "";
    if(str.isNotEmpty && str.contains("otpauth-migration://")) {

      BuildContext context = Get.context ?? contextVC;
      final result = await showOkCancelAlertDialog(
        context: context,
        title: '扫码成功',
        message: barcode1.value.displayValue!,
        okLabel: "确定并返回",
        cancelLabel: "取消",
      );
      if(result == OkCancelResult.ok){
        getBack(barcode1.value.displayValue!);
      }else{
        displayValue = "";
      }

    }else{
      Get.defaultDialog(
        title: "扫码失败",
        textConfirm: "确认",
        textCancel: "取消",
      );
    }
  }




  @override
  void onInit() {
    super.onInit();
    var text = Clipboard.getData(Clipboard.kTextPlain);
    print("剪贴板的文字 text = $text");
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;


  getBack (String value) {
    Get.back(result: {"collect": value});
    Get.back(result: {"collect": value});

  }


}
