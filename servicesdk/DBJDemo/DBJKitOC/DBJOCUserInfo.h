// To parse this JSON:
//
//   NSError *error;
//   DBJOCUserInfo *userInfo = [DBJOCUserInfo fromJSON:json encoding:NSUTF8Encoding error:&error];

#import <Foundation/Foundation.h>

@class DBJOCUserInfo;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface DBJOCUserInfo : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

NS_ASSUME_NONNULL_END
