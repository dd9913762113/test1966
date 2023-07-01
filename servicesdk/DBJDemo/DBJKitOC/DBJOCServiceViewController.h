//
//  DBJOCServiceViewController.h
//  DBJOCKit
//
//  Created by funny on 16/06/2022.
//

#import <UIKit/UIKit.h>
#import "DBJOCParameters.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBJOCServiceViewController: UIViewController

@property (nonatomic, strong) NSString * endCloseNoticeName;
@property (nonatomic, strong) NSString * willcloseNoticeName;
- (id)initWithParameters:(DBJOCParameters *)parameters;

@end

NS_ASSUME_NONNULL_END
