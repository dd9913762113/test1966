import 'package:get/get.dart';

import '../modules/a_scanner/bindings/a_scanner_binding.dart';
import '../modules/a_scanner/views/a_scanner_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/t_google_authenticator/bindings/t_google_authenticator_binding.dart';
import '../modules/t_google_authenticator/views/t_google_authenticator_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // static const INITIAL = Routes.HOME;
  static const INITIAL = Routes.T_GOOGLE_AUTHENTICATOR;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.A_SCANNER,
      page: () => AScannerView(),
      binding: AScannerBinding(),
    ),
    GetPage(
      name: _Paths.T_GOOGLE_AUTHENTICATOR,
      page: () => TGoogleAuthenticatorView(),
      binding: TGoogleAuthenticatorBinding(),
    ),
  ];
}
