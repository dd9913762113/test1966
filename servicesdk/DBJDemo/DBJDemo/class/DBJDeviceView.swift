//
//  DeviceViewController.swift
//  DBJDemo
//
//  Created by funny on 13/06/2022.
//
import UIKit

// 设计宽度
let defaultDBJScreenWidth: CGFloat = 414.0

let dbjScreen_width = UIScreen.main.bounds.width
let dbjScreen_height = UIScreen.main.bounds.height

/// 真实字体大小
/// - Parameter defaultSize: 设计大小
/// - Returns: 返回实际大小
func tDBJRealFontSize(_ defaultSize: CGFloat) -> CGFloat {
    var result: CGFloat = defaultSize
    let width = CGFloat.minimum(dbjScreen_width, dbjScreen_height)
    if defaultDBJScreenWidth != width {
        result =  width / defaultDBJScreenWidth * result
    }
    return ceil(result)
}

/// 真实长度
/// - Parameter defaultLength: 设计宽度
/// - Returns: 缩放后的大小
func tDBJRealLength(_ defaultLength: CGFloat) -> CGFloat {
    var result: CGFloat = defaultLength
    
    let width = CGFloat.minimum(dbjScreen_width, dbjScreen_height)
    
    if defaultDBJScreenWidth != width {
        result =  width / defaultDBJScreenWidth * result
    }
    return ceil(result)
}

public final class DBJDeviceView: UIView {
    
    weak var viewController: UIViewController!
    var tableView: UITableView!
    var buttonClose: UIButton!
    var buttonCopy: UIButton!
    var bgView: UIView!
    var parameters: DBJTool.DBJParameters!
    
    var isLoadingIp: Bool = false
    private var task: URLSessionDataTask?
    
    init(frame: CGRect,parameters: DBJTool.DBJParameters) {
        self.parameters = parameters
        self.parameters.ip = DBJIPINFO
        super.init(frame: frame)
        loadUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        viewFrameSet()
    }
    
    private func viewFrameSet(){
        if UIScreen.main.bounds.width < UIScreen.main.bounds.height {
            bgView.frame = CGRect(x: tDBJRealLength(40), y: UIScreen.main.bounds.height/6, width: UIScreen.main.bounds.width - tDBJRealLength(40)*2, height: self.getBgViewheight())
            self.tableView.isScrollEnabled = false
        } else {
            self.tableView.isScrollEnabled = true
            bgView.frame = CGRect(x: tDBJRealLength(40), y: UIScreen.main.bounds.height/6, width: UIScreen.main.bounds.width - tDBJRealLength(40)*2, height: UIScreen.main.bounds.height*2/3)
        }
        titleLabel.frame = CGRect(x: 0, y: 0, width: bgView.bounds.width, height: tDBJRealLength(50))
        titleBottomLine.frame = CGRect(x: 0, y: 50.5, width: bgView.bounds.width, height: 0.5)
        tableView.frame = CGRect(x: 0, y: titleBottomLine.frame.maxY, width: bgView.bounds.width, height: bgView.frame.height - tDBJRealLength(107))
        
        tableViewBottomLine.frame = CGRect(x: 0, y: tableView.frame.maxY, width: bgView.bounds.width, height: 0.5)
        buttonClose.frame = CGRect(x: 0, y: tableViewBottomLine.frame.maxY, width: bgView.frame.width/2, height: tDBJRealLength(56))
        btnCenterLine.frame = CGRect(x: buttonClose.frame.maxX, y: buttonClose.frame.minY, width: 0.5, height: buttonClose.frame.height)
        buttonCopy.frame = CGRect(x: btnCenterLine.frame.maxX, y: tableViewBottomLine.frame.maxY, width: bgView.frame.width/2-0.5, height: tDBJRealLength(56))
        
    }
    
    private var titleLabel: UILabel!
    private var titleBottomLine: UIView!
    private var tableViewBottomLine: UIView!
    
    private var btnCenterLine: UIView!
    
    func getBgViewheight() -> CGFloat {
        
        
        return tDBJRealLength(50) + 7 * tDBJRealLength(50) + tDBJRealLength(70) + 1 + tDBJRealLength(56)
    }
    
    func loadUI() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        bgView = UIView()
        self.getIPInfo()
        bgView.backgroundColor = UIColor.white
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 10
        self.addSubview(bgView)

        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.text = "设备信息"
        titleLabel.textAlignment = .center
        titleLabel?.font = .systemFont(ofSize: 19)

        bgView.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 0, y: 0, width: bgView.bounds.width, height: tDBJRealLength(50))
        
        titleBottomLine = UIView()
        titleBottomLine.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        bgView.addSubview(titleBottomLine)
        titleBottomLine.frame = CGRect(x: 0, y: 50.5, width: bgView.bounds.width, height: 0.5)
        
        
        tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.white
        bgView.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: titleBottomLine.frame.maxY, width: bgView.bounds.width, height: bgView.frame.height - tDBJRealLength(107))
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableViewBottomLine = UIView()
        tableViewBottomLine.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        bgView.addSubview(tableViewBottomLine)
        tableViewBottomLine.frame = CGRect(x: 0, y: tableView.frame.maxY+1, width: bgView.bounds.width, height: 0.5)
        
        buttonClose = UIButton(frame: CGRect(x: 0, y: tableViewBottomLine.frame.maxY, width: bgView.frame.width/2, height: tDBJRealLength(56)))
        buttonClose.setTitle("关闭", for: UIControl.State.normal)
        buttonClose.setTitleColor(UIColor.DBJGromHexColor(0x333333, alpha: 1), for: UIControl.State.normal)
        bgView.addSubview(buttonClose)
        
        buttonClose.addTarget(self, action: #selector(buttonCloseAction), for: UIControl.Event.touchUpInside)
        
        btnCenterLine = UIView()
        btnCenterLine.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        bgView.addSubview(btnCenterLine)
        btnCenterLine.frame = CGRect(x: buttonClose.frame.maxX, y: buttonClose.frame.minY, width: 0.5, height: buttonClose.frame.height)
        
        
        buttonCopy = UIButton(frame: CGRect(x: btnCenterLine.frame.maxX, y: tableViewBottomLine.frame.maxY, width: bgView.frame.width/2-0.5, height: tDBJRealLength(56)))
        buttonCopy.setTitle("复制", for: UIControl.State.normal)
        buttonCopy.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
        bgView.addSubview(buttonCopy)
        buttonCopy.addTarget(self, action: #selector(buttonCopyAction), for: UIControl.Event.touchUpInside)
    }
   
    @objc
    func buttonCloseAction() {
        self.dismissView()
    }
    @objc
    func buttonCopyAction() {
        
        if self.parameters.ip == nil {
            let alert = UIAlertController(title: "当前正在获取IP,请稍后...", message: nil, preferredStyle: UIAlertController.Style.alert)
            let sure = UIAlertAction.init(title: "确定", style: UIAlertAction.Style.cancel)
            alert.addAction(sure)
            self.viewController.present(alert, animated: true)
            return
        }
        let deviceId = self.parameters.deviceId ?? UIDevice.getDeviceUUID()
        var clipStr = "会员帐号:\(self.parameters.account)\n"
        clipStr += "手机型号:\(UIDevice.dbjModelName)\n"
        clipStr += "设备号:\(deviceId)\n"
        clipStr += "登入端口:\(self.parameters.ipName)\n"
        clipStr += "登陆IP:\(self.parameters.ip!)\n"
        clipStr += "手机系统: iOS \(UIDevice.current.systemVersion)\n"
        clipStr += "APP版本:\(self.parameters.appVersion)"
        UIPasteboard.general.string = clipStr
        self.showToast(text: " 复制成功 ")
        self.dismissView(1.5)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.view == self {
                self.dismissView()
            }
        }
    }
    
    func dismissView(_ delay: Double = 0) {
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2,delay: delay) {
            self.alpha = 0
        }completion: { _ in
            self.removeFromSuperview()
        }
    }
    static func showMenu(parameters: DBJTool.DBJParameters,_ vc: UIViewController) {
        
        let view = DBJDeviceView(frame: UIScreen.main.bounds,parameters: parameters)
        view.viewController = vc
        view.alpha = 0
        
        
        var window = UIApplication.shared.windows.first
        
        if (window == nil) {
            
            if #available(iOS 13.0, *) {
                let scene = UIApplication.shared.connectedScenes.first
                guard let windowScene = scene as? UIWindowScene else {
                    return;
                }
                guard let windowTemp = windowScene.windows.first else {
                    return
                }
                window = windowTemp;
            }
        }
        if window == nil {
            vc.view.addSubview(view)
        } else {
            window?.addSubview(view)
        }
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        UIView.animate(withDuration: 0.4) {
            view.alpha = 1
        }
    }
    
    func getIPInfo() {
        
        if DBJIPINFO != nil {
            return
        }
        isLoadingIp = true
        task = ServiceTool.getLocalIPInfo {[weak self] ip, error in
            if let weakSelf = self {
                weakSelf.isLoadingIp = false
                weakSelf.parameters.ip = ip
                if weakSelf.tableView != nil {
                    weakSelf.tableView.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.none)
                }
                DBJIPINFO = ip
                weakSelf.task = nil
            }
        }
    }
    deinit {
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}


extension DBJDeviceView: UITableViewDelegate,UITableViewDataSource {

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 7 {
            return tDBJRealLength(50)
        }
        return tDBJRealLength(70)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 7 {
            
            let cellIdentifier = "dbjCellIdentifierWarming"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
                cell!.textLabel!.textColor = UIColor.DBJGromHexColor(0xfc6d6d, alpha: 1)
                cell?.textLabel?.numberOfLines = 0
                cell?.selectionStyle = .none
            }
            cell!.textLabel!.text  =  "点击复制按钮把信息复制给客服，或者截图后将他发送给客服"
            return cell!
        }
        
        
        let cellIdentifier = "dbjCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: cellIdentifier)
            cell!.textLabel!.textColor = UIColor.DBJGromHexColor(0x8e8e8e, alpha: 1)
            cell?.detailTextLabel?.textColor = UIColor.DBJGromHexColor(0x646464, alpha: 1)
            cell?.selectionStyle = .none
            
            let loadingView = UIActivityIndicatorView(frame: CGRect(x: bgView.frame.width - 20 - 20, y: 15, width: 20, height: 20))
            cell?.addSubview(loadingView)
            loadingView.style = .gray
            loadingView.hidesWhenStopped = true
            loadingView.tag = 10001
        }
        let loadingView = cell?.viewWithTag(10001) as! UIActivityIndicatorView
        cell?.addSubview(loadingView)
        loadingView.frame = CGRect(x: bgView.frame.width - 20 - 20, y: 15, width: 20, height: 20)
        var title = ""
        var content = ""
        switch indexPath.row {
        case 0:
            title = "会员账户"
            content = self.parameters.account
        case 1:
            title = "手机型号"
            content = UIDevice.dbjModelName
        case 2:
            title = "设备号"
            content = self.parameters.deviceId ?? UIDevice.getDeviceUUID()
        case 3:
            title = "登陆端口"
            content = self.parameters.ipName
        case 4:
            title = "登陆IP"
        case 5:
            title = "手机系统"
            content = UIDevice.current.systemVersion
        case 6:
            title = "APP版本"
            content = self.parameters.appVersion
        default: break
        }
        if title == "登陆IP" {
            if isLoadingIp {
                loadingView.startAnimating()
                print("\(loadingView.isAnimating)")
            } else if let ip = self.parameters.ip {
                content = ip
                loadingView.stopAnimating()
            }
        } else {
            loadingView.stopAnimating()
        }
        cell?.textLabel?.text = title
        cell?.detailTextLabel?.text = content
        return cell!
    }
}

final class DBJDeviceCell: UITableViewCell{
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension UIDevice {
    
 
    static func getDeviceUUID() -> String {

        var deviceUUID = ""
        let keyName = "dbjKeychain"
        let oldUUid =  UserDefaults.standard.object(forKey: keyName) as? String
        
        if let oldUUID = oldUUid {
            deviceUUID = oldUUID
            return deviceUUID
        }
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.dbjkit.keychain"
        let keyChain = DBJKeychain(service: bundleIdentifier)
        let keyChain_UUID = "keyChain_UUID"
        let keyChainValue = try? keyChain.getString(keyChain_UUID)
        
        if let keyChainValue = keyChainValue {
            deviceUUID = keyChainValue
        } else {
            deviceUUID = Foundation.UUID().uuidString.replacingOccurrences(of: "-", with: "")
        }
        if keyChainValue == nil {
            keyChain[keyChain_UUID] = deviceUUID
        }
        UserDefaults.standard.set(deviceUUID, forKey: keyName)
        UserDefaults.standard.synchronize()
        
        return deviceUUID
    }
    
    static let dbjModelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            case "iPhone14,4":                              return "iPhone_13_mini"
            case "iPhone14,5":                              return "iPhone_13"
            case "iPhone14,2":                              return "iPhone_13_Pro"
            case "iPhone14,3":                              return "iPhone_13_Pro_Max"
            case "iPhone14,6":                              return "iPhone SE (3rd generation)"
            case "iPhone14,7":                              return "iPhone_14"
            case "iPhone14,8":                              return "iPhone_14 Plus"
            case "iPhone15,2":                              return "iPhone_14_Pro"
            case "iPhone15,3":                              return "iPhone_14_Pro_Max"

            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
            case "iPad12,1", "iPad12,2":                    return "iPad (9th generation)"
            case "iPad13,18", "iPad13,19":                  return "iPad (10th generation)"

            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
            case "iPad13,16", "iPad13,17":                  return "iPad Air (5th generation)"

            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini 5"
            case "iPad14,1", "iPad14,2":                    return "iPad mini 6"
                
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad13,10", "iPad13,11":                  return "iPad Pro (12.9-inch) (5th generation)"
            case "iPad14,5", "iPad14,6":                    return "iPad Pro (12.9-inch) (6th generation)"

            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "AudioAccessory5,1":                       return "HomePod mini"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()
}
extension UIView{

    func showToast(text: String){
        
        self.hideToast()
        let toastLb = UILabel()
        toastLb.numberOfLines = 0
        toastLb.lineBreakMode = .byWordWrapping
        toastLb.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLb.textColor = UIColor.white
        toastLb.layer.cornerRadius = 10.0
        toastLb.textAlignment = .center
        toastLb.font = UIFont.systemFont(ofSize: 15.0)
        toastLb.text = text
        toastLb.layer.masksToBounds = true
        toastLb.tag = 9999//tag：hideToast實用來判斷要remove哪個label
        
        let maxSize = CGSize(width: self.bounds.width - 40, height: self.bounds.height)
        var expectedSize = toastLb.sizeThatFits(maxSize)
        var lbWidth = maxSize.width
        var lbHeight = maxSize.height
        if maxSize.width >= expectedSize.width{
            lbWidth = expectedSize.width
        }
        if maxSize.height >= expectedSize.height{
            lbHeight = expectedSize.height
        }
        expectedSize = CGSize(width: lbWidth, height: lbHeight)
        toastLb.frame = CGRect(x: ((self.bounds.size.width)/2) - ((expectedSize.width + 20)/2), y: self.bounds.height - expectedSize.height - 190 , width: expectedSize.width + 20, height: expectedSize.height + 20)
        self.addSubview(toastLb)
        
        UIView.animate(withDuration: 1.5, delay: 2, animations: {
            toastLb.alpha = 0.0
        }) { (complete) in
            toastLb.removeFromSuperview()
        }
    }
    
    func hideToast(){
        for view in self.subviews{
            if view is UILabel , view.tag == 9999{
                view.removeFromSuperview()
            }
        }
    }
}


/**
 
 NSDictionary *models = @{
     @"AppleTV2,1": @"Apple TV 2",
     @"AppleTV3,1": @"Apple TV 3",
     @"AppleTV3,2": @"Apple TV 3",
     @"AppleTV5,3": @"Apple TV 4",
     @"AppleTV6,2": @"Apple TV 4K",
     @"iMac21,1": @"iMac (24-inch, M1, 2021)",
     @"iMac21,2": @"iMac (24-inch, M1, 2021)",
     @"iPad1,1": @"iPad",
     @"iPad2,1": @"iPad 2",
     @"iPad2,2": @"iPad 2",
     @"iPad2,3": @"iPad 2",
     @"iPad2,4": @"iPad 2",
     @"iPad2,5": @"iPad mini",
     @"iPad2,6": @"iPad mini",
     @"iPad2,7": @"iPad mini",
     @"iPad3,1": @"iPad 3",
     @"iPad3,2": @"iPad 3",
     @"iPad3,3": @"iPad 3",
     @"iPad3,4": @"iPad 4",
     @"iPad3,5": @"iPad 4",
     @"iPad3,6": @"iPad 4",
     @"iPad4,1": @"iPad Air",
     @"iPad4,2": @"iPad Air",
     @"iPad4,3": @"iPad Air",
     @"iPad4,4": @"iPad mini 2",
     @"iPad4,5": @"iPad mini 2",
     @"iPad4,6": @"iPad mini 2",
     @"iPad4,7": @"iPad mini 3",
     @"iPad4,8": @"iPad mini 3",
     @"iPad4,9": @"iPad mini 3",
     @"iPad5,1": @"iPad mini 4",
     @"iPad5,2": @"iPad mini 4",
     @"iPad5,3": @"iPad Air 2",
     @"iPad5,4": @"iPad Air 2",
     @"iPad6,3": @"iPad Pro (9.7-inch)",
     @"iPad6,4": @"iPad Pro (9.7-inch)",
     @"iPad6,7": @"iPad Pro (12.9-inch)",
     @"iPad6,8": @"iPad Pro (12.9-inch)",
     @"iPad6,11": @"iPad 5",
     @"iPad6,12": @"iPad 5",
     @"iPad7,1": @"iPad Pro 2 (12.9-inch)",
     @"iPad7,2": @"iPad Pro 2 (12.9-inch)",
     @"iPad7,3": @"iPad Pro (10.5-inch)",
     @"iPad7,4": @"iPad Pro (10.5-inch)",
     @"iPad7,5": @"iPad 6",
     @"iPad7,6": @"iPad 6",
     @"iPad7,11": @"iPad 7",
     @"iPad7,12": @"iPad 7",
     @"iPad8,1": @"iPad Pro 3 (11-inch)",
     @"iPad8,2": @"iPad Pro 3 (11-inch)",
     @"iPad8,3": @"iPad Pro 3 (11-inch)",
     @"iPad8,4": @"iPad Pro 3 (11-inch)",
     @"iPad8,5": @"iPad Pro 3 (12.9-inch)",
     @"iPad8,6": @"iPad Pro 3 (12.9-inch)",
     @"iPad8,7": @"iPad Pro 3 (12.9-inch)",
     @"iPad8,8": @"iPad Pro 3 (12.9-inch)",
     @"iPad8,9": @"iPad Pro 4 (11-inch)",
     @"iPad8,10": @"iPad Pro 4 (11-inch)",
     @"iPad8,11": @"iPad Pro 4 (12.9-inch)",
     @"iPad8,12": @"iPad Pro 4 (12.9-inch)",
     @"iPad11,1": @"iPad mini 5",
     @"iPad11,2": @"iPad mini 5",
     @"iPad11,3": @"iPad Air 3",
     @"iPad11,4": @"iPad Air 3",
     @"iPad11,6": @"iPad 8",
     @"iPad11,7": @"iPad 8",
     @"iPad12,1": @"iPad 9",
     @"iPad12,2": @"iPad 9",
     @"iPad13,1": @"iPad Air 4",
     @"iPad13,2": @"iPad Air 4",
     @"iPad13,4": @"iPad Pro 11-inch (3rd generation)",
     @"iPad13,5": @"iPad Pro 11-inch (3rd generation)",
     @"iPad13,6": @"iPad Pro 11-inch (3rd generation)",
     @"iPad13,7": @"iPad Pro 11-inch (3rd generation)",
     @"iPad13,8": @"iPad Pro 12.9-inch (5th generation)",
     @"iPad13,9": @"iPad Pro 12.9-inch (5th generation)",
     @"iPad13,10": @"iPad Pro 12.9-inch (5th generation)",
     @"iPad13,11": @"iPad Pro 12.9-inch (5th generation)",
     @"iPad13,16": @"iPad Air 5",
     @"iPad13,17": @"iPad Air 5",
     @"iPad13,18": @"iPad (10th generation)",
     @"iPad13,19": @"iPad (10th generation)",
     @"iPad14,1": @"iPad mini 6",
     @"iPad14,2": @"iPad mini 6",
     @"iPad14,3": @"iPad Pro 11-inch (4th generation)",
     @"iPad14,4": @"iPad Pro 11-inch (4th generation)",
     @"iPad14,5": @"iPad Pro 12.9-inch (6th generation)",
     @"iPad14,6": @"iPad Pro 12.9-inch (6th generation)",
     @"iPhone1,1": @"iPhone",
     @"iPhone1,2": @"iPhone 3G",
     @"iPhone2,1": @"iPhone 3GS",
     @"iPhone3,1": @"iPhone 4",
     @"iPhone3,2": @"iPhone 4",
     @"iPhone3,3": @"iPhone 4",
     @"iPhone4,1": @"iPhone 4S",
     @"iPhone5,1": @"iPhone 5",
     @"iPhone5,2": @"iPhone 5",
     @"iPhone5,3": @"iPhone 5c",
     @"iPhone5,4": @"iPhone 5c",
     @"iPhone6,1": @"iPhone 5s",
     @"iPhone6,2": @"iPhone 5s",
     @"iPhone7,1": @"iPhone 6 Plus",
     @"iPhone7,2": @"iPhone 6",
     @"iPhone8,1": @"iPhone 6s",
     @"iPhone8,2": @"iPhone 6s Plus",
     @"iPhone8,4": @"iPhone SE",
     @"iPhone9,1": @"iPhone 7",
     @"iPhone9,2": @"iPhone 7 Plus",
     @"iPhone9,3": @"iPhone 7",
     @"iPhone9,4": @"iPhone 7 Plus",
     @"iPhone10,1": @"iPhone 8",
     @"iPhone10,2": @"iPhone 8 Plus",
     @"iPhone10,3": @"iPhone X",
     @"iPhone10,4": @"iPhone 8",
     @"iPhone10,5": @"iPhone 8 Plus",
     @"iPhone10,6": @"iPhone X",
     @"iPhone11,2": @"iPhone XS",
     @"iPhone11,4": @"iPhone XS Max",
     @"iPhone11,6": @"iPhone XS Max",
     @"iPhone11,8": @"iPhone XR",
     @"iPhone12,1": @"iPhone 11",
     @"iPhone12,3": @"iPhone 11 Pro",
     @"iPhone12,5": @"iPhone 11 Pro Max",
     @"iPhone12,8": @"iPhone SE (2nd generation)",
     @"iPhone13,1": @"iPhone 12 mini",
     @"iPhone13,2": @"iPhone 12",
     @"iPhone13,3": @"iPhone 12 Pro",
     @"iPhone13,4": @"iPhone 12 Pro Max",
     @"iPhone14,2": @"iPhone 13 Pro",
     @"iPhone14,3": @"iPhone 13 Pro Max",
     @"iPhone14,4": @"iPhone 13 mini",
     @"iPhone14,5": @"iPhone 13",
     @"iPhone14,6": @"iPhone SE (3rd generation)",
     @"iPhone14,7": @"iPhone 14",
     @"iPhone14,8": @"iPhone 14 Plus",
     @"iPhone15,2": @"iPhone 14 Pro",
     @"iPhone15,3": @"iPhone 14 Pro Max",
     @"iPod1,1": @"iPod touch",
     @"iPod2,1": @"iPod touch 2",
     @"iPod3,1": @"iPod touch 3",
     @"iPod4,1": @"iPod touch 4",
     @"iPod5,1": @"iPod touch 5",
     @"iPod7,1": @"iPod touch 6",
     @"iPod9,1": @"iPod touch 7",
     @"Mac13,1": @"Mac Studio (M1 Max)",
     @"Mac13,2": @"Mac Studio (M1 Ultra)",
     @"Mac14,2": @"MacBook Air (M2, 2022)",
     @"Mac14,3": @"Mac mini (M2, 2023)",
     @"Mac14,5": @"MacBook Pro (M2 Max, 14-inch, 2023)",
     @"Mac14,6": @"MacBook Pro (M2 Max, 16-inch, 2023)",
     @"Mac14,7": @"MacBook Pro (13-inch, M2, 2022)",
     @"Mac14,9": @"MacBook Pro (M2 Pro, 14-inch, 2023)",
     @"Mac14,10": @"MacBook Pro (M2 Pro, 16-inch, 2023)",
     @"Mac14,12": @"Mac mini (M2 Pro, 2023)",
     @"MacBookAir10,1": @"MacBook Air (M1, 2020)",
     @"MacBookPro17,1": @"MacBook Pro (13-inch, M1, 2020)",
     @"MacBookPro18,1": @"MacBook Pro (16-inch, 2021)",
     @"MacBookPro18,2": @"MacBook Pro (16-inch, 2021)",
     @"MacBookPro18,3": @"MacBook Pro (14-inch, 2021)",
     @"MacBookPro18,4": @"MacBook Pro (14-inch, 2021)",
     @"Macmini9,1": @"Mac mini (M1, 2020)",
     @"VirtualMac2,1": @"Apple Virtual Machine 1",
     @"Watch1,1": @"Apple Watch (38mm)",
     @"Watch1,2": @"Apple Watch (42mm)",
     @"Watch2,3": @"Apple Watch Series 2 (38mm)",
     @"Watch2,4": @"Apple Watch Series 2 (42mm)",
     @"Watch2,6": @"Apple Watch Series 1 (38mm)",
     @"Watch2,7": @"Apple Watch Series 1 (42mm)",
     @"Watch3,1": @"Apple Watch Series 3 (38mm, LTE)",
     @"Watch3,2": @"Apple Watch Series 3 (42mm, LTE)",
     @"Watch3,3": @"Apple Watch Series 3 (38mm)",
     @"Watch3,4": @"Apple Watch Series 3 (42mm)",
     @"Watch4,1": @"Apple Watch Series 4 (40mm)",
     @"Watch4,2": @"Apple Watch Series 4 (44mm)",
     @"Watch4,3": @"Apple Watch Series 4 (40mm, LTE)",
     @"Watch4,4": @"Apple Watch Series 4 (44mm, LTE)",
     @"Watch5,1": @"Apple Watch Series 5 (40mm)",
     @"Watch5,2": @"Apple Watch Series 5 (44mm)",
     @"Watch5,3": @"Apple Watch Series 5 (40mm, LTE)",
     @"Watch5,4": @"Apple Watch Series 5 (44mm, LTE)",
     @"i386": @"Simulator",
     @"x86_64": @"Simulator",
 };

 
 
 */

