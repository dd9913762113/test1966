//
//  DBJOCHUDProgress.h
//  DBJOCKit
//
//  Created by funny on 16/06/2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBJOCHUDProgress : UIView

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * activityIndicator;
@property (nonatomic, strong) UIViewPropertyAnimator * animator;
@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, assign) BOOL isStopAnimation;

- (void)starAnimation;
- (void)stopAnimation;
@end

NS_ASSUME_NONNULL_END
