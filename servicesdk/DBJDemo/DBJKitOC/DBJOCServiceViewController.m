//
//  DBJOCServiceViewController.m
//  DBJOCKit
//
//  Created by funny on 16/06/2022.
//

#import "DBJOCServiceViewController.h"
#import <WebKit/WebKit.h>
#import "DBJOCHUDProgress.h"
#import "WebViewJavascriptBridge.h"
#import "UIColor+DBJ.h"
#import "UIView+DBJ.h"
#import "DBJOCHttp.h"
#import "DBJOCUserInfo.h"
#import "DBJOCDeviceView.h"

@interface DBJOCServiceViewController () {
    CGFloat webViewMarge;
}
@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, strong) WebViewJavascriptBridge * bridge;
@property (nonatomic, strong) NSString * param;
@property (nonatomic, strong) NSString * formal;
@property (nonatomic, strong) NSString * merchant;
@property (nonatomic, strong) NSString * service_type;

@property (nonatomic, strong) DBJOCHUDProgress * hudView;

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) CAGradientLayer * gradientLayer;

@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) UINavigationBar * navBar;
 /*
 private var observation: NSKeyValueObservation?
 */
@property(nonatomic,strong)DBJOCParameters * parameters;

@property(nonatomic, copy) NSString * orderInfo;
@end

@implementation DBJOCServiceViewController

- (void)setParameters:(DBJOCParameters *)parameters {
    if (_parameters != parameters) {
        _parameters = parameters;
    }
    self.formal = parameters.formal;
    self.merchant = parameters.merchant;
    self.orderInfo = parameters.orderInfo;
    self.param = [NSString stringWithFormat:@"?barShow=false&serviceType=%@&merchant=%@&accout=%@",parameters.serviceType, parameters.merchant, parameters.account];
    self.service_type = parameters.serviceType;
}

- (id)initWithParameters:(DBJOCParameters *)parameters {
    if (self = [super init]) {
        self.willcloseNoticeName = @"DBJOC_kit_service_close_notice";
        self.endCloseNoticeName = @"DBJOC_kit_service_will_notice";
        self.parameters = parameters;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self viewFrameSet];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewFrameSet {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat statusBarFrame = [self getStatusHeight];
    _backgroundView.frame = CGRectMake(0, 0, width, statusBarFrame + 44 + webViewMarge);
    _navBar.frame = CGRectMake(0, statusBarFrame, width, 44);
    _gradientLayer.frame = CGRectMake(0, 0, _backgroundView.bounds.size.width, _gradientLayer.frame.size.height);
    _webView.frame = CGRectMake(0, _backgroundView.bounds.size.height - webViewMarge, width, height - _backgroundView.frame.size.height + webViewMarge);
    [_webView changePath:webViewMarge roundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    _hudView.center = CGPointMake(width*0.5, (height - statusBarFrame) * 0.5 );
}


- (void)viewDidLoad {
    [super viewDidLoad];
    webViewMarge = 10;
    CGFloat statusBarFrame = [self getStatusHeight];
    
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarFrame + 44 + webViewMarge)];
    self.gradientLayer = [[CAGradientLayer alloc]init];
    _gradientLayer.locations = @[@0.0,@1.0];
    _gradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , webViewMarge + 48 + 44);
    
    _gradientLayer.colors = @[(__bridge id)[UIColor colorFromHex:0x184cdd].CGColor, (__bridge id)[UIColor colorFromHex:0x5443b0].CGColor];
    
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(1, 0);
    [_backgroundView.layer addSublayer:_gradientLayer];
    
    
    self.navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, statusBarFrame, [UIScreen mainScreen].bounds.size.width, 44)];
    [_backgroundView addSubview:self.navBar];
    _navBar.shadowImage = [UIImage new];
//    UIBarMetrics
    [_navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    _navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.backgroundView];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.headImageView = [[UIImageView alloc]initWithImage:[self imageData:@"service_avatar"]];
    _headImageView.frame = CGRectMake(0, 0, 34, 34);
    _headImageView.layer.cornerRadius = _headImageView.frame.size.width/2;
    _headImageView.layer.masksToBounds = true;
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView.frame.size.width + 10, 0, 100, 44)];
    _nameLabel.textColor = [UIColor whiteColor];
    
    UIView * customViewHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    [customViewHeadView addSubview:_headImageView];
    _headImageView.center = CGPointMake(_headImageView.frame.size.width/2, 22);
    [customViewHeadView addSubview:_nameLabel];
    
    UIBarButtonItem * backBar = [[UIBarButtonItem alloc] initWithCustomView:customViewHeadView];
    
    UINavigationItem * navItem = [[UINavigationItem alloc]init];
    navItem.leftBarButtonItem = backBar;
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithImage:[self imageData:@"back"] style:0 target:self action:@selector(btnCloseAction)];
  
    CGFloat lineSpacing  = 10;
    
    UIView * deviceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  82 + lineSpacing + 1, 44)];
    
    UIButton * deviceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    deviceBtn.frame = CGRectMake(0, 0, 80, 44);
    [deviceBtn setTitle:@"设备信息" forState:UIControlStateNormal];
    [deviceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deviceBtn addTarget:self action:@selector(btnDeviceID) forControlEvents:UIControlEventTouchUpInside];
    deviceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [deviceView addSubview:deviceBtn];
    CGFloat lineHeight = 18.0;
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(deviceBtn.frame) + lineHeight - 8, (44.0 - lineHeight) * 0.5, 1, lineHeight)];
    lineView.backgroundColor = [UIColor whiteColor];
    [deviceView addSubview:lineView];
    
    
    _nameLabel.font = deviceBtn.titleLabel.font;
    
    
    UIBarButtonItem * deviceBar = [[UIBarButtonItem alloc]initWithCustomView:deviceView];
//    UIBarButtonItem * soundBar = [[UIBarButtonItem alloc] initWithImage:[self imageData:@"sound"] style:0 target:self action:@selector(btnSoundAction)];
    
    navItem.rightBarButtonItems = @[rightBar,deviceBar];
    _navBar.tintColor = [UIColor whiteColor];
    _navBar.items = @[navItem];
    
    self.hudView = [[DBJOCHUDProgress alloc]initWithFrame:CGRectMake(0, 0, 90, 100)];
    [self.view addSubview:_hudView];
    [_hudView starAnimation];
    _hudView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, ([UIScreen mainScreen].bounds.size.height - statusBarFrame)/2);
    
    WKWebViewConfiguration * config = [WKWebViewConfiguration new];
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, _backgroundView.bounds.size.height - webViewMarge, _backgroundView.frame.size.width, [UIScreen mainScreen].bounds.size.height - _backgroundView.frame.size.height + webViewMarge) configuration:config];
    [self.view insertSubview:_webView belowSubview:_hudView];
    
    _webView.backgroundColor  = [UIColor whiteColor];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    
    DEF_WEAKSELF
    [self.bridge registerHandler:@"setKefuInfo" handler:^(id  _Nonnull data, WVJBResponseCallback  _Nonnull responseCallback) {
        
        if (data != nil) {
//            NSString * url = [data objectForKey:@"imgURL"];
            NSString * name = [data objectForKey:@"name"];
//            [weakSelf.headImageView loadUrlImage:url];
            if (name && name.length > 0) {
                weakSelf.nameLabel.text = name;
            } else {
                weakSelf.nameLabel.text = @"客服";
            }
        }
        
    }];
    
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    [_webView roundedRectWith:webViewMarge byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.scrollView.scrollEnabled = false;
    
    [DBJOCHttp getServiceURL:self.formal merchant:self.merchant service_type:self.service_type success:^(id  _Nonnull urlStr) {
        NSString * url = (NSString *)urlStr;
        if([url hasPrefix:@"http"]) {
            NSString * url2 = [url stringByAppendingString:weakSelf.param];
            NSString  *newUrlString = [url2 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            newUrlString = [newUrlString stringByAppendingFormat:@"&orderInfo=%@",self.orderInfo];
            NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:newUrlString]];
            [weakSelf.webView loadRequest:request];
        }
    } fail:^(NSString * _Nonnull msg, NSError * _Nullable error) {
        [weakSelf.hudView stopAnimation];
    }];
}

- (void)btnCloseAction {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.willcloseNoticeName object:nil];
    [self dismissViewControllerAnimated:true completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:self.endCloseNoticeName object:nil];
    }];
}
- (void)btnDeviceID {
    [DBJOCDeviceView showMenuWithParameters:self.parameters vc:self];
}
- (void)btnSoundAction {
    [self.bridge callHandler:@"isSwitchVoice"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSNumber * data = [change objectForKey:NSKeyValueChangeNewKey];
    if (data != nil) {
        
        CGFloat progress = data.floatValue;
        if (progress >= 1) {
            self.webView.scrollView.scrollEnabled = true;
            [self.hudView stopAnimation];
        }
    }
}
- (CGFloat)getStatusHeight {
    CGFloat topHeight = 20;
    
    CGFloat deviceHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    if (@available(iOS 11.0, *)) {
        topHeight = self.view.safeAreaInsets.top;
    } else {
        topHeight = deviceHeight > 0 ? deviceHeight : topHeight;
    }
    return topHeight;
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
- (UIImage *)imageData:(NSString *)name {
    NSBundle * boundle = [NSBundle bundleForClass:[DBJOCHUDProgress class]];
    NSString * imageName =  [@"DJBOCKit" stringByAppendingString:name];
    UIImage * image = [UIImage imageNamed:imageName inBundle:boundle compatibleWithTraitCollection:nil];
    return image;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
@end
