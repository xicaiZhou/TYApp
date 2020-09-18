//
//  DirectSWKWebViewVC.swift
//  ZLHJHelpAPP
//
//  Created by zhy on 2020/4/15.
//  Copyright © 2020 VIC. All rights reserved.
//

import UIKit
import WebKit
import PKHUD

class H5: BaseViewController {
    
    var webView = WKWebView()
    var goBackBtn = UIButton()
    var closeBtn = UIButton()
    var searchBtn = UIButton()
    var allowZoom = true // 是否允许缩放
    var H5Url: String = "" // 传入的链接
    private let h5ToSwift = "setLocal"
    private let updata = "updataInfo"
    var titleText = ""
    var iSTouchIDOrFaceID = false
    var iSGesLogin = false
    
    // 进度条
    lazy var progressView:UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = systemColor
        progress.trackTintColor = .clear
        return progress
    }()
    
    @objc func notificationAction(noti: Notification) {
        print("huilaile")
        let str = "userInfo(" + Utils.getUserInfo().kj.JSONString() + ")"
        self.webView.evaluateJavaScript(str) { (response, error) in
            print(response ?? "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction), name: NSNotification.Name(rawValue: "notification"), object: nil)
        
        iSTouchIDOrFaceID = UserDefaults.standard.bool(forKey: "iSTouchIDOrFaceID")
        iSGesLogin = UserDefaults.standard.bool(forKey: "iSGesLogin")
        let path = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "vue")
        
//        let mapwayURL = URL(fileURLWithPath: path!)
                let mapwayURL = URL(string: "http://192.168.7.30:8080/#/")!
        let mapwayRequest = URLRequest(url: mapwayURL)
        let conf = WKWebViewConfiguration()
        conf.userContentController = WKUserContentController()
        conf.preferences.javaScriptEnabled = true
        conf.selectionGranularity = WKSelectionGranularity.character
        //        /// h5 调用 swift 提供的方法
        conf.userContentController.add(self, name: h5ToSwift)
        conf.userContentController.add(self, name: updata)
        webView = WKWebView( frame: CGRect(x:0, y:KHeight_NavBar,width:kScreenWidth, height:kScreenHeight - KHeight_NavBar - (isiPhoneX ? 34 : 0)),configuration:conf)
        webView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
        
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.load(mapwayRequest)
        view.addSubview(self.progressView)
        
        // 设置返回按钮
        showLeftNavigationItem()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.progressView.frame = CGRect(x:0,y:KHeight_NavBar,width:kScreenWidth,height:1)
        self.progressView.isHidden = false
        UIView.animate(withDuration: 1.0) {
            self.progressView.progress = 0.0
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("==============","\(self)","被销毁")
        
    }
    
    func showLeftNavigationItem(){
        searchBtn = self.setupRightBarButtonItemSelectorName(imageName: "ic_searchone") { [weak self] in
            var js = ""
            if self?.titleText == "经销商列表"{
                js = "showExhibitionSearch()"
            }else if self?.titleText == "车辆品牌"{
                js = "showCarModelSearch()"
            }else if self?.titleText == "车辆品牌列表"{
                js = "showCarModelListSearch()"
            }else if self?.titleText == "查询"{
                js = "showCarLoanListSearch()"
            }else if self?.titleText == "逾期查询"{
                js = "showCovedueListSearch()"
            }
            
            self!.webView.evaluateJavaScript(js) { (response, error) in
                
            }
        }
        // 返回按钮
        goBackBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        goBackBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0);
        goBackBtn.setImage(UIImage(named: "ic_turn")!.withRenderingMode(.alwaysOriginal), for: .normal)
        goBackBtn.setImage(UIImage(named: "ic_turn")!.withRenderingMode(.alwaysOriginal), for: .selected)
        goBackBtn.setTitle(" 返回", for: UIControl.State.normal)
        goBackBtn.setTitle(" 返回", for: UIControl.State.highlighted)
        goBackBtn.setTitleColor(systemColor, for: UIControl.State.normal)
        goBackBtn.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        
    }
    
    @objc func goBack(){
        if self.webView.canGoBack {
            self.webView.goBack()
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func popViewController(){
        self.navigationController?.popViewController(animated: true)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            
            self.titleText = webView.title!;
            // 查询 车辆品牌 //车辆品牌列表
            if webView.title == "首页" || webView.title == "查询" || webView.title == "我的"{
                self.goBackBtn.isHidden = true
            }else{
                self.goBackBtn.isHidden = false
            }
            if webView.title == "经销商列表"  || webView.title == "车辆品牌" || webView.title == "车辆品牌列表" || webView.title == "查询" || webView.title == "逾期查询"{
                self.searchBtn.isHidden = false;
            }else{
                self.searchBtn.isHidden = true;
            }
            
            if webView.title == "设置"{
                async {
                    let data = ["password":Utils.getPassword(),"cache":Utils.getCacheSize(),"phoneIsTouchID":self.iSTouchIDOrFaceID,"phoneIsGesture":self.iSGesLogin] as [String : Any]
                    let param =  Dictionary.toJSONString(dict:data)
                    let js = "systemInfo(" + param + ")"
                    main {
                        self.webView.evaluateJavaScript(js) { (response, error) in
                            
                        }
                    }
                    
                }
                
            }
            self.navigationItem.title = webView.title;
        }
        
    }
    
}


extension H5: WKNavigationDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if !allowZoom {
            return nil
        }else{
            return webView.scrollView.subviews.first
        }
    }
    
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        HUD.show(.progress)
        self.navigationItem.title = "加载中..."
        /// 获取网页的progress
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        
        HUD.hide()
        allowZoom = false
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 1.0
            self.progressView.isHidden = true
        }
        
        //用于消除右边边空隙，要不然按钮顶不到最边上
        let spacer = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        spacer.width = -5;
        let barGoBackBtn = UIBarButtonItem(customView: goBackBtn)
        
        //设置按钮（注意顺序）
        self.navigationItem.leftBarButtonItems = [spacer, barGoBackBtn]
        
        /// iOS调用js
        // 调用js里的navButtonAction方法，并且传入了两个参数，回调里面response是这个方法return回来的数据
        let str = "userInfo(" + Utils.getUserInfo().kj.JSONString() + ")"
        self.webView.evaluateJavaScript(str) { (response, error) in
            print(response ?? "")
        }
        let js = "screenHeight(" + "\(kScreenHeight - KHeight_NavBar)" + ")"
        self.webView.evaluateJavaScript(js) { (response, error) in
            print(response ?? "")
        }
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 0.0
            self.progressView.isHidden = true
        }
        /// 弹出提示框点击确定返回
        HUD.flash(.labeledError(title: "加载失败!", subtitle: ""))
        
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        HUD.flash(.labeledError(title: "加载失败!", subtitle: ""))
    }
}


extension H5: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        /// JS调Native APP
        /// h5 调用 swift 方案   window.webkit.messageHandlers.AppFunc.postMessage("这是传个 Swift 的")
        
        if(message.name == h5ToSwift) { // 1-touchID 2-手势 3-缓存 4-登出 5-token过期 6-修改手势密码
            print("JavaScript is sending a message.body \(message.body)")
            
            if let index = message.body as? Int{
                
                switch index {
                case 1:
                    FingureCheckTool.userFigerprintAuthenticationTipStr(withtips: "验证") { (result) in
                        if result == .success {
                            self.iSTouchIDOrFaceID = !self.iSTouchIDOrFaceID
                            UserDefaults.standard.set(self.iSTouchIDOrFaceID, forKey: "iSTouchIDOrFaceID") // 用户是否允许TouchID或FaceID登录
                            async {
                                let data = ["password":Utils.getPassword(),"cache":Utils.getCacheSize(),"phoneIsTouchID":self.iSTouchIDOrFaceID,"phoneIsGesture":self.iSGesLogin] as [String : Any]
                                let param =  Dictionary.toJSONString(dict:data)
                                let js = "systemInfo(" + param + ")"
                                main {
                                    self.webView.evaluateJavaScript(js) { (response, error) in
                                        
                                    }
                                }
                                
                            }
                        }else if result == .NotSupport {
                            Alert.showAlert2(self, title: "提示", message: "当前设备没有开启或不支持" + (isiPhoneX ? "FaceID" : "TouchID") + "," + "前往设置?", alertTitle1: "前往", style1: .default, confirmCallback1: {
                                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                                
                            }, alertTitle2: "取消", style2: .cancel, confirmCallback2: {
                                async {
                                    let data = ["password":Utils.getPassword(),"cache":Utils.getCacheSize(),"phoneIsTouchID":self.iSTouchIDOrFaceID,"phoneIsGesture":self.iSGesLogin] as [String : Any]
                                    let param =  Dictionary.toJSONString(dict:data)
                                    let js = "systemInfo(" + param + ")"
                                    main {
                                        self.webView.evaluateJavaScript(js) { (response, error) in
                                            
                                        }
                                    }
                                    
                                }
                            });
                        }else if result == .touchidNotAvailable {
                            Alert.showAlert2(self, title: "提示", message: "当前设备没有开启" + (isiPhoneX ? "FaceID" : "TouchID") + "," + "前往设置?", alertTitle1: "前往", style1: .default, confirmCallback1: {
                                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                                
                            }, alertTitle2: "取消", style2: .cancel, confirmCallback2: {
                                async {
                                    let data = ["password":Utils.getPassword(),"cache":Utils.getCacheSize(),"phoneIsTouchID":self.iSTouchIDOrFaceID,"phoneIsGesture":self.iSGesLogin] as [String : Any]
                                    let param =  Dictionary.toJSONString(dict:data)
                                    let js = "systemInfo(" + param + ")"
                                    main {
                                        self.webView.evaluateJavaScript(js) { (response, error) in
                                            
                                        }
                                    }
                                    
                                }
                            });
                        }
                    }
                    
                    break;
                case 2:
                    if (iSGesLogin && Utils.currentPassword()!.count > 0){
                        let vc = PatternLockSettingVC()
                        vc.config = ArrowConfig()
                        vc.type = .vertify
                        vc.vertifyScuuess = {
                            self.iSGesLogin = !self.iSGesLogin
                            async {
                                let data = ["password":Utils.getPassword(),"cache":Utils.getCacheSize(),"phoneIsTouchID":self.iSTouchIDOrFaceID,"phoneIsGesture":self.iSGesLogin] as [String : Any]
                                let param =  Dictionary.toJSONString(dict:data)
                                let js = "systemInfo(" + param + ")"
                                main {
                                    self.webView.evaluateJavaScript(js) { (response, error) in
                                        
                                    }
                                }
                            }
                            UserDefaults.standard.set(self.iSGesLogin, forKey: "iSGesLogin") // 用户是否运行手势登录
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = PatternLockSettingVC()
                        vc.config = ArrowConfig()
                        vc.type = .setup
                        vc.stFail = {
                            async {
                                let data = ["password":Utils.getPassword(),"cache":Utils.getCacheSize(),"phoneIsTouchID":self.iSTouchIDOrFaceID,"phoneIsGesture":self.iSGesLogin] as [String : Any]
                                let param =  Dictionary.toJSONString(dict:data)
                                let js = "systemInfo(" + param + ")"
                                main {
                                    self.webView.evaluateJavaScript(js) { (response, error) in
                                        
                                    }
                                }
                            }
                        }
                        vc.stSuccess = {
                            self.iSGesLogin = true
                            UserDefaults.standard.set(self.iSGesLogin, forKey: "iSGesLogin") // 用户是否运行手势登录
                            async {
                                let data = ["password":Utils.getPassword(),"cache":Utils.getCacheSize(),"phoneIsTouchID":self.iSTouchIDOrFaceID,"phoneIsGesture":self.iSGesLogin] as [String : Any]
                                let param =  Dictionary.toJSONString(dict:data)
                                let js = "systemInfo(" + param + ")"
                                main {
                                    self.webView.evaluateJavaScript(js) { (response, error) in
                                        
                                    }
                                }
                            }
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    break;
                case 3:
                    Alert.showAlert2(self, title: "提示", message: "是否清空缓存！", alertTitle1: "清空", style1: .default, confirmCallback1: {
                        Utils.clearCache()
                        async {
                            let data = ["password":Utils.getPassword(),"cache":Utils.getCacheSize(),"phoneIsTouchID":self.iSTouchIDOrFaceID,"phoneIsGesture":self.iSGesLogin] as [String : Any]
                            let param =  Dictionary.toJSONString(dict:data)
                            let js = "systemInfo(" + param + ")"
                            main {
                                self.webView.evaluateJavaScript(js) { (response, error) in
                                    
                                }
                            }
                        }
                    }, alertTitle2: "取消", style2: .cancel) {
                        
                    };
                    
                    
                    break;
                    
                case 4:
                    //当前ViewController销毁前将其移除，否则会造成内存泄漏
                    //当前ViewController销毁前将其移除，否则会造成内存泄漏
                    self.webView.removeObserver(self, forKeyPath: "title")
                    self.webView.configuration.userContentController.removeScriptMessageHandler(forName: self.h5ToSwift)
                    self.webView.configuration.userContentController.removeScriptMessageHandler(forName: self.updata)
                    Utils.userDefaultSave(Key: "isLogin", Value: false)
                    
                    if UserDefaults.standard.bool(forKey: "iSGesLogin") && Utils.getMaxErrorCount() > 0{
                        let vc = PatternLockSettingVC()
                        vc.config = ArrowConfig()
                        vc.type = .vertify
                        vc.isLogin = true
                        vc.vertifyScuuess = {
                            let param = [
                                "username": Utils.getUserName(),
                                "password": Utils.getPassword(),
                                "appOs": "2",
                                "versionName": Utils.appVersion()
                            ]
                            HUD.show(.progress)
                            XCNetWorkTools().requestData(type: .post, api: "/api/loginWithoutCode", encoding: .JSON, parameters: param, success: { (res) in
                                print(res)
                                let value = (res as! Dictionary<String, Any>)
                                
                                Utils.userDefaultSave(Key: "isLogin", Value: true)
                                Utils.userDefaultSave(Key: "USER", Value: value)
                                Utils.saveMaxErrorCount(count: 5)
                                HUD.flash(.success, delay: 1.0) { finished in
                                    Window?.rootViewController =  BaseNavigationController(rootViewController: H5())
                                }
                                
                            }) { (error) in
                                HUD.flash(.error, delay: 1.0)
                            }
                        }
                        Window?.rootViewController = vc
                    }else{
                        Window?.rootViewController = LoginVC();
                        
                    }
                    break;
                case 5:
                    Alert.showAlert1(self, title: "提示", message: "登录已过期，请重新登录", alertTitle: "重新登录", style: .default) {
                        //当前ViewController销毁前将其移除，否则会造成内存泄漏
                        self.webView.removeObserver(self, forKeyPath: "title")
                        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: self.h5ToSwift)
                        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: self.updata)
                        Utils.userDefaultSave(Key: "isLogin", Value: false)
                        
                        if UserDefaults.standard.bool(forKey: "iSGesLogin") && Utils.getMaxErrorCount() > 0{
                            let vc = PatternLockSettingVC()
                            vc.config = ArrowConfig()
                            vc.type = .vertify
                            vc.isLogin = true
                            vc.vertifyScuuess = {
                                let param = [
                                    "username": Utils.getUserName(),
                                    "password": Utils.getPassword(),
                                    "appOs": "2",
                                    "versionName": Utils.appVersion()
                                ]
                                HUD.show(.progress)
                                XCNetWorkTools().requestData(type: .post, api: "/api/loginWithoutCode", encoding: .JSON, parameters: param, success: { (res) in
                                    print(res)
                                    let value = (res as! Dictionary<String, Any>)
                                    
                                    Utils.userDefaultSave(Key: "isLogin", Value: true)
                                    Utils.userDefaultSave(Key: "USER", Value: value)
                                    Utils.saveMaxErrorCount(count: 5)
                                    HUD.flash(.success, delay: 1.0) { finished in
                                        Window?.rootViewController =  BaseNavigationController(rootViewController: H5())
                                    }
                                    
                                }) { (error) in
                                    HUD.flash(.error, delay: 1.0)
                                }
                            }
                            Window?.rootViewController = vc
                        }else{
                            Window?.rootViewController = LoginVC();
                            
                        }
                    }
                    break;
                case 6:
                    let vc = PatternLockSettingVC()
                    vc.config = ArrowConfig()
                    vc.type = .vertify
                    self.navigationController?.pushViewController(vc, animated: true)
                    vc.vertifyScuuess = {
                        let vc1 = PatternLockSettingVC()
                        vc1.config = ArrowConfig()
                        vc1.type = .setup
                        self.navigationController?.pushViewController(vc1, animated: true)
                    }
                    break;
                default:
                    break;
                }
            }
            
        }else if message.name == updata{
            print("JavaScript is sending a message.body \(message.body)")
            
            let js = (message.body as! [String:Any])["value"] as! [String:Any]
            self.open(maxCountOfImage: 9, result: { (images) in
                let count = images.count;
                // 接口不支持多张
                var index = 0
                HUD.show(.progress)
                for image in images {
                    XCNetWorkTools().upDataIamgeRequest(api: "/api/upload/multiple", parameters:Dictionary(), imageArr: [image], name: "uploadImgFile", fileName: "a.png", successHandler: { (value) in
                        let param:[String: Any] = [
                            "loanNumber": js["loanNumber"] as Any,
                            "loanFileId": js["id"] as Any,
                            "loanFileName": js["loanFileName"] as Any,
                            "filePath": value as! String,
                        ]
                        XCNetWorkTools().requestData(type: .post, api: "/api/loanFileList/fileDetails/add", encoding: .JSON, parameters: param, success: { (res) in
                            index += 1
                            if(count == index){
                                HUD.flash(.success, delay: 1)
                                self.webView.evaluateJavaScript("uploadData()") { (response, error) in
                                    print(response ?? "")
                                }
                            }
                        }) { (err) in
                            index += 1
                        }
                    }) { (error) in
                        index += 1
                    }
                }
            })
        }
    }
}

