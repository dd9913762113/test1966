//
//  DBJOCHUDProgress.m
//  DBJOCKit
//
//  Created by funny on 16/06/2022.
//

#import "DBJOCHUDProgress.h"
#import "UIColor+DBJ.h"

@implementation DBJOCHUDProgress

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadUI];
    }
    return self;
}
- (void)loadUI {
    self.backgroundView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:self.backgroundView];
    
    
    self.backgroundView.layer.cornerRadius = 4;
    self.backgroundView.layer.maskedCorners =  kCALayerMinXMinYCorner|kCALayerMaxXMinYCorner|kCALayerMinXMaxYCorner|kCALayerMaxXMaxYCorner;

    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.activityIndicator = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, (self.frame.size.width - 15) / 2.0, (self.frame.size.width - 15) / 2.0)];
    _activityIndicator.center = CGPointMake(self.frame.size.width/2, 15 + (self.frame.size.width - 15)/4.0);
    _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    NSBundle * boundle = [NSBundle bundleForClass:[DBJOCHUDProgress class]];
    UIImage * image = [UIImage imageNamed:@"DJBOCKitload" inBundle:boundle compatibleWithTraitCollection:nil];
    _activityIndicator.image = image;
    
    [self.backgroundView addSubview:_activityIndicator];
    CGFloat margin = 10;
    
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.activityIndicator.frame), self.frame.size.width - margin*2, 30)];
    [self.backgroundView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"正在加载";
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [[UIColor colorFromHex:0x000000] colorWithAlphaComponent:0.55];
}

- (void)starAnimation {
    self.backgroundView.alpha = 0;
    self.hidden = false;
    self.isStopAnimation = false;
    [self rotate];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundView.alpha = 1;
    }];
}
- (void)stopAnimation {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = true;
        self.isStopAnimation = true;
        [self.animator startAnimation];
    }];
}
- (void)rotate {
    
    DEF_WEAKSELF
    self.animator = [[UIViewPropertyAnimator alloc] initWithDuration:2.5 curve:UIViewAnimationCurveLinear animations:^{
        
        weakSelf.activityIndicator.transform = CGAffineTransformMakeRotation(M_PI);
    }];

    [self.animator addAnimations:^{
        weakSelf.activityIndicator.transform = CGAffineTransformRotate(weakSelf.activityIndicator.transform, M_PI);
    }];
    [self.animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        if (!weakSelf.isHidden) {
            [weakSelf rotate];
        }
    }];
    [self.animator startAnimation];
}

- (void)dealloc {
    [self.animator stopAnimation:YES];
    self.isStopAnimation = true;
}
@end
