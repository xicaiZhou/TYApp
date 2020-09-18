//
//  LoginVC.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/9/11.
//  Copyright © 2019 VIC. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class LoginVC: BaseViewController {

    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var isShowPassword: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var getCode: UIButton!
    @IBOutlet weak var forgetPassword: UIButton!
    var verifyToken = ""
    var iSTouchIDOrFaceID = false
    /** 默认倒计时间60s */
    fileprivate var timeCount:Int = 60
    override func viewDidLoad() {
        super.viewDidLoad()
        self.line1.backgroundColor = systemColor
        self.line2.backgroundColor = systemColor
        self.line3.backgroundColor = systemColor
        self.forgetPassword.setTitleColor(systemColor, for: .normal)
        self.loginBtn.backgroundColor = systemColor
        #if DEBUG
           name.text = "dev2"
           password.text = "a12345678"
//           code.text = "123"
        #endif
        iSTouchIDOrFaceID = UserDefaults.standard.bool(forKey: "iSTouchIDOrFaceID")
        password.isSecureTextEntry = true
        versionLabel.text = "版本号：" + Utils.appVersion()
        if iSTouchIDOrFaceID {
            FingureCheckTool.userFigerprintAuthenticationTipStr(withtips: "验证登录") { (result) in
                if result == .success {
                    
                   let param = [
                    "username": Utils.getUserName().uppercased(),
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
            }
        }

        getVerifyCode()
    }
    
    
    func getVerifyCode() {
        XCNetWorkTools().requestData(type: .get, api: "/api/verificationCode/getBase64Image", encoding: .URL, parameters: Dictionary(), success: { (res) in
            let data = res as! [String:String]
            let array = (data["image"] ?? "").components(separatedBy: ",")
            let image = UIImage.getImageFroBase64(data: array.last ?? "")
            self.getCode.setBackgroundImage(image, for: .normal);
            self.verifyToken = data["verifyToken"]!;
        }) { (err) in

        }
    }
    
    @IBAction func showPassword(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            sender.setImage(UIImage(named: "睁眼"), for: .normal)
            password.isSecureTextEntry = false
            
        }else{
            sender.setImage(UIImage(named: "闭眼"), for: .normal)
            password.isSecureTextEntry = true
        }
        
    }
    
    @IBAction func forgetPasswordAction(_ sender: Any) {
        
        let vc = ForgetPasswordOneVC()
        vc.type = .forget
        vc.name = name.text?.uppercased()
        let nav = BaseNavigationController(rootViewController:vc)
        self.present(nav, animated: true, completion: nil)
        
    }
    @IBAction func getCode(_ sender: UIButton) {
        
        if name.text == "" || password.text == ""{
            showToast("请将用户名密码填写完整！")
            return
        }
        getVerifyCode();

    }
    @IBAction func login(_ sender: Any) {
        name.resignFirstResponder()
        password.resignFirstResponder()
        code.resignFirstResponder()
        if name.text == "" || password.text == "" {
            showToast("请将用户名密码填写完整！")
            return
        }
        if code.text == "" {
            showToast("请将验证码填写完整！")
            return
        }
        let param = [
            "code": code.text!,
            "verifyToken":verifyToken,
            "username": name.text!.removeAllSapce().uppercased(),
            "password": password.text!,
            "appOs": "2",
            "versionName": Utils.appVersion()

            ]
        HUD.show(.progress)
       
        XCNetWorkTools().requestData(type: .post, api: "/api/login", encoding: .JSON, parameters: param, success: { (res) in

            print(res)
            var value = (res as! Dictionary<String, Any>)
            
            // 登录状态
            Utils.userDefaultSave(Key: "isLogin", Value: true)
            
            value.removeValue(forKey: "versionInfo")
            // 登录信息
            Utils.userDefaultSave(Key: "USER", Value: value)
            Utils.savePassword(Password: self.password.text!)
            Utils.saveUserName(userName:self.name.text!.removeAllSapce())
            Utils.saveMaxErrorCount(count: 5)
            
            HUD.flash(.success, delay: 1.0) { finished in
                Window?.rootViewController =  BaseNavigationController(rootViewController: H5())
            }

        }) { (error) in
            HUD.flash(.error, delay: 1.0)
            self.getVerifyCode()
        }
    }
   
}
