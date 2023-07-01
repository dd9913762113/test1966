//
//  UIDevice+DBJ.m
//  DBJOCKit
//
//  Created by funny on 16/06/2022.
//

#import "UIDevice+DBJ.h"
#import "DBJKeyChainStore.h"
@implementation UIDevice (DBJ)
+(NSString *)getDeviceId {
    
    
    NSString * keyName = @"dbjKeychain";
    NSString * oldUUid = [[NSUserDefaults standardUserDefaults] objectForKey:keyName];
    if (oldUUid && oldUUid.length > 0) {
        return oldUUid;
    }
    NSString * deviceUUID = @"";
    NSString * bundleIdentifierStr = [NSBundle mainBundle].bundleIdentifier;
    if (!bundleIdentifierStr) {
        bundleIdentifierStr = @"com.dbjOCkit.keychain";
    }
    DBJKeyChainStore * keyChain = [DBJKeyChainStore keyChainStoreWithService:bundleIdentifierStr];
    
    NSString * keyChainKey = @"keyChain_UUID";
    NSString * keyChainValue = [keyChain stringForKey:keyChainKey];
    
    if (keyChainValue && keyChainValue.length > 0) {
        deviceUUID = keyChainValue;
    } else {
        deviceUUID = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        [keyChain setString:deviceUUID forKey:keyChainKey];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceUUID forKey:keyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return deviceUUID;
}
@end
