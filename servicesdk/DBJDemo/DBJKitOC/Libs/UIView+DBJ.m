//
//  UIView+DBJ.m
//  DBJOCKit
//
//  Created by funny on 16/06/2022.
//

#import "UIView+DBJ.h"

@implementation UIView (DBJ)
- (instancetype)roundedRectWith:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    return self;
}

-(void)changePath:(CGFloat) radius roundingCorners:(UIRectCorner)corners {
    
    CAShapeLayer * fieldLayer = self.layer.mask;
    if (fieldLayer != nil) {
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
        fieldLayer.frame = self.bounds;
        fieldLayer.path = maskPath.CGPath;
    }
}

@end
