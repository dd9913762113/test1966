//
//  AppDelegate.swift
//  DBJDemo
//
//  Created by funny on 13/05/2022.
//

import UIKit
import DBJOCKit
var window: UIWindow? {
    if #available(iOS 13, *) {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    } else {
        return UIApplication.shared.keyWindow
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//         DBJOCKitTool.test()
        
        // Override point for customization after application launch.
        return true
    }

}

