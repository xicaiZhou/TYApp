//
//  Alert.swift
//  renrendai-swift
//
//  Created by 周希财 on 2019/8/13.
//  Copyright © 2019 VIC. All rights reserved.
//

import Foundation
import UIKit

class Alert: NSObject {
    
    
    /// 警告弹窗
    ///
    /// - Parameters:
    ///   - vc: 控制器
    ///   - title: 弹窗名字
    ///   - message: 弹窗描述
    ///   - alertTitle: 选项名称
    ///   - style: 选项样式
    ///   - confirmCallback: 点击事件
    class  func showAlert1( _ vc:UIViewController,
                            title:String? = nil,
                            message:String?=nil,
                            alertTitle:String?=nil,
                            style:UIAlertAction.Style = .`default`,
                            confirmCallback:(() -> Void)? = nil )  {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: alertTitle, style:style) { (action) in
            confirmCallback?()
        }
//        let vc = UIApplication.shared.keyWindow?.rootViewController
        alertVC.addAction(action)
        vc.present(alertVC, animated: true, completion: nil)
    }
    
    
    class func showAlert2(  _ vc:UIViewController,
                            title:String? = nil,
                            message:String?=nil,
                            alertTitle1:String?=nil,
                            style1:UIAlertAction.Style = .destructive,
                            confirmCallback1:(() -> Void)? = nil ,
                            alertTitle2:String?=nil,
                            style2:UIAlertAction.Style = UIAlertAction.Style.`default`,
                            confirmCallback2:(() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action1 = UIAlertAction(title: alertTitle1, style:style1) { (action) in
            confirmCallback1?()
        }
        let action2 = UIAlertAction(title: alertTitle2, style:style2) { (action) in
            confirmCallback2?()
        }
        alertVC.addAction(action1)
        alertVC.addAction(action2)
        let vc = UIApplication.shared.keyWindow?.rootViewController
        vc?.present(alertVC, animated: true, completion: nil)
    }
    
    class func showAction( _ vc:UIViewController,
                            title:String? = nil,
                            message:String?=nil,
                            cancelTitle:String?=nil,
                            destructiveTitle:String?=nil,
                            otherTitle:[String]? = [],
                            otherCallback:[() -> Void]?=[]
        ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction = UIAlertAction(title: cancelTitle, style:.cancel) { (action) in
        }
        let destructiveAction = UIAlertAction(title: destructiveTitle, style:.destructive) { (action) in
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(destructiveAction)
        if let otherTitle = otherTitle , let otherCallback = otherCallback {
            if otherTitle.count != 0 , otherTitle.count == otherCallback.count{
                for (index,title) in otherTitle.enumerated(){
                    let action = UIAlertAction(title: title, style: .default) { (action) in
                        let callBack = otherCallback[index]
                        callBack()
                    }
                    alertVC.addAction(action)
                }
                
            }
        }
        let vc = UIApplication.shared.keyWindow?.rootViewController
        vc?.present(alertVC, animated: true, completion: nil)
    }
    
    
    
}
