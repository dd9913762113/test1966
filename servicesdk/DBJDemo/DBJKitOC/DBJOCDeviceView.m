//
//  DBJOCDeviceView.m
//  DBJOCKit
//
//  Created by funny on 16/06/2022.
//

#import "DBJOCDeviceView.h"
#import "UIColor+DBJ.h"
#import "DBJOCHttp.h"
#import "DBJOCIPInfo.h"
#import <sys/utsname.h>
#import "UIDevice+DBJ.h"
#undef Screen_WIDTH
#define Screen_WIDTH   [[UIScreen mainScreen] bounds].size.width
#undef Screen_HEIGHT
#define Screen_HEIGHT  [[UIScreen mainScreen] bounds].size.height

static CGFloat defaultDBJScreenWidth = 414.0;

//static inline CGFloat tDBJRealFontSize(CGFloat defaultSize) {
//    CGFloat result = defaultSize;
//
//    if (defaultDBJScreenWidth != Screen_WIDTH) {
//        result =  Screen_WIDTH / defaultDBJScreenWidth * result;
//    }
//    return  result;
//
//}

static inline CGFloat tDBJRealLength(CGFloat defaultLength) {
    CGFloat result = defaultLength;
    if (defaultDBJScreenWidth != Screen_WIDTH) {
        result =  Screen_WIDTH / defaultDBJScreenWidth * result;
    }
    return  result;
}

#define tDBJRealFontSize( __defaultSize ) tDBJRealFontSize(__defaultSize)

#define tDBJRealLength( __defaultLength ) tDBJRealLength(__defaultLength)

@interface DBJOCDeviceView() <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * buttonClose;
@property (nonatomic, strong) UIButton * buttonCopy;
@property (nonatomic, strong) UIView * bgView;

@property (nonatomic, assign) BOOL isLoadingIp;
@property (nonatomic, strong) NSURLSessionTask * task;


@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * titleBottomLine;
@property (nonatomic, strong) UIView * tableViewBottomLine;
@property (nonatomic, strong) UIView * btnCenterLine;

@property (nonatomic,strong) NSString * deviceType;
@property (nonatomic, weak)UIViewController * vc;
@property (nonatomic, weak)DBJOCParameters * parameters;

@end

@implementation DBJOCDeviceView

- (id)initWithFrame:(CGRect)frame parameters:(DBJOCParameters *)parameters vc:(UIViewController *)vc {
    if (self = [super initWithFrame:frame]) {
        self.parameters = parameters;
        self.vc = vc;
        [self loadUI];
    }
    return  self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
}
- (void)viewFrameSet {
    
    if (Screen_WIDTH < Screen_HEIGHT) {
        _bgView.frame = CGRectMake(tDBJRealLength(40), Screen_HEIGHT/6, Screen_WIDTH - tDBJRealLength(40)*2,[self getBgViewheight]);
        self.tableView.scrollEnabled = NO;
    } else {
        self.tableView.scrollEnabled = YES;
        _bgView.frame = CGRectMake( tDBJRealLength(40), Screen_HEIGHT/6, Screen_WIDTH - tDBJRealLength(40)*2, Screen_HEIGHT*2/3);
    }
    
    _titleLabel.frame = CGRectMake( 0, 0,  _bgView.bounds.size.width, tDBJRealLength(50));
    
    _titleBottomLine.frame = CGRectMake( 0, 50.5,  _bgView.bounds.size.width, 0.5);
    _tableView.frame = CGRectMake(0,  CGRectGetMaxY(_titleBottomLine.frame), _bgView.bounds.size.width, _bgView.frame.size.height - tDBJRealLength(107));
    
    _tableViewBottomLine.frame = CGRectMake( 0, CGRectGetMaxY(_tableView.frame),  _bgView.bounds.size.width, 0.5);
    
    _buttonClose.frame = CGRectMake( 0, CGRectGetMaxY(_tableViewBottomLine.frame), _bgView.frame.size.width/2, tDBJRealLength(56));
    
    _btnCenterLine.frame = CGRectMake( CGRectGetMaxX(_buttonClose.frame),  CGRectGetMinY(_buttonClose.frame), 0.5, _buttonClose.frame.size.height);
    
    _buttonCopy.frame = CGRectMake (CGRectGetMaxX(_btnCenterLine.frame),  CGRectGetMaxY(_tableViewBottomLine.frame),  _bgView.frame.size.width/2 - 0.5, tDBJRealLength(56));
    
}
- (CGFloat)getBgViewheight {
    return  tDBJRealLength(50) + 7 * tDBJRealLength(50) + tDBJRealLength(70) + 1 + tDBJRealLength(56);
}
- (void)loadUI {
    
    self.deviceType = [DBJOCDeviceView getDeviceIdentifier];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    UIView * bgView = [UIView new];
    self.bgView = bgView;
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.clipsToBounds = true;
    self.bgView.layer.cornerRadius = 10;
    [self addSubview:self.bgView];
    
    [self getIPInfo];
    UILabel * titleLabel = [UILabel new];
    titleLabel.textColor =  [UIColor blackColor];
    
    titleLabel.text = @"设备信息";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
    
    UIView * titleBottomLine = [UIView new];
    titleBottomLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    
    [bgView addSubview:titleBottomLine];
    self.titleBottomLine = titleBottomLine;
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor whiteColor];
    [bgView addSubview:tableView];
    tableView.scrollEnabled = false;
    UIView * tableViewBottomLine = [UIView new];
    self.tableViewBottomLine = tableViewBottomLine;
    
    tableViewBottomLine.backgroundColor = titleBottomLine.backgroundColor;
    [bgView addSubview:tableViewBottomLine];
    
    
    UIButton * buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonClose = buttonClose;
    
    [buttonClose setTitle:@"关闭" forState:UIControlStateNormal];
    [bgView addSubview:buttonClose];
    [buttonClose addTarget:self action:@selector(buttonCloseAction) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonClose setTitleColor:[UIColor colorFromHex:0x333333] forState:UIControlStateNormal];
    
    UIView * btnCenterLine = [UIView new];
    self.btnCenterLine = btnCenterLine;
    btnCenterLine.backgroundColor = titleBottomLine.backgroundColor;
    [bgView addSubview:btnCenterLine];
    UIButton * buttonCopy = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonCopy = buttonCopy;
    [buttonCopy setTitle:@"复制" forState:UIControlStateNormal];
    [bgView addSubview:buttonCopy];
    [buttonCopy setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [buttonCopy addTarget:self action:@selector(buttonCopyAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self viewFrameSet];
}


- (void)getIPInfo {
    
    if (self.parameters.ip && self.parameters.ip.length > 0) {
        return;
    }
    
    _isLoadingIp = true;
    DEF_WEAKSELF
    _task = [DBJOCHttp getLocalIPInfoSuccess:^(id  _Nonnull model) {
        weakSelf.isLoadingIp = false;
        DBJOCIPInfo * info = (DBJOCIPInfo *) model;
        weakSelf.parameters.ip = info.query;
        if (weakSelf.tableView != nil) {
            NSIndexPath * index = [NSIndexPath indexPathForRow:4 inSection:0];
            [weakSelf.tableView  reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        }
    } fail:^(NSString * _Nonnull msg, NSError * _Nullable error) {
        weakSelf.isLoadingIp = false;
    }];
}
- (void)buttonCloseAction {
    
    [self dismissView];
    
}
- (void)buttonCopyAction {
    
    if (self.parameters.ip == nil) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"当前正在获取IP,请稍后..." message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:sure];
        [self.vc presentViewController:alert animated:true completion:nil];
        return;
    }
    NSString * deviceId = [UIDevice getDeviceId];
    NSMutableString * clipStr = [NSMutableString new];
    [clipStr appendFormat:@"会员帐号:%@\n",self.parameters.account];
    [clipStr appendFormat:@"手机型号:%@\n",self.deviceType];
    [clipStr appendFormat:@"设备号:%@\n",deviceId];
    [clipStr appendFormat:@"登入端口:%@\n",self.parameters.ipName];
    [clipStr appendFormat:@"登陆IP:%@\n",self.parameters.ip];
    [clipStr appendFormat:@"手机系统:%@\n",[UIDevice currentDevice].systemVersion];
    [clipStr appendFormat:@"APP版本:%@\n",self.parameters.appVersion];
    [UIPasteboard generalPasteboard].string = clipStr;
    [self dismissView];
}
- (void)dismissView {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    for (UITouch * touch in touches) {
        if (touch.view == self) {
            [self dismissView];
        }
    }
}
- (void)dealloc {
    
    if (self.task != nil) {
        [self.task cancel];
        self.task = nil;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 7) {
        return tDBJRealLength(50);
    }
    return tDBJRealLength(70);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 7) {
        static NSString * ipCellIdentifier = @"ipCellIdentifier";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ipCellIdentifier];
        if (!cell) {
            cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ipCellIdentifier];
            cell.textLabel.textColor = [UIColor colorFromHex:0xfc6d6d];
            cell.textLabel.numberOfLines = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text  =  @"点击复制按钮把信息复制给客服，或者截图后将他发送给客服";
        return cell;
    }

    static NSString * nomalIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:nomalIdentifier];
    if (!cell) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nomalIdentifier];
        cell.textLabel.textColor = [UIColor colorFromHex:0x8e8e8e];
        cell.detailTextLabel.textColor = [UIColor colorFromHex:0x646464];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIActivityIndicatorView * loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [cell addSubview:loadingView];
        loadingView.frame = CGRectMake(_bgView.frame.size.width - 20 - 20, 15, 20, 20);
        loadingView.hidesWhenStopped = true;
        loadingView.tag = 10001;
    }
    
    UIActivityIndicatorView * loadingView = [cell viewWithTag:10001];
    [cell addSubview:loadingView];
    loadingView.frame = CGRectMake(_bgView.frame.size.width - 20 - 20, 15, 20, 20);
    

    NSString * title = @"";
    NSString * content = @"";

    switch (indexPath.row ){
    case 0:
        {
            title = @"会员账户";
            content = self.parameters.account;
            
        }
            break;
    case 1:
        {
            title = @"手机型号";
            content = self.deviceType;
        }
            break;
    case 2:
            title = @"设备号";
            if (self.parameters.deviceId && self.parameters.deviceId.length > 0) {
                content = self.parameters.deviceId;
            } else {
                content = [UIDevice getDeviceId];
                self.parameters.deviceId = content;
            }
            break;
    case 3:
        {
            title = @"登陆端口";
            content = self.parameters.ipName;
        }
            break;
    case 4:
            title = @"登陆IP";
            break;
    case 5:
        {
            title = @"手机系统";
            content = [UIDevice currentDevice].systemVersion;
        }
            break;
    case 6:
        {
            title = @"APP版本";
            content = self.parameters.appVersion;
        }
            break;
        default: break;
    }
    
    if (indexPath.row == 4) {
        if (self.isLoadingIp) {
            [loadingView startAnimating];
            
        } else if (self.parameters.ip && self.parameters.ip.length > 0) {
            content = self.parameters.ip;
            [loadingView stopAnimating];
        }
    } else {
        [loadingView stopAnimating];
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = content;
    return cell;
}


+(void) showMenuWithParameters:(DBJOCParameters*)parameters vc: (UIViewController *)vc {
    
    DBJOCDeviceView * view = [[DBJOCDeviceView alloc]initWithFrame:[UIScreen mainScreen].bounds parameters:parameters vc:vc];
    view.alpha = 0;
    
    UIWindow * window = [UIApplication sharedApplication].windows.firstObject;
    
    if (window == nil) {
        if (@available(iOS 13.0, *)) {
            NSSet<UIScene *> * scenes = [UIApplication sharedApplication].connectedScenes;
            for (id scene in scenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]){
                    window = ((UIWindowScene *)scene).windows.firstObject;
                    break;
                }
            }
        }
    }
    if (window == nil) {
        [vc.view addSubview:view];
    } else {
        [window addSubview:view];
    }
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [UIView animateWithDuration:0.4 animations:^{
        view.alpha = 1;
    }];
}





// 需要#import "sys/utsname.h"
+ (NSString *)getDeviceIdentifier {
    struct utsname systemInfo;
    uname(&systemInfo);
    // 获取设备标识Identifier
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS MAX";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    if ([platform isEqualToString:@"iPhone12,8"]) return @"iPhone SE (2nd generation)";
    if ([platform isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
    if ([platform isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
    if ([platform isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
    if ([platform isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";
    
    if ([platform isEqualToString:@"iPhone14,4"]) return @"iPhone 13 mini";
    if ([platform isEqualToString:@"iPhone14,5"]) return @"iiPhone_13";
    if ([platform isEqualToString:@"iPhone14,2"]) return @"iPhone_13_Pro";
    if ([platform isEqualToString:@"iPhone14,3"]) return @"iPhone_13_Pro_Max";
    if ([platform isEqualToString:@"iPhone14,6"]) return @"iPhone SE (3rd generation)";
    // iPod
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1";
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2";
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3";
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4";
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5";
    if ([platform isEqualToString:@"iPod7,1"])  return @"iPod Touch 6";
    if ([platform isEqualToString:@"iPod9,1"])  return @"iPod Touch 7";
    
    // iPad
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1";
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,7"])  return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,8"])  return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,9"])  return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad5,1"])  return @"iPad mini 4";
    if ([platform isEqualToString:@"iPad5,2"])  return @"iPad mini 4";
    if ([platform isEqualToString:@"iPad5,3"])  return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])  return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])  return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,4"])  return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,7"])  return @"iPad Pro (12.9-inch)";
    if ([platform isEqualToString:@"iPad6,8"])  return @"iPad Pro (12.9-inch)";
    if ([platform isEqualToString:@"iPad6,11"])  return @"iPad 5";
    if ([platform isEqualToString:@"iPad6,12"])  return @"iPad 5";
    if ([platform isEqualToString:@"iPad7,1"])  return @"iPad Pro 2(12.9-inch)";
    if ([platform isEqualToString:@"iPad7,2"])  return @"iPad Pro 2(12.9-inch)";
    if ([platform isEqualToString:@"iPad7,3"])  return @"iPad Pro (10.5-inch)";
    if ([platform isEqualToString:@"iPad7,4"])  return @"iPad Pro (10.5-inch)";
    if ([platform isEqualToString:@"iPad7,5"])  return @"iPad 6";
    if ([platform isEqualToString:@"iPad7,6"])  return @"iPad 6";
    if ([platform isEqualToString:@"iPad7,11"])  return @"iPad 7";
    if ([platform isEqualToString:@"iPad7,12"])  return @"iPad 7";
    if ([platform isEqualToString:@"iPad8,1"])  return @"iPad Pro (11-inch) ";
    if ([platform isEqualToString:@"iPad8,2"])  return @"iPad Pro (11-inch) ";
    if ([platform isEqualToString:@"iPad8,3"])  return @"iPad Pro (11-inch) ";
    if ([platform isEqualToString:@"iPad8,4"])  return @"iPad Pro (11-inch) ";
    if ([platform isEqualToString:@"iPad8,5"])  return @"iPad Pro 3 (12.9-inch) ";
    if ([platform isEqualToString:@"iPad8,6"])  return @"iPad Pro 3 (12.9-inch) ";
    if ([platform isEqualToString:@"iPad8,7"])  return @"iPad Pro 3 (12.9-inch) ";
    if ([platform isEqualToString:@"iPad8,8"])  return @"iPad Pro 3 (12.9-inch) ";
    if ([platform isEqualToString:@"iPad11,1"])  return @"iPad mini 5";
    if ([platform isEqualToString:@"iPad11,2"])  return @"iPad mini 5";
    if ([platform isEqualToString:@"iPad11,3"])  return @"iPad Air 3";
    if ([platform isEqualToString:@"iPad11,4"])  return @"iPad Air 3";
    
    // 其他
    if ([platform isEqualToString:@"i386"])   return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])  return @"iPhone Simulator";
    
    return platform;
}
@end

