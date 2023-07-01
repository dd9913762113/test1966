//
//            ┏┓      ┏┓+ +
//           ┏┛┻━━━━━━┛┻━┓ + +
//           ┃           ┃
//           ┃　　　━     ┃ ++ + + +
//          ████━████    ┃+
//           ┃           ┃ +
//           ┃     ┻     ┃
//           ┃           ┃ + +
//           ┗━━┓　　　┏━━┛
//              ┃　　　┃
//              ┃　　　┃ + + + +
//              ┃　　　┃
//              ┃　　　┃ + 　　　　神兽保佑,代码无bug
//              ┃　　　┃
//              ┃　　　┃　　+
//              ┃     ┗━━━┓ + +
//              ┃         ┣┓
//              ┃         ┏┛
//              ┗┓┓┏━┳┓┏━━┛ + + + +
//               ┃┫┫ ┃┫┫
//               ┗┻┛ ┗┻┛+ + + +
//
//
//
#import <UIKit/UIKit.h>

#define DEF_WEAKSELF    __weak __typeof(self) weakSelf = self;
#define DEF_WEAKSELF_( __CLASSNAME__ )      __weak typeof( __CLASSNAME__ *) weakSelf = self;


/**************************************************************/
//  RGB颜色
#define kRGB(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromHEX(hexValue) [UIColor colorFromHex:hexValue]

@interface UIColor (DBJ)

// 根据自己的颜色,返回黑色或者白色
- (instancetype)blackOrWhiteContrastingColor;

// 返回一个十六进制表示的颜色: @"FF0000" or @"#FF0000"
+ (instancetype)colorFromHexString:(NSString *)hexString;

+ (instancetype)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;

// 返回一个十六进制表示的颜色: 0xFF0000
+ (instancetype)colorFromHex:(int)hex;
+ (instancetype)colorFromHex:(int)hex alpha:(CGFloat)alpha;

// 返回颜色的十六进制string
- (NSString *)hexString;

/**
 Creates an array of 4 NSNumbers representing the float values of r, g, b, a in that order.
 @return    NSArray
 */
- (NSArray *)rgbaArray;

/**
 *  颜色转图片
 *
 *  @param color 颜色
 *
 *  @return 图片
 */
+(UIImage *)imageWithColor:(UIColor *)color;

@end

