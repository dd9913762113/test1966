//
//  DBJServiceViewController.swift
//  DBJKit
//
//  Created by funny on 17/05/2022.
//

import Foundation
import UIKit
import WebKit
import JavaScriptCore


// MARK: - DBJServiceViewController

final class DBJServiceViewController: UIViewController {

    var webView: WKWebView!
    var bridge: WebViewJavascriptBridge!
    var param: String = ""
    var formal: String!
    var merchant: String!
    var orderInfo: String = ""
    var service_type:String!
    private var hudView:DBJHUDProgress!
    
    
    
    private var observation: NSKeyValueObservation?
    
    private var headImageView: UIImageView!
    private var nameLabel: UILabel!
    private var gradientLayer: CAGradientLayer!
    private var backgroundView: UIView!
    let webViewMarge:CGFloat = 10
    
    private var navBar:UINavigationBar!
    private let infoData: DBJTool.DBJParameters!
    
    
    init(parameters: DBJTool.DBJParameters) {
        self.formal = parameters.formal
        self.merchant = parameters.merchant
        self.service_type = parameters.serviceType
        infoData = parameters
        self.orderInfo = parameters.orderInfo
        self.param += "?barShow=false"
        self.param += "&tutorial=\(parameters.tutorial)"
        self.param += "&serviceType=\(parameters.serviceType)"
        self.param += "&merchant=\(parameters.merchant)"
        self.param += "&account=\(parameters.account)"
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewFrameSet()
        print("\(UIScreen.main.bounds.height)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
    }
    
    func loadUI() {
        let topHeight = self.getStatusHeight()
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: topHeight + webViewMarge))
        gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: webViewMarge + 48 + 44)
        gradientLayer.colors = [UIColor.DBJGromHexColor(0x184cdd, alpha: 1).cgColor, UIColor.DBJGromHexColor(0x5443b0, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        backgroundView.layer.addSublayer(gradientLayer)
        navBar = UINavigationBar(frame: CGRect(x: 0, y: topHeight, width: UIScreen.main.bounds.width, height: 44))
        backgroundView.addSubview(navBar)
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(backgroundView)
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        headImageView = UIImageView(image: imageData(imageName: "service_avatar"))
        headImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        headImageView.layer.cornerRadius = headImageView.frame.size.width/2
        headImageView.layer.masksToBounds = true
        nameLabel = UILabel(frame: CGRect(x: headImageView.frame.width + 10, y: 0, width: 100, height: 44))
        nameLabel.textColor = UIColor.white
        
//        nameLabel.font =
        
        
        
        let customViewHeadView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
        customViewHeadView.addSubview(headImageView)
        headImageView.center = CGPoint(x: headImageView.frame.width/2, y: 22)
        customViewHeadView.addSubview(nameLabel)
        let backBar = UIBarButtonItem(customView: customViewHeadView)
    
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = backBar
        
        let rightBar = UIBarButtonItem(image: imageData(imageName: "back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(btnCloseAction))
        
        let lineSpacing: CGFloat = 10

        let deviceView = UIView(frame: CGRect(x: 0, y: 0, width: 82 + lineSpacing + 1, height: 44))
        let deviceBtn = UIButton(type: .custom)
        deviceBtn.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        deviceBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        deviceBtn.setTitle("设备信息", for: UIControl.State.normal)
        
        deviceBtn.titleLabel?.font = .systemFont(ofSize: 14)
        deviceView.addSubview(deviceBtn)


        deviceBtn.addTarget(self, action: #selector(btnDeviceID), for: UIControl.Event.touchUpInside)
        
        let lineHeight: CGFloat = 18.0
        let lineView = UIView(frame: CGRect(x: deviceBtn.frame.maxX + lineSpacing, y: (44.0 - lineHeight) * 0.5, width: 1, height: lineHeight))
        lineView.backgroundColor = UIColor.white
        deviceView.addSubview(lineView)
        
        nameLabel.font = deviceBtn.titleLabel?.font
        
        let deviceBar = UIBarButtonItem(customView: deviceView)

//        let soundBar = UIBarButtonItem(image: imageData(imageName: "sound"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(btnSoundAction))
        
        navItem.rightBarButtonItems = [rightBar,deviceBar]
    
        navBar.tintColor = UIColor.white
        navBar.items = [navItem]
        hudView = DBJHUDProgress(frame: CGRect(x: 0, y: 0, width: 90, height: 100))
        view.addSubview(hudView)
        hudView.starAnimation()
        hudView.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y: ( UIScreen.main.bounds.size.height - topHeight) * 0.5)
        
        let config = WKWebViewConfiguration()
        config.mediaTypesRequiringUserActionForPlayback = .all
        config.mediaTypesRequiringUserActionForPlayback = []
        config.allowsInlineMediaPlayback = true
        
        let webView = WKWebView(frame: CGRect(x: 0, y: backgroundView.bounds.size.height - webViewMarge, width: backgroundView.frame.width, height: UIScreen.main.bounds.height - backgroundView.frame.height + webViewMarge), configuration: config)
        webView.backgroundColor = UIColor.white
        view.insertSubview(webView, belowSubview: hudView)
        
        bridge = WebViewJavascriptBridge(webView: webView)
        
        bridge.register(handlerName: "setKefuInfo") {[weak self] (parameters, callback) in
            guard let self = self else { return }
            if let parameters = parameters {
                
//                let imgURL:String? = parameters["imgURL"] as? String
//                if let imageUrl = imgURL {
//                    self.headImageView.loadUrlImage(imageUrl: imageUrl)
//                }
                if let name = parameters["name"] as? String {
                    self.nameLabel.text = name
                } else {
                    self.nameLabel.text = "客服"
                }
            }
        }
   
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.uiDelegate = self
        webView.navigationDelegate = self
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        webView.filletedCorner(CGSize(width: webViewMarge, height: webViewMarge), UIRectCorner(rawValue: (UIRectCorner.topLeft.rawValue)|(UIRectCorner.topRight.rawValue)))
        webView.scrollView.isScrollEnabled = false

        self.webView = webView
        
        observation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] _, _ in
            if let weakSelf = self {
                let progress = Float(weakSelf.webView.estimatedProgress)

                if progress >= 1 {
                    weakSelf.webView.scrollView.isScrollEnabled = true
                    weakSelf.hudView.stopAnimation()
                }
            }
        }
        ServiceTool.getServiceURL(formal: formal, merchant: merchant,service_type:service_type) {[weak self] url, _, _ in
            if let weakSelf = self, let url = url,url.hasPrefix("http") {
                weakSelf.getpersonData(url: url)
                let url2 = url + weakSelf.param
                let url3 = url2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if let url3 = url3 {
                    let url4 = url3 + "&orderInfo=\(weakSelf.orderInfo)"
                    let myURL = URL.init(string: url4)
                    if let myUrl = myURL {
                        weakSelf.webView.load(URLRequest(url: myUrl))
                    }
                }
            }
        }
    }
   
    private func getpersonData(url: String) {
        ServiceTool.getPersionInfo(webUrl: url) { [weak self] data, _ in
            if let weakSelf = self {
                if let info = data {
                    weakSelf.nameLabel.text = info.name
                    if info.avatar.count > 0 {
                        weakSelf.headImageView.loadUrlImage(imageUrl: info.avatar)
                    }
                    return
                }
//                weakSelf.headImageView.loadUrlImage(imageUrl:"https://img0.baidu.com/it/u=962361882,2281204904&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500")
                weakSelf.nameLabel.text = ""
            }
        }
    }
    
    func viewFrameSet() {
        var topHieght: CGFloat = self.getStatusHeight()
        backgroundView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: topHieght + 44 + webViewMarge)
        navBar.frame =  CGRect(x: 0, y: topHieght, width: UIScreen.main.bounds.width, height: 44)
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: backgroundView.bounds.width, height: gradientLayer.frame.height)
    
        webView.frame = CGRect(x: 0, y: backgroundView.bounds.size.height - webViewMarge, width: backgroundView.frame.width, height: UIScreen.main.bounds.height - backgroundView.frame.height + webViewMarge )
        webView.changePath(CGSize(width: webViewMarge, height: webViewMarge), UIRectCorner(rawValue: (UIRectCorner.topLeft.rawValue)|(UIRectCorner.topRight.rawValue)))
        
        hudView.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y: ( UIScreen.main.bounds.size.height - topHieght) * 0.5)
    }
    
    func getStatusHeight() -> CGFloat {
        var topHieght: CGFloat = 20
        let deviceStatus = UIDevice.dbjNowStatusBarHeight()
        if #available(iOS 11.0, *) {
            topHieght = view.safeAreaInsets.top
        } else {
            topHieght = deviceStatus > 0 ? deviceStatus: topHieght
        }
        return topHieght
    }
//
//    func getSafeAreaBottom() -> CGFloat {
//        if #available(iOS 11.0, *) {
//            return view.safeAreaInsets.bottom
//        } else {
//            return 0
//        }
//    }
    
    

    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "dbjQuit")
        observation?.invalidate()
        observation = nil
    }
    
    @objc
    func btnDeviceID() {
        DBJDeviceView.showMenu(parameters: self.infoData,self)
    }

    @objc
    func btnSoundAction() {
        bridge.call(handlerName: "isSwitchVoice");
    }
    
    @objc
    func btnCloseAction() {
        NotificationCenter.default.post(name: DBJTool.DBJKitServiceWillCloseNotice, object: nil)
        dismiss(animated: true) {
            NotificationCenter.default.post(name: DBJTool.DBJKitServiceEndCloseNotice, object: nil)
        }
    }
    
    func imageData(imageName: String) -> UIImage? {
        let boundle = Bundle(for: DBJServiceViewController.self)
        return UIImage(named: "DJBKit\(imageName)", in: boundle, compatibleWith: nil)
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
}

// MARK: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler

extension DBJServiceViewController: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "dbjQuit" {
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - WeakScriptMessageDelegate

class WeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    weak var delegate: WKScriptMessageHandler?
    init(delegate: WKScriptMessageHandler) {
        super.init()
        self.delegate = delegate
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }

    deinit {
        self.delegate = nil
    }
}


class DBJHUDProgress: UIView {
    
    var titleLabel: UILabel!
    var activityIndicator: UIImageView!
    var animator: UIViewPropertyAnimator?
//    var observation: NSKeyValueObservation?
    var backgroundView:UIView!
    
    var isStopAnimation:Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
//        self.isHidden = true
        backgroundView = UIView(frame: self.bounds)
        addSubview(backgroundView)
        backgroundView.corner(4)
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        activityIndicator = UIImageView(frame: CGRect(x: 0, y: 10, width: (self.frame.width - 15) / 2.0, height: (self.frame.width - 15) / 2.0))
        backgroundView.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: self.frame.width/2, y: 15 + (self.frame.width - 15)/4.0)
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let boundle = Bundle(for: DBJHUDProgress.self)
        
        let image = UIImage(named: "DJBKitload", in: boundle, compatibleWith: nil)
    
        activityIndicator.image = image
        
        let margin:CGFloat = 10
        titleLabel = UILabel(frame: CGRect(x: margin , y: activityIndicator.frame.maxY + 5, width: self.frame.width - margin*2, height: 30))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.text = "正在加载"
        titleLabel.textColor = UIColor.white
        backgroundView.addSubview(titleLabel)
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.backgroundColor = UIColor.clear
        backgroundView.backgroundColor = UIColor.DBJGromHexColor(0x000000, alpha: 0.55)
        

    }
    
    public func starAnimation() {
        self.backgroundView.alpha = 0
        self.isHidden = false
        self.isStopAnimation = false
        self.rotate()
        UIView.animate(withDuration: 0.2) {
            self.backgroundView.alpha = 1
        } completion: { isFinsh in
            
        }
    }
    public func stopAnimation() {
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundView.alpha = 0
        } completion: { isFinsh in
            self.isHidden = true
            self.isStopAnimation = true
            self.animator?.startAnimation()
        }
    }
    
    func rotate() {
        let animator = UIViewPropertyAnimator(duration: 2.5, curve: .linear) {[weak self] in
            guard let weakSelf = self else { return }
            weakSelf.activityIndicator.transform = CGAffineTransform(rotationAngle: .pi)
        }
        animator.addAnimations {[weak self] in
            guard let weakSelf = self else { return }
            weakSelf.activityIndicator.transform = weakSelf.activityIndicator.transform.rotated(by: .pi)
        }
        animator.addCompletion {[weak self] (_) in
            guard let weakSelf = self else { return }
            if !weakSelf.isHidden {
                weakSelf.rotate()
            }
        }
        animator.startAnimation()
        
        self.animator = animator
    }
    
    deinit {
        self.isStopAnimation = true
        self.animator?.stopAnimation(true)
    }
    
    
}
