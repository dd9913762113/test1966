import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/a_scanner_controller.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';

class AScannerView extends GetView<AScannerController> {
  AScannerView({Key? key}) : super(key: key);

  final scanWindow = Rect.fromCenter(
    center: Get.mediaQuery.size.center(Offset(0, -20)),
    width: 200,
    height: 200,
  );

  @override
  Widget build(BuildContext context) {
    controller.contextVC = context;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return Stack(
            fit: StackFit.expand,
            children: [
              MobileScanner(
                fit: BoxFit.contain,
                scanWindow: scanWindow,
                controller: controller.msc,
                onScannerStarted: (arguments) {
                  print("arguments = $arguments");
                  controller.msArguments.value = arguments!;
                  controller.msArguments.refresh();
                },
                onDetect: controller.onDetect,
              ),
              if (controller.barcode1.value != null && controller.barcode1.value.corners != null &&
                  controller.msArguments != null)
                CustomPaint(
                  painter: BarcodeOverlay(
                    barcode: controller.barcode1.value,
                    arguments: controller.msArguments.value,
                    boxFit: BoxFit.contain,
                    capture: controller.capture1!,
                  ),
                ),
              CustomPaint(
                painter: ScannerOverlay(scanWindow),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 100,
                  color: Colors.black.withOpacity(0.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Obx(() {
                          return Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 2.0, right: 15.0, bottom: 20),
                            child: TextButton(
                              onPressed: () {
                                showCopySuccess(context);
                                },
                              child: Text(
                                controller.barcode1.value.displayValue ?? '扫码结果! ',
                                maxLines:3,
                                overflow: TextOverflow.fade,
                              // textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  showCopySuccess(BuildContext context) async {
    String str = controller.barcode1.value.displayValue ?? "";
    if (str.length > 1) {
      Clipboard.setData(ClipboardData(text: str));
      final result = await showOkAlertDialog(
        context: context,
        title: '友情提示',
        message: '复制成功',
        barrierDismissible: false,
      );
      print(result);
    }
  }

}





///
///
///
class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()..addRect(scanWindow);

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BarcodeOverlay extends CustomPainter {
  BarcodeOverlay({
    required this.barcode,
    required this.arguments,
    required this.boxFit,
    required this.capture,
  });

  final BarcodeCapture capture;
  final Barcode barcode;
  final MobileScannerArguments arguments;
  final BoxFit boxFit;

  @override
  void paint(Canvas canvas, Size size) {
    if (barcode.corners == null) return;
    final adjustedSize = applyBoxFit(boxFit, arguments.size, size);

    double verticalPadding = size.height - adjustedSize.destination.height;
    double horizontalPadding = size.width - adjustedSize.destination.width;
    if (verticalPadding > 0) {
      verticalPadding = verticalPadding / 2;
    } else {
      verticalPadding = 0;
    }

    if (horizontalPadding > 0) {
      horizontalPadding = horizontalPadding / 2;
    } else {
      horizontalPadding = 0;
    }

    final ratioWidth =
        (Platform.isIOS ? capture.width! : arguments.size.width) /
            adjustedSize.destination.width;
    final ratioHeight =
        (Platform.isIOS ? capture.height! : arguments.size.height) /
            adjustedSize.destination.height;

    final List<Offset> adjustedOffset = [];
    for (final offset in barcode.corners!) {
      adjustedOffset.add(
        Offset(
          offset.dx / ratioWidth + horizontalPadding,
          offset.dy / ratioHeight + verticalPadding,
        ),
      );
    }
    final cutoutPath = Path()..addPolygon(adjustedOffset, true);

    final backgroundPaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    canvas.drawPath(cutoutPath, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}