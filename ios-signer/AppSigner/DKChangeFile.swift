//
//  DKChangeFile.swift
//  iOS App Signer
//
//  Created by dd on 6/3/2023.
//  Copyright © 2023 Daniel Radtke. All rights reserved.
//

import Foundation
import SSZipArchive

open class DKChangeFile: NSObject {
    
    static let shared = DKChangeFile()

    var jsonPath: String = ""
    var bundlePath: String = ""
    var bundleInfoPlist: String = ""
    var tempUnzipPathString: String = ""
    
    func getAllFileName() -> [String] {
        
        if let array = FileManager.default.subpaths(atPath: self.jsonPath) {
            return array
        }

        return []
    }
    func changeFile(toPath: String, launchPath: String) {
        let files =  self.getAllFileName()
        for fileNamePath in files {
            if fileNamePath.hasSuffix(".json") || fileNamePath.hasSuffix(".DS_Store") {
                continue
            }
            let fileName = fileNamePath.lastPathComponent
            let ipaFileName = toPath + "/\(fileName)"
            do {
                if FileManager.default.fileExists(atPath: ipaFileName) {
//                    let sste = Process().execute(launchPath, workingDirectory: nil, arguments: ["rm","-rf", ipaFileName])
//                    rm -rf
                    try FileManager.default.removeItem(atPath: ipaFileName)
                }
                
//               let sste =  Process().execute(launchPath, workingDirectory: nil, arguments: ["mv",  self.jsonPath + "/\(fileNamePath)", ipaFileName])
                try FileManager.default.moveItem(atPath: self.jsonPath + "/\(fileNamePath)", toPath: ipaFileName)
               
            } catch let error {
                print("\(error)")
                
            }
            
        }
        
        
        
    }
    
    func changeImagesFromPathToPath(fromPath: String, toPath: String, completion: (_ isOK: Bool , _ string: String ) -> ()) {

        if fromPath.count == 0 {
            completion(false, "fromPath 为空")
            return
        }
        if toPath.count == 0 {
            completion(false, "toPath 为空")
            return
        }
        
        if !FileManager.default.fileExists(atPath: fromPath) {
//            print("没有此文件 fromPath地址:\(fromPath) \n toPath地址 \(toPath)")
            completion(false, " 没有此文件 \(fromPath)")
            return
        }
        do {
            if FileManager.default.fileExists(atPath: toPath) {
                try FileManager.default.removeItem(atPath: toPath)
            }

            try FileManager.default.copyItem(atPath: fromPath, toPath: toPath)
//            print(" 替换成功 ")
            completion(true, "替换成功")
        } catch let error as NSError {
//            setStatus("Error deleting GoogleService-Info.plist")
//            Log.write(error.localizedDescription)
//            cleanup(tempFolder); return
            print("没有此文件 fromPath地址:\(fromPath) \n toPath地址 \(toPath)")
            completion(false, error.localizedDescription)
        }
    }
    
    
//    func changeInfoPlist(key: String, value: String,completion: (_ isOK: Bool , _ string: String ) -> ()) {
//        if (key.count > 0 && value.count > 0) {
//            let changeTask = Process().execute(MainView.shared.defaultsPath, workingDirectory: nil, arguments: ["write", appBundlePath, key, value])
//            if changeTask.status != 0 {
//                completion(false, "Error changing key = \(key)  value = \(value)")
//            } else {
//                completion(true, "替换成功 key = \(key)  value = \(value)")
//            }
//        } else {
//            completion(false, "Error key = \(key)  value = \(value)")
//        }
//    }
    
    
    func unzipFile() {
        print("jsonPath = \(jsonPath)")
        
        let zipPath = jsonPath
        
        let success = SSZipArchive.isFilePasswordProtected(atPath: zipPath)
        if success {
            print("Yes, it's password protected.")
        } else {
            print("No, it's not password protected.")
        }
        
    }
    
    
    func unzipFileWithPassword(passWord: String?, zipPath: String, completion: (_ isOK: Bool , _ unzipPath: String ) -> ()) {
        
        if zipPath.count == 0 {return}
        guard let unzipPath = tempUnzipPath() else { return }
        self.tempUnzipPathString = unzipPath
        print("Unzip path:", unzipPath)
        
        let password = passWord ?? ""
        let success: Bool = SSZipArchive.unzipFile(atPath: zipPath,
                                                   toDestination: unzipPath,
                                                   preserveAttributes: true,
                                                   overwrite: true,
                                                   nestedZipLevel: 1,
                                                   password: !password.isEmpty ? password : nil,
                                                   error: nil,
                                                   delegate: nil,
                                                   progressHandler: nil,
                                                   completionHandler: nil)
        if success != false {
            print("Success unzip")
            completion(true, unzipPath)
        } else {
            print("No success unzip")
            completion(false, unzipPath)
            return
        }

        var items: [String]
        do {
            items = try FileManager.default.contentsOfDirectory(atPath: unzipPath)
            print(items)
        } catch {
            return
        }

        

    }
    
    func removeTempUnzipFiles() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            do {
                if FileManager.default.fileExists(atPath: self.tempUnzipPathString) {
                    try FileManager.default.removeItem(atPath: self.tempUnzipPathString)
                }
            } catch let error as NSError {
                print("没有此文件 或 删除失败 \(error) \(self.tempUnzipPathString) ")
            }
        }
    }
    
    private func tempZipPath() -> String {
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        path += "/\(UUID().uuidString).zip"
        return path
    }

    private func tempUnzipPath() -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        path += "/com.apple.zipun" + "/\(UUID().uuidString)"
        let url = URL(fileURLWithPath: path)

        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
        return url.path
    }
    
    
}
