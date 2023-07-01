import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../routes/app_pages.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
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


  // Future<bool> checkPermission() async {
  //   PermissionStatus permission_camera = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
  //   PermissionStatus permission_storage = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  //
  //   print('check1 : $permission_camera');
  //   print('check2 : $permission_storage');
  //
  //   if(permission_camera == PermissionStatus.granted && permission_storage == PermissionStatus.granted)
  //     return true;
  //   else
  //     return false;
  // }

  Future<void> getPermissionPush() async {
    bool cameraPermission = await requestPermission(Permission.camera);
    bool photoPermission = await requestPermission(Permission.photos);

    // final isPermanentlyDenied = await Permission.camera.isPermanentlyDenied;
    // final isPhoto = await Permission.photos.isPermanentlyDenied;
    // print("isPermanentlyDenied = $isPermanentlyDenied  isPhoto = $isPhoto");
    // if(isPermanentlyDenied && isPhoto){
    print("isPermanentlyDenied = $cameraPermission  isPhoto = $photoPermission");
    if(cameraPermission && photoPermission){
      Get.toNamed(Routes.A_SCANNER, arguments: "11");
    }else{

    }
    Get.toNamed(Routes.A_SCANNER, arguments: "11");
  }

  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.status;
    if(status == PermissionStatus.granted) return true;
    try {
      final result = await permission.request();
      if(result == PermissionStatus.granted) return true;
      return false;
    } catch (e) {
      return false;
    }
    // permission.status.then((status) {
    //   if(status == PermissionStatus.granted) return true;
    //   return permission.request().then((result) {
    //     if(result == PermissionStatus.granted) return true;
    //     openAppSettings();
    //     return false;
    //   });
    // }).catchError((e) {
    //   return false;
    // });
  }



}



// class MockPermissionHandlerPlatform extends Mock
//     with
//     // ignore: prefer_mixin
//         MockPlatformInterfaceMixin
//     implements
//         PermissionHandlerPlatform {
//   @override
//   Future<PermissionStatus> checkPermissionStatus(Permission permission) =>
//       Future.value(PermissionStatus.granted);
//
//   @override
//   Future<ServiceStatus> checkServiceStatus(Permission permission) =>
//       Future.value(ServiceStatus.enabled);
//
//   @override
//   Future<bool> openAppSettings() => Future.value(true);
//
//   @override
//   Future<Map<Permission, PermissionStatus>> requestPermissions(
//       List<Permission> permissions) {
//     var permissionsMap = <Permission, PermissionStatus>{};
//     return Future.value(permissionsMap);
//   }
//
//   @override
//   Future<bool> shouldShowRequestPermissionRationale(Permission? permission) {
//     return super.noSuchMethod(
//       Invocation.method(
//         #shouldShowPermissionRationale,
//         [permission],
//       ),
//       returnValue: Future.value(true),
//     );
//   }
// }
