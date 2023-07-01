//
//  FileModel.swift
//  iOS App Signer
//
//  Created by dd on 6/3/2023.
//  Copyright © 2023 Daniel Radtke. All rights reserved.
//

import Foundation

struct JSModel: SSCoadble {
    
    var jsonPath: String? = ""
    var appName: String?
    var iconName: IconModel?
    var iconPad: IconModel?
    var launchName: String?
    
    struct IconModel: SSCoadble {
        var CFBundlePrimaryIcon: IconFileInfo
    }
    struct IconFileInfo: SSCoadble {
        var CFBundleIconFiles: [String]
        var CFBundleIconName: String
    }
    
}


