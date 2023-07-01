//
//  ViewController.swift
//  DBJDemo
//
//  Created by funny on 13/05/2022.
//

import UIKit
import DBJKit
import DBJOCKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func action(_ sender: Any) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(serviceDidClose), name: DBJTool.DBJKitServiceEndCloseNotice, object: nil)

//        DBJOCParameters()
//        let data = DBJOCParameters(merchant: "devyz", serviceType: "1", orderInfo: "modeId", account: "test111", ipName: "ETY", appVersion: "1.0.2", formal: "0", deviceId: "", ip: "");
//
//        DBJOCKitTool.dbjocServicePresentVC(from: self, parameters: data)

//        let data = DBJTool.DBJParameters(merchant: "devyz", serviceType: "1", orderInfo: "0udm2vR0fnzoNcOg8lht3R/mJ+jYOfX8xukJAY73QbSLZ9CF3lSAi4X8ZoowtXl4yULbO3Ky5NbruzAZlqtZQCBUazsbwbUeoclo86rU9I2w47EGmf0GJyztrSEzLfd5sB0CQxLzYREsri4NcV4d9HcnW6o4LkpqvX6WNIX4SYqxZ779TruBwr7v1nR+TkUgn3CoiH6JWOPiOrCTavWRsp+LhEhVSWdQGwMbtNHFdZqDPPg4guOw7AJLVwGDGG/ssY/dvvPF+LmIIv4lRqfTCg==", account: "test111", ipName: "ETY", appVersion: "1.0.2", formal: "0", tutorial: "11")
        let data = DBJTool.DBJParameters(merchant: "ety", serviceType: "1", orderInfo: "", account: "帳號", ipName: "ETY", appVersion: "1.0.2", formal: "0", tutorial: "11")

        DBJTool.DBJServicePresentVCFrom(self,data)
    }
    @objc
    func serviceDidClose() {
        print("客服界面退出")
    }
    
}

