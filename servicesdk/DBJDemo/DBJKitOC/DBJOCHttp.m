//
//  DBJOCHttp.m
//  DBJOCKit
//
//  Created by funny on 16/06/2022.
//

#import "DBJOCHttp.h"
#import "DBJCryptoOC.h"
#import "DBJOCIPInfo.h"
#import "DBJOCUserInfo.h"
#import <CommonCrypto/CommonCrypto.h>
static NSString * ivDataStr = @"8746376827619797";
static NSString * keyDataStr = @"AFCCydrG12345678";


static NSString * sourceURL = nil;

//@"https://zhcsline.oss-accelerate.aliyuncs.com/csline.txt";
static NSString * userHeadURL = @"https://zhcsuat.cdnvips.net/index/index/getKefuInfo?kefuCode=";




#ifndef dispatch_queue_async_safe
#define dispatch_queue_async_safe(queue, block)\
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(queue)) {\
        block();\
    } else {\
        dispatch_async(queue, block);\
    }
#endif

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block) dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif



@interface NSData (DBJ)

@property (nonatomic, readonly, strong) NSData          * MD5;
@property (nonatomic, readonly, strong) NSString        * MD5String;

@end


@implementation NSData (DBJ)

@dynamic MD5;
@dynamic MD5String;

- (NSData *)MD5
{
    unsigned char    md5Result[CC_MD5_DIGEST_LENGTH + 1];
    CC_LONG            md5Length = (CC_LONG)[self length];
    
    CC_MD5( [self bytes], md5Length, md5Result );
    
    
    NSMutableData * retData = [[NSMutableData alloc] init];
    if ( nil == retData )
        return nil;
    
    [retData appendBytes:md5Result length:CC_MD5_DIGEST_LENGTH];
    
    return retData;
}



- (NSString *)MD5String
{
    NSData * value = [self MD5];
    if ( value )
    {
        char            tmp[16];
        unsigned char *    hex = (unsigned char *)malloc( 2048 + 1 );
        unsigned char *    bytes = (unsigned char *)[value bytes];
        unsigned long    length = [value length];
        
        hex[0] = '\0';
        
        for ( unsigned long i = 0; i < length; ++i )
        {
            sprintf( tmp, "%02X", bytes[i] );
            strcat( (char *)hex, tmp );
        }
        
        NSString * result = [NSString stringWithUTF8String:(const char *)hex];
        free( hex );
        
        return result;
    }
    else
    {
        return nil;
    }
}

@end

@interface NSString (DBJ)
@property (nonatomic, readonly, strong) NSString        * MD5;
@end

@implementation NSString (DBJ)
- (NSString *)MD5
{
    NSData * value;
    
    value = [NSData dataWithBytes:[self UTF8String] length:[self length]];
    value = [value MD5];
    
    if ( value )
    {
        char            tmp[16];
        unsigned char *    hex = (unsigned char *)malloc( 2048 + 1 );
        unsigned char *    bytes = (unsigned char *)[value bytes];
        unsigned long    length = [value length];
        
        hex[0] = '\0';
        
        for ( unsigned long i = 0; i < length; ++i )
        {
            sprintf( tmp, "%02X", bytes[i] );
            strcat( (char *)hex, tmp );
        }
        
        NSString * result = [NSString stringWithUTF8String:(const char *)hex];
        free( hex );
        return result;
    }
    else
    {
        return nil;
    }
}
@end





@implementation DBJOCHttp

+(void)getServiceURL:(NSString *)formal merchant:(NSString *)merchant service_type:(NSString *)service_type success:(successBlock) success fail:(errorBlock) errorBlock {
//    NSString *getlineURL = @"https://getline.ccaabbw.com/?m=%@&service_type=%@";
    if([formal isEqualToString:@"0"]) {
//        sourceURL = [NSString stringWithFormat:@"%@%@%@", getlineURL, merchant,service_type];
        sourceURL = [NSString stringWithFormat:@"https://getline.ccaabbw.com/?m=%@&service_type=%@", merchant, service_type];
    } else {
        sourceURL = [NSString stringWithFormat:@"https://getline.ccaabbw.com/?m=%@&service_type=%@", merchant, service_type];
    }
    
    NSURL * url = [NSURL URLWithString:sourceURL];
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    id task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            dispatch_main_async_safe(^{
                errorBlock(error.domain,error);
            });
            return;
        }
        NSString * dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (dataStr == nil) {
            dispatch_main_async_safe(^{
                errorBlock(error.domain,error);
            });
            return;
        }
        NSString * urlStr = [DBJCryptoOC DBJAESDecrypt:dataStr mode:DBJModeCTR key:keyDataStr keySize:DBJKeySizeAES128 iv:ivDataStr padding:DBJCryptorPKCS7Padding];
        if (urlStr != nil) {
            dispatch_main_async_safe(^{
                success(urlStr);
            });
        }
    }];
    [task resume];
}

+ (void)getPersionInfo:(NSString *)webUrl success:(successBlock) success fail:(errorBlock) errorBlock {
    
    
    NSArray * array = [webUrl componentsSeparatedByString:@"kefu/"];
    
    if (array.count <= 1) {
        errorBlock(@"地址错误", nil);
        return;
    }
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",userHeadURL,array[1]]];
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    id task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            dispatch_main_async_safe(^{
                errorBlock(error.domain,error);
            });
            return;
        }
        NSError * jsonError;
        DBJOCUserInfo * obj = [DBJOCUserInfo fromData:data error:&jsonError];
        if (jsonError != nil) {
            dispatch_main_async_safe(^{
                errorBlock(jsonError.domain,jsonError);
            });
            return;
        }
        dispatch_main_async_safe(^{
            success(obj);
        });
    }];
    [task resume];
}

+ (NSURLSessionTask *) getLocalIPInfoSuccess:(successBlock) success fail:(errorBlock) errorBlock {
    NSURL * url = [NSURL URLWithString:@"https://pro.ip-api.com/json?key=Lc8YPMsejFG5GaE"];
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    id task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            dispatch_main_async_safe(^{
                errorBlock(error.domain,error);
            });
            return;
        }
        NSError * jsonError;
        DBJOCIPInfo * obj = [DBJOCIPInfo fromData:data error:&jsonError];
        if (jsonError != nil) {
            dispatch_main_async_safe(^{
                errorBlock(jsonError.domain,jsonError);
            });
            return;
        }
        dispatch_main_async_safe(^{
            success(obj);
        });
    }];
    [task resume];
    return  task;
}

@end

@implementation UIImageView (DBJ)

- (void)loadUrlImage:(NSString *)imageUrl {
    
    if (!imageUrl || imageUrl.length <= 0) {
        return;
    }
    NSString * imageName = [imageUrl MD5];
    

    NSArray<NSString *>  *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * diskCachePath = [paths[0] stringByAppendingPathComponent:@"imageCache"];
    NSString * imagePath = [diskCachePath stringByAppendingPathComponent:imageName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]) {
        NSError * error;
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath withIntermediateDirectories:true attributes:nil error:&error];
        if (error != nil) {
            NSLog(@"%@",error);
        }
        
        [self downImageWithUrl:imageUrl imageName:imageName];
    } else {
        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            [self localImageUrl:imagePath];
        } else {
            [self downImageWithUrl:imageUrl imageName:imageName];
        }
    }
}
- (void)localImageUrl:(NSString *)imageUrl {
     
    
    dispatch_main_async_safe(^{
        NSData * data = [[NSData alloc] initWithContentsOfFile:imageUrl];
        if (data != nil) {
            self.image = [UIImage imageWithData:data];
        }
    });
}

- (void)downImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName {
    
    NSURL * url = [NSURL URLWithString:imageUrl];
    
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    NSURLSession * session = [NSURLSession sharedSession];

    __weak __typeof(self) weakSelf = self;
    NSURLSessionTask * task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if ( error != nil) {
            NSLog(@"存储错误：%@",error);
        }
        
        if (location != nil) {
            
            NSArray<NSString *>  *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * diskCachePath = [paths[0] stringByAppendingPathComponent:@"imageCache"];
            NSString * imagePath = [diskCachePath stringByAppendingPathComponent:imageName];
            
            NSError * localError;
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL URLWithString:imagePath] error:&error];
            if ( localError != nil) {
                NSLog(@"存储错误：%@",localError);
            } else {
                [weakSelf localImageUrl:imagePath];
            }
        }
    }];
    [task resume];
}

@end

