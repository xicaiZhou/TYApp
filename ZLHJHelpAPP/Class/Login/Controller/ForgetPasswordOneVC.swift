//
//  ForgetPasswordOneVC.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/9/18.
//  Copyright © 2019 VIC. All rights reserved.
//

import UIKit
import PKHUD

enum ChangePasswordType {
    case forget
    case change
}


class ForgetPasswordOneVC: BaseViewController {

    var type: ChangePasswordType!
    var name: String!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var getCodeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安全验证"
        userName.text = name
        self.setupBarButtonItemSelectorName { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func next(_ sender: Any) {


        if userName.text == "" {

            showToast("请填写用户名")
            return

        }
        if code.text == "" {
            showToast("请填写验证码")
            return
        }


        let param = [
            "SERVICE_NAME": "CHECK_CODE",
            "CORE_SERVICENAME":"verifyUsernameAndPassword.user",
            "APP_CODE": code.text!,
             "actType": "4",
             "username": userName.text!.removeAllSapce(),
            "uid" : userName.text!
        ]

        HUD.show(.progress)
        XCNetWorkTools().requestData(type: .post, api: "checkCode", encoding: .JSON, parameters: param, success: { (value) in
             HUD.flash(.success, delay: 1.0) { [weak self] finished in
                           let vc = ForgetPasswordTwoVC()
                           vc.userName = self?.userName.text!
                           vc.code = self?.code.text!
                           self?.navigationController?.pushViewController(vc, animated: true)
                       }
        }) { (error) in
            
        }
      
    }
    
    @IBAction func getCode(_ sender: UIButton) {
        if userName.text == "" {
            showToast("请填写用户名")
            return
        }
        sender.countDownWithInterval(text: "获取验证码")
        let param = [
            "SERVICE_NAME": "GET_APPCODE",
            "CORE_SERVICENAME":"searchPhone",
            "actType": "4",
            "username": userName.text!,
            "uid":userName.text!
        ]
        HUD.show(.progress)
        XCNetWorkTools().requestData(type: .post, api: "getAppCode", encoding: .JSON, parameters: param, success: { (value) in
            HUD.flash(.success)
        }) { (error) in
            
        }
        
    }
}
