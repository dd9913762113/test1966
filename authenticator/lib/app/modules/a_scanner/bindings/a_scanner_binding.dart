import 'package:get/get.dart';

import '../controllers/a_scanner_controller.dart';

class AScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AScannerController>(
      () => AScannerController(),
    );
  }
}
