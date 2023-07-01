//
//  DBJOCKit.h
//  DBJDemo
//
//  Created by funny on 16/06/2022.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DBJOCParameters;

NS_ASSUME_NONNULL_BEGIN

@interface DBJOCKitTool : NSObject

+ (void)DBJOCServicePresentVCFrom:(UIViewController *) vc parameters:(DBJOCParameters *)data;


@end

NS_ASSUME_NONNULL_END
