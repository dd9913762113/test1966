//
//  DBJOCKit.h
//  DBJOCKit
//
//  Created by funny on 16/06/2022.
//

#import <Foundation/Foundation.h>

//! Project version number for DBJOCKit.
FOUNDATION_EXPORT double DBJOCKitVersionNumber;

//! Project version string for DBJOCKit.
FOUNDATION_EXPORT const unsigned char DBJOCKitVersionString[];


// 客服界面关闭后 发出通知
// 已经关闭
FOUNDATION_EXPORT NSNotificationName const DBJOCKitServiceEndCloseNotice;

// 将要关闭
FOUNDATION_EXPORT NSNotificationName const DBJOCKitServiceWillCloseNotice;


// In this header, you should import all the public headers of your framework using statements like #import <DBJOCKit/PublicHeader.h>

#import <DBJOCKit/DBJOCParameters.h>
#import <DBJOCKit/DBJOCKitTool.h>

