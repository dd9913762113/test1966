//
//  DBJOCParameters.m
//  DBJOCKit
//
//  Created by funny on 16/06/2022.
//

#import "DBJOCParameters.h"

@implementation DBJOCParameters
- (id)initWithMerchant:(NSString *)merchant serviceType:(NSString *) serviceType orderInfo:(NSString *)orderInfo account:(NSString *)account ipName:(NSString *)ipName appVersion:(NSString *)appVersion formal:(NSString *)formal deviceId:(nullable NSString *)deviceId ip:(nullable NSString *)ip {
    if (self = [super init]) {
        self.merchant = merchant;
        self.serviceType = serviceType;
        self.orderInfo = orderInfo;
        self.account = account;
        self.ipName = ipName;
        self.appVersion = appVersion;
        self.formal = formal;
        self.deviceId = deviceId;
        self.ip = ip;
    }
    return self;
}
@end
