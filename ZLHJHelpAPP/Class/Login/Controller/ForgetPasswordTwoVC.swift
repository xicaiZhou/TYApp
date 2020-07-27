//
//  ForgetPasswordTwoVC.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/9/18.
//  Copyright © 2019 VIC. All rights reserved.
//

import UIKit
import PKHUD

class ForgetPasswordTwoVC: BaseViewController {

    
    var userName:String!
    var code:String!
    
    @IBOutlet weak var isShowPassword: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码"
        newPassword.isSecureTextEntry = true
        confirmPassword.isSecureTextEntry = true
        self.setupBarButtonItemSelectorName {
            self.dismiss(animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func showNewPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            sender.setImage(UIImage(named: "睁眼"), for: .normal)
            newPassword.isSecureTextEntry = false
            
        }else{
            sender.setImage(UIImage(named: "闭眼"), for: .normal)
            newPassword.isSecureTextEntry = true

        }
    }
    
    @IBAction func showconfirmPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            sender.setImage(UIImage(named: "睁眼"), for: .normal)
            confirmPassword.isSecureTextEntry = false
            
        }else{
            sender.setImage(UIImage(named: "闭眼"), for: .normal)
            confirmPassword.isSecureTextEntry = true

        }
    }
    
    @IBAction func finish(_ sender: Any) {
        
        if newPassword.text == "" ||  confirmPassword.text == ""{
            showToast("密码不能为空！")
            return
        }
        
        if newPassword.text != confirmPassword.text {
            showToast("输入密码不一致！，请检查后再试")
            return
        }
        
        if newPassword.text!.count < 8 {
            showToast("密码最少设置8位！")
            return
        }
        
        if !((newPassword.text)!.isPassword()){
            showToast("密码格式错误！")
            return
        }
//        let param:[String: Any] = [
//            "SERVICE_NAME": "MODIFY_PASSWORD",
//            "CORE_SERVICENAME":"searchPhone.forgetPassword",
//            "actType": "3",
//            "password": newPassword.text!,
//            "APP_CODE": code!,
//            "username": userName!,
//            "newPassword":confirmPassword.text!,
//            "uid": userName!
//        ]
//        
//        HUD.show(.progress)
//        XCNetWorkTools().request(type: .post, api: "forgetPassword", encoding: .JSON, parameters: param, success: { (value) in
//            
//            HUD.flash(.success, delay: 1.0) { finished in
//                self.dismiss(animated: true, completion: nil)
//            }
//
//        }) { (error) in
//
//        }
        
        

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
