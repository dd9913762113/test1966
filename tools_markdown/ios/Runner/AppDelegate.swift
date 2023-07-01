import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .carPlay], completionHandler: { granted, _ in
      
      })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
          print("获取 DeviceToken 成功！！！ \(deviceToken)")
          guard let deviceString = dataToString(deviceToken: deviceToken) else {
              return
          }
          print("获取 DeviceToken 成功！！！ \(deviceString)")

      }

      // 推送处理 4
      // userInfo 内容请参考官网文档
      override func application(_ application: UIApplication,
                       didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                       fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

          //点击推送后请求api
      }

      // iOS10 新增：处理后台点击通知的代理方法
      @available(iOS 10.0, *)
      override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

          //点击推送后请求api
      }

      // iOS10 新增：处理前台收到通知的代理方法
      @available(iOS 10.0, *)
      override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

          completionHandler([.badge, .sound, .alert])
      }



      private func dataToString(deviceToken: Data) -> String? {
          let device = NSData(data: deviceToken)
          if !device.isKind(of: NSData.self) { return nil }
          var deviceString = String()
          let bytes = [UInt8](deviceToken)
          for item in bytes {
              deviceString += String(format: "%02x", item & 0x000000FF)
          }
          return deviceString
      }
}
