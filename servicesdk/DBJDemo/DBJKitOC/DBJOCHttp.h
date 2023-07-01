//
//  DBJOCHttp.h
//  DBJOCKit
//
//  Created by funny on 16/06/2022.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^successBlock)(id model);
typedef void(^errorBlock)(NSString * msg, NSError  * _Nullable  error);

@interface DBJOCHttp : NSObject

+(void)getServiceURL:(NSString *)formal merchant:(NSString *)merchant service_type:(NSString *)service_type success:(successBlock) success fail:(errorBlock) errorBlock;
+ (void)getPersionInfo:(NSString *)webUrl success:(successBlock) success fail:(errorBlock) errorBlock;
+ (NSURLSessionTask *) getLocalIPInfoSuccess:(successBlock) success fail:(errorBlock) errorBlock;
@end


@interface UIImageView (DBJ)

- (void)loadUrlImage:(NSString *)imageUrl;
@end


NS_ASSUME_NONNULL_END
