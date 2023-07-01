//
//  DBJOCParameters.h
//  DBJOCKit
//
//  Created by funny on 16/06/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBJOCParameters : NSObject
@property (nonatomic, strong) NSString * merchant;
@property (nonatomic, strong) NSString * serviceType;
@property (nonatomic, strong) NSString * orderInfo;
@property (nonatomic, strong) NSString * account;
@property (nonatomic, strong) NSString * ipName;
@property (nonatomic, strong) NSString * appVersion;
@property (nonatomic, strong) NSString * formal;
@property (nonatomic, strong) NSString * deviceId;
@property (nonatomic, strong) NSString * ip;


- (id)initWithMerchant:(NSString *)merchant serviceType:(NSString *) serviceType orderInfo:(NSString *)orderInfo account:(NSString *)account ipName:(NSString *)ipName appVersion:(NSString *)appVersion formal:(NSString *)formal deviceId:(nullable NSString *)deviceId ip:(nullable NSString *)ip;

@end

NS_ASSUME_NONNULL_END
