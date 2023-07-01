//
//  UIView+DBJ.h
//  DBJOCKit
//
//  Created by funny on 16/06/2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (DBJ)
- (instancetype)roundedRectWith:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners;
- (void)changePath:(CGFloat) radius roundingCorners:(UIRectCorner)corners;
@end

NS_ASSUME_NONNULL_END
