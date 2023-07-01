//
//  DBJOCKit.m
//  DBJDemo
//
//  Created by funny on 16/06/2022.
//

#import "DBJOCKitTool.h"
#import "DBJCryptoOC.h"
#import "DBJOCServiceViewController.h"
#import "DBJOCParameters.h"
#import "DBJOCKit.h"

NSNotificationName const DBJOCKitServiceEndCloseNotice =  @"DBJOC_kit_service_close_notice";
NSNotificationName const DBJOCKitServiceWillCloseNotice =  @"DBJOC_kit_service_will_notice";



@implementation DBJOCKitTool

+ (void)DBJOCServicePresentVCFrom:(UIViewController *)vc parameters:(DBJOCParameters *)data {
    DBJOCServiceViewController * serviceVC = [[DBJOCServiceViewController alloc]initWithParameters:data];
    serviceVC.endCloseNoticeName = DBJOCKitServiceEndCloseNotice;
    serviceVC.willcloseNoticeName = DBJOCKitServiceWillCloseNotice;
    [vc presentViewController:serviceVC animated:YES completion:nil];
}
@end
