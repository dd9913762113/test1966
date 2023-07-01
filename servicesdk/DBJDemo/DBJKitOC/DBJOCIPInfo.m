#import "DBJOCIPInfo.h"

// Shorthand for simple blocks
#define λ(decl, expr) (^(decl) { return (expr); })

// nil → NSNull conversion for JSON dictionaries
static id NSNullify(id _Nullable x) {
    return (x == nil || x == NSNull.null) ? NSNull.null : x;
}

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Private model interfaces

@interface DBJOCIPInfo (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

#pragma mark - JSON serialization

DBJOCIPInfo *_Nullable DBJOCIPInfoFromData(NSData *data, NSError **error)
{
    @try {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        return *error ? nil : [DBJOCIPInfo fromJSONDictionary:json];
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

DBJOCIPInfo *_Nullable DBJOCIPInfoFromJSON(NSString *json, NSStringEncoding encoding, NSError **error)
{
    return DBJOCIPInfoFromData([json dataUsingEncoding:encoding], error);
}

NSData *_Nullable DBJOCIPInfoToData(DBJOCIPInfo *info, NSError **error)
{
    @try {
        id json = [info JSONDictionary];
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:error];
        return *error ? nil : data;
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

NSString *_Nullable DBJOCIPInfoToJSON(DBJOCIPInfo *info, NSStringEncoding encoding, NSError **error)
{
    NSData *data = DBJOCIPInfoToData(info, error);
    return data ? [[NSString alloc] initWithData:data encoding:encoding] : nil;
}

@implementation DBJOCIPInfo
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"as": @"as",
        @"city": @"city",
        @"country": @"country",
        @"countryCode": @"countryCode",
        @"isp": @"isp",
        @"lat": @"lat",
        @"lon": @"lon",
        @"org": @"org",
        @"query": @"query",
        @"region": @"region",
        @"regionName": @"regionName",
        @"status": @"status",
        @"timezone": @"timezone",
        @"zip": @"zip",
    };
}

+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error
{
    return DBJOCIPInfoFromData(data, error);
}

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return DBJOCIPInfoFromJSON(json, encoding, error);
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[DBJOCIPInfo alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = DBJOCIPInfo.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (void)setNilValueForKey:(NSString *)key
{
    id resolved = DBJOCIPInfo.properties[key];
    if (resolved) [super setValue:@(0) forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    return [self dictionaryWithValuesForKeys:DBJOCIPInfo.properties.allValues];
}

- (NSData *_Nullable)toData:(NSError *_Nullable *)error
{
    return DBJOCIPInfoToData(self, error);
}

- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return DBJOCIPInfoToJSON(self, encoding, error);
}
@end

NS_ASSUME_NONNULL_END
