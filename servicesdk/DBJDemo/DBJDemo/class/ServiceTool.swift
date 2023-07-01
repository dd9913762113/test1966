//
//  GetServiceURL.swift
//  webViewFramework
//
//  Created by Chris on 2022/5/12.
//

import UIKit
import WebKit

// MARK: - PersonInfor

struct PersonInfor: Codable {
    let name: String
    let avatar: String
}
// MARK: - DBJIPInfo
struct DBJIPInfo: Codable {
    let dbjipInfoAs, city, country, countryCode: String
    let isp: String
    let lat, lon: Double
    let org, query, region, regionName: String
    let status, timezone, zip: String

    enum CodingKeys: String, CodingKey {
        case dbjipInfoAs = "as"
        case city, country, countryCode, isp, lat, lon, org, query, region, regionName, status, timezone, zip
    }
}
var DBJIPINFO: String? = nil

// MARK: - ServiceTool

final class ServiceTool {
    fileprivate static var sourceURL = "https://zhcsline.oss-accelerate.aliyuncs.com/csline.txt"
    fileprivate static let ivDataStr = "8746376827619797"
    fileprivate static let keyDataStr = "AFCCydrG"
    fileprivate static let userHeadURL = "https://zhcsuat.cdnvips.net/index/index/getKefuInfo?kefuCode="
    
    static let isDebug: Bool = false
    
    static var observation: NSKeyValueObservation?
    
    public init() {}

    public static func getServiceURL(formal: String,merchant: String,service_type:String, completionHandler: @escaping (String?, URLResponse?, Error?) -> Void) {
        if(formal == "0"){
            sourceURL = "https://getline.ccaabbw.com/?m="+merchant+"&serviceType="+service_type
//            sourceURL = "https://getline.ccaabbw.com/?m=eviptest&serviceType=0"
        }else{
            sourceURL = "https://getline.ccaabbw.com/?m="+merchant+"&serviceType="+service_type
        }
        let url = URL(string: sourceURL)
        let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        let session = URLSession.shared
        if let observation = observation {
            observation.invalidate()
        }
        let task = session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                if let data = data, let dataStr = String(data: data, encoding: String.Encoding.utf8) {
                    let decURL = aesDecrypt(text: dataStr)
                    completionHandler(decURL, response, error)
                } else {
                    completionHandler(nil, response, error)
                }
                if let observationBlock = observation {
                    observationBlock.invalidate()
                }
            }
        }
        task.resume()
    }
    
    public static func getPersionInfo(webUrl: String, completionHandler: @escaping (PersonInfor?, Error?) -> Void) {
        let array = webUrl.components(separatedBy: "kefu/")
        
        if array.count <= 1 {
            return
        }
        let code = array[1]
        let myURL = "\(userHeadURL)\(code)"
        let url = URL(string: myURL)
        let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let data = data {
                    let person = try? JSONDecoder().decode(PersonInfor.self, from: data)
                    
                    if isDebug {
                        let dataStr = String(data: data, encoding: String.Encoding.utf8)
                        print("personInfo:\(String(describing: dataStr))")
                    }
                    completionHandler(person, error)
                } else {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
    }
    
    static func aesDecrypt(text: String) -> String {
        let str = text
        let key = keyDataStr
        let iv = ivDataStr
        guard let base64 = Data(base64Encoded: str) else { return "" }
        guard var keyData = key.data(using: String.Encoding.utf8) else { return "" }
        guard let ivData = iv.data(using: String.Encoding.utf8) else { return "" }
        keyData.count = 16
        do {
            let result = try DBJCrytp.crypt(DBJCrytp.OpMode.decrypt, blockMode: DBJCrytp.BlockMode.ctr, algorithm: DBJCrytp.Algorithm.aes, padding: DBJCrytp.Padding.pkcs7Padding, data: base64, key: keyData, iv: ivData)
            if let url = String(data: result, encoding: String.Encoding.utf8) {
                return url
            }
            return ""
        } catch {
            print(error)
        }
        return ""
    }
    
    
    static func getLocalIPInfo(completionHandler: @escaping (String?, Error?) -> Void) -> URLSessionDataTask {
        let url = URL(string: "https://pro.ip-api.com/json?key=Lc8YPMsejFG5GaE")
        let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let data = data {
                    let info = try? JSONDecoder().decode(DBJIPInfo.self, from: data)
                    
                    if isDebug {
                        let dataStr = String(data: data, encoding: String.Encoding.utf8)
                        print("personInfo:\(String(describing: dataStr))")
                    }
                    
                    if let ipInfo = info, ipInfo.status == "success"{
                        completionHandler(ipInfo.query, error)
                    } else {
                        completionHandler(nil, error)
                    }
                } else {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
        return task
    }
}

public extension UIColor {
    static func DBJGromHexColor(_ rgbValue: UInt, alpha: CGFloat) -> UIColor {
        let redFloat = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let greeFloat = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
        let blueFloat = CGFloat(rgbValue & 0xFF) / 255.0
        return UIColor(red: redFloat, green: greeFloat, blue: blueFloat, alpha: alpha)
    }
}
extension UIDevice {
    // 获取非缓存高度
    static func dbjNowStatusBarHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else {
                return UIApplication.shared.statusBarFrame.height
            }
            guard let statusBarManager = windowScene.statusBarManager else {
                return UIApplication.shared.statusBarFrame.height
            }
            let height = statusBarManager.statusBarFrame.height
            return height
        } else {
            let height = UIApplication.shared.statusBarFrame.height
            return height
        }
    }
}


extension UIImageView {
    func loadUrlImage(imageUrl: String) {
        let imageName = imageUrl.MD5
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let diskCachePath = (paths[0] as NSString).appendingPathComponent("imageCache")

        let imagePath = diskCachePath.appending("/\(imageName)")
        
        if !FileManager.default.fileExists(atPath: diskCachePath) {
            try? FileManager.default.createDirectory(atPath: diskCachePath, withIntermediateDirectories: true, attributes: nil)
            downImage(imageUrl, imageName: imageName)
        } else {
            if FileManager.default.fileExists(atPath: imagePath) {
                localImageUrl(imageUrl: imagePath)
            } else {
                downImage(imageUrl, imageName: imageName)
            }
        }
    }
    
    private func localImageUrl(imageUrl: String) {
        DispatchQueue.main.async {
            let data = try? Data(contentsOf: URL(fileURLWithPath: imageUrl))
            if let imageData = data {
                self.image = UIImage(data: imageData)
            }
        }
    }
    
    private func downImage(_ imageUrl: String, imageName: String) {
        let url = URL(string: imageUrl)
        let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        
        let session = URLSession.shared
        
        let task = session.downloadTask(with: request) { [weak self] url, _, _ in
            
            if let localUrl = url {
                let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                let tempSource = (paths[0] as NSString).appendingPathComponent("imageCache/\(imageName)")
                
                try? FileManager.default.moveItem(at: localUrl, to: URL(fileURLWithPath: tempSource))
                
                self?.localImageUrl(imageUrl: tempSource)
            }
        }
        task.resume()
    }
}

public extension UIView {
    /// 设置多个圆角
    ///
    /// - Parameters:
    ///   - cornerRadii: 圆角幅度
    ///   - roundingCorners: UIRectCorner(rawValue: (UIRectCorner.topRight.rawValue) | (UIRectCorner.bottomRight.rawValue))
    func filletedCorner(_ cornerRadii: CGSize, _ roundingCorners: UIRectCorner) {
        let fieldPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerRadii)
        let fieldLayer = CAShapeLayer()
        fieldLayer.frame = bounds
        fieldLayer.path = fieldPath.cgPath
        layer.mask = fieldLayer
    }
    
    func changePath(_ cornerRadii: CGSize, _ roundingCorners: UIRectCorner) {
        if let fieldLayer: CAShapeLayer = layer.mask as? CAShapeLayer {
            let fieldPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerRadii)
            fieldLayer.frame = bounds
            fieldLayer.path = fieldPath.cgPath
        }
    }
    
    func corner(_ cornerRadius: CGFloat) {
        self.clipsToBounds = true;
        self.layer.cornerRadius = cornerRadius;
    }
}
