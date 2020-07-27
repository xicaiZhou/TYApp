//
//  AppDelegate.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/9/5.
//  Copyright © 2019 VIC. All rights reserved.
//



//ipa包地址：https://www.huijiefinance.net/zlhj/app/ZLHJHELP/ZLHJHelpAPP.ipa
//小图https://www.huijiefinance.net/zlhj/IOS/logo2.png
//大图https://www.huijiefinance.net/zlhj/IOS/logo1.png


import UIKit
import IQKeyboardManagerSwift
import PKHUD
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var count = 0
    var timer: Timer?
    var bgTask: UIBackgroundTaskIdentifier?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //开启保活
        AudioManager.shared.openBackgroundAudioAutoPlay = true
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarManageBehaviour = .bySubviews
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true;
        self.window = UIWindow(frame: UIScreen.main.bounds);
        self.window?.backgroundColor = UIColor.white;
        
        
        if !UserDefaults.standard.bool(forKey: "iSFistLogin"){
            
            UserDefaults.standard.set(true, forKey: "iSFistLogin")
            UserDefaults.standard.set(false, forKey: "isLogin")
            UserDefaults.standard.set(false, forKey: "iSGesLogin") // 用户是否运行手势登录
            UserDefaults.standard.set(false, forKey: "iSTouchIDOrFaceID") // 用户是否允许TouchID或FaceID登录
            Utils.updatePassword("")
            Utils.saveMaxErrorCount(count: 5)
            
        }
        
        if !UserDefaults.standard.bool(forKey: "isLogin") {
            if UserDefaults.standard.bool(forKey: "iSGesLogin") && Utils.getMaxErrorCount() > 0{
                let vc = PatternLockSettingVC()
                vc.config = ArrowConfig()
                vc.type = .vertify
                vc.isLogin = true
                vc.vertifyScuuess = {
                    let param = [
                        "username": Utils.getUserName(),
                        "password": Utils.getPassword(),
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
                self.window?.rootViewController = vc
            }else if UserDefaults.standard.bool(forKey: "iSTouchIDOrFaceID"){
                let vc = LoginVC()
                vc.iSTouchIDOrFaceID = UserDefaults.standard.bool(forKey: "iSTouchIDOrFaceID")
                self.window?.rootViewController = vc
            }else{
                self.window?.rootViewController = LoginVC();
            }
        }else {
            Window?.rootViewController =  BaseNavigationController(rootViewController: H5())
        }
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    
}

