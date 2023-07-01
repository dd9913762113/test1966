//
//  DBJKit.swift
//  DBJKit
//
//  Created by funny on 17/05/2022.
//

import Foundation
import UIKit

public enum DBJTool {
    /// 退出后通知
    public static let DBJKitServiceEndCloseNotice: NSNotification.Name = .init(rawValue: "DBJ_kit_service_close_notice_end")
    /// 即将退出
    public static let DBJKitServiceWillCloseNotice: NSNotification.Name = .init(rawValue: "DBJ_kit_service_close_notice_will")

    public struct DBJParameters {
        /// 商戶號(ex.BP)
        public let merchant: String
        
        /// 一般客服=0 財務客服=1
        public let serviceType: String
        
        /// 訂單資訊
        public let orderInfo: String

        /// 玩家帳號
        public let account: String
        
        /// 平台名稱 ex.E體育
        public let ipName: String
        
        /// 平台app版號
        public let appVersion: String
        
        /// 正式版=1 測試版=0 對應平台發布版本
        public let formal: String
        
        /// 设备id
        public var deviceId: String?
        
        /// 登入ip位置
        public var ip: String?
        
        ///教程url
        public var tutorial: String
        /// 参数
        /// - Parameters:
        ///   - merchant:  商戶號(ex.BP)
        ///   - serviceType: 一般客服=0 財務客服=1
        ///   - orderInfo: 訂單資訊
        ///   - account: 玩家帳號
        ///   - ipName: 平台名稱 ex.E體育
        ///   - ip: 登入ip位置
        ///   - appVersion: 平台app版號
        ///   - formal: 正式版=1 測試版=0 對應平台發布版本
        ///   - deviceId: 设备id
        public init(merchant: String, serviceType: String, orderInfo: String, account: String, ipName: String, appVersion: String, formal: String, ip: String? = nil, deviceId: String? = nil,tutorial:String) {
            self.merchant = merchant
            self.serviceType = serviceType
            self.orderInfo = orderInfo
            self.account = account
            self.ipName = ipName
            self.ip = ip
            self.appVersion = appVersion
            self.formal = formal
            self.deviceId = deviceId
            self.tutorial = tutorial
        }
    }
    
    public static func DBJServicePresentVCFrom(_ vc: UIViewController, _ parameters: DBJParameters) {
        let serviceVC = DBJServiceViewController(parameters: parameters)
        vc.present(serviceVC, animated: true)
    }
}
