//
//  LocalNotificationManager.swift
//  iOS App Signer
//
//  Created by dd on 8/3/2023.
//  Copyright © 2023 Daniel Radtke. All rights reserved.
//

import Foundation
import UserNotifications

open class NotificationManager: NSObject {
    
    // Make sure you ask user for notification permissions in your AppDelegate!
    static let shared = NotificationManager()

    // MARK: - Setup
    
    override init() {
        super.init()
        
        // Delegate implementation is broken out into class extensions at the end of this file
        
        if #available(OSX 10.14, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
            NSUserNotificationCenter.default.delegate = self
        }
        
    }
    
    
//    // MARK: - Public Functions
//    func showInteractiveNotification(for object: Any) {
//        // Use UNUserNotification for macOS 10.14+, otherwise use depricated NSUserNotification
//        if #available(macOS 10.14, *) {
//            self.showInteractiveUNUserNotification(for: object)
//        } else {
//            self.showInteractiveNSUserNotification(for: object)
//        }
//    }
//
//    func showBasicNotification(for object: Any) {
//        // Use UNUserNotification for macOS 10.14+, otherwise use depricated NSUserNotification
//        if #available(macOS 10.14, *) {
//            self.showBasicUNUserNotification(for: object)
//        } else {
//            self.showBasicNSUserNotification(for: object)
//        }
//    }
//
    func showUserNotification(title: String, subtitle: String, body: String) {
        // Use UNUserNotification for macOS 10.14+, otherwise use depricated NSUserNotification
        if #available(macOS 10.14, *) {
            self.showBasicUNUserNotification11(title: title, subtitle: subtitle, body: body)
        } else {
            self.showBasicNSUserNotification11(title: title, subtitle: subtitle, body: body)
        }
    }
//
//
//    // MARK: - Private macOS Version Helpers
//    // display text input notification using NSUserNotificationCenter
//    fileprivate func showInteractiveNSUserNotification(for object: Any) {
//        // build the notification
//        let notification = NSUserNotification()
//
//        // you can use information from the object parameter to create more robust content
//
//        // pass any information or objects you need the delegate to receive in userInfo
//        notification.userInfo = ["Example key": "Example value", "Another key": "Another value"]
//
//        notification.title = "This is the Title"
//        notification.informativeText = "This is the informative text."
//
//        notification.hasReplyButton = true
//        notification.responsePlaceholder = "This is where you type a reply"
//
//        // ask macOS to deliver the notification
//        NSUserNotificationCenter.default.deliver(notification)
//    }
//
//    // display basic notification using deprecated NSUserNotificationCenter
//    fileprivate func showBasicNSUserNotification(for object: Any) {
//        // build the notification
//        // you can use information from the object parameter to create more robust content
//        let notification = NSUserNotification()
//        notification.hasActionButton = false // no extra buttons on this notification
//        notification.title = "This is the Title"
//        notification.subtitle = "This is the subtitle."
//        notification.informativeText = "This is the informative text."
//
//        // ask macOS to deliver the notification
//        NSUserNotificationCenter.default.deliver(notification)
//    }
//
//
//    // display text input custom notification using UNUserNotificationCenter
//    @available(macOS 10.14, *)
//    fileprivate func showInteractiveUNUserNotification(for object: Any) {
//
//        // build notification text input action button
//        let customAction = UNTextInputNotificationAction(identifier: "customAction", title: "Click me!", options: .foreground, textInputButtonTitle: "Submit", textInputPlaceholder: "Enter your text here")
//
//        // assign our customAction to a category object
//        let category = UNNotificationCategory(identifier: "exampleCategory", actions: [customAction], intentIdentifiers: [])
//
//        // register the category with UNUserNotificationCenter
//        UNUserNotificationCenter.current().setNotificationCategories([category])
//
//        // build notification content
//        // you can use information from the object parameter to create more robust content
//        let content = UNMutableNotificationContent()
//        content.userInfo = ["Example key": "Example value", "Another key": "Another value"]
//        content.title = "This is the Title"
//        content.subtitle = "This is the subtitle."
//        content.sound = UNNotificationSound.default
//
//        // assign our previously created category to be used by this notification
//        content.categoryIdentifier = "exampleCategory"
//
//        // build and add notification request
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
//        UNUserNotificationCenter.current().add(request)
//    }
//
//    // display basic notification using UNUserNotificationCenter
//    @available(macOS 10.14, *)
//    fileprivate func showBasicUNUserNotification(for object: Any) {
//
//        // you can use information from the object parameter to create more robust content
//        let content = UNMutableNotificationContent()
//        content.title = "This is the Title"
//        content.subtitle = "This is the subtitle."
//        content.body = "This is the body."
//        content.sound = UNNotificationSound.default
//
//        // build and add notification request
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
//        UNUserNotificationCenter.current().add(request)
//    }
    
    
    
    
    
    fileprivate func showBasicNSUserNotification11(title: String, subtitle: String, body: String) {
        // build the notification
        // you can use information from the object parameter to create more robust content
        let notification = NSUserNotification()
        notification.hasActionButton = false 
        notification.title = title
        notification.subtitle = subtitle
        notification.informativeText = body
        
        // ask macOS to deliver the notification
        NSUserNotificationCenter.default.deliver(notification)
    }
    @available(macOS 10.14, *)
     func showBasicUNUserNotification11(title: String, subtitle: String, body: String) {

        // you can use information from the object parameter to create more robust content
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = UNNotificationSound.default
        
        // build and add notification request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
    
    
    
//    一体
    func localNoti () {
        if #available(OSX 10.14, *) {
              UNUserNotificationCenter.current().delegate = self // must have delegate, otherwise notification won't appear
              UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge]) {[weak self] granted, error in
                    
                  print("Permission granted: \(granted)")
                  guard granted else { return }

                  let sound = "NO"
                  let notificationCenter = UNUserNotificationCenter.current()
                  notificationCenter.getNotificationSettings
                     { (settings) in
                      if settings.authorizationStatus == .authorized {
                          //print ("Notifications Still Allowed");
                          // build the banner
                          let content = UNMutableNotificationContent();
                          content.title = "summary" ;
                          content.body = "下面我们通过两个简单的 Demo 看一下如何实现本地消息通知。两个 Demo 中我们分别设置一个按钮，并分别绑定 各自的 Action，一个 Action 中按照传统的方式实现消息通知，另一个 Action 中按照新的方式实现。这个消息通知具有以下实现：" ;
                          if sound == "YES" {content.sound =  UNNotificationSound.default};
                          // could add .badge
                          // could add .userInfo

                          // define when banner will appear - this is set to 1 second - note you cannot set this to zero
                          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false);

                          // Create the request
                          let uuidString = UUID().uuidString ;
                          let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger);

                          // Schedule the request with the system.
                          notificationCenter.add(request, withCompletionHandler:
                              { (error) in
                              if error != nil
                                  {
                                      // Something went wrong
                                  }
                              })
                          //print ("Notification Generated");
                      }
                  }
              }
          } else {
              // Fallback on earlier versions
          }
        
    }
    
    
    
}









// MARK: - NSUserNotificationCenterDelegate
extension NotificationManager: NSUserNotificationCenterDelegate {
    
    // you can use this method to turn off notifications if the user doesn't want them
    public func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    // this method is called when our NSUserNotification action button is clicked
    public func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        switch (notification.activationType) { // switch on whether user clicked "reply" or "cancel"
        case .replied:
            guard let res = notification.response else { return }
            // do something with the reply text here
            print(res)
            
            // you can also access anything from your userInfo dictionary
            guard let info = notification.userInfo?["Example key"] else { return }
            print(info)
        default:
            break
        }
    }
}


// MARK: - UNUserNotificationCenterDelegate
@available(macOS 10.14, *)
extension NotificationManager: UNUserNotificationCenterDelegate {
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    // this method is called when a button in our UNUserNotification is clicked
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary (if needed)
        let userInfo = response.notification.request.content.userInfo
            
        if response.actionIdentifier == "customAction" { // this is the identifier we assigned to our action button earlier
            guard let textResponse = response as? UNTextInputNotificationResponse else { return }
            
            // do some work with the response here
            print(textResponse.userText)
        }
        // you must call the completion handler when you're done
        completionHandler()
    }
}
