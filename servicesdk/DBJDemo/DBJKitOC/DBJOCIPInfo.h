// To parse this JSON:
//
//   NSError *error;
//   DBJOCIPInfo *info = [DBJOCIPInfo fromJSON:json encoding:NSUTF8Encoding error:&error];

#import <Foundation/Foundation.h>

@class DBJOCIPInfo;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface DBJOCIPInfo : NSObject
@property (nonatomic, copy)   NSString *as;
@property (nonatomic, copy)   NSString *city;
@property (nonatomic, copy)   NSString *country;
@property (nonatomic, copy)   NSString *countryCode;
@property (nonatomic, copy)   NSString *isp;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lon;
@property (nonatomic, copy)   NSString *org;
@property (nonatomic, copy)   NSString *query;
@property (nonatomic, copy)   NSString *region;
@property (nonatomic, copy)   NSString *regionName;
@property (nonatomic, copy)   NSString *status;
@property (nonatomic, copy)   NSString *timezone;
@property (nonatomic, copy)   NSString *zip;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

NS_ASSUME_NONNULL_END
