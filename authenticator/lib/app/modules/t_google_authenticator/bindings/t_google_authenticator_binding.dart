import 'package:get/get.dart';

import '../controllers/t_google_authenticator_controller.dart';

class TGoogleAuthenticatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TGoogleAuthenticatorController>(
      () => TGoogleAuthenticatorController(),
    );
  }
}
