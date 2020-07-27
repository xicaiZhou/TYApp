//
//  FingureCheckTool.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/9/9.
//  Copyright © 2019 VIC. All rights reserved.
//

import Foundation
import LocalAuthentication
import PKHUD

class FingureCheckTool: NSObject {

    
    
    
    @objc
    enum FingureCheckResult: NSInteger {
        case success             //成功
        case failed              //失败
        case passwordNotSet      //未设置手机密码
        case touchidNotSet       //未设置指纹
        case touchidNotAvailable //不支持指纹
        case cancleSys           //系统取消
        case canclePer           //用户取消
        case inputNUm            //输入密码
        case NotSupport          //不支持
    }
    
    
    enum BiometryType : Int {
        case none
        case touchID
        case faceID
    }
    public static func getBiometryType() -> BiometryType{
        //该参数必须在canEvaluatePolicy方法后才有值
        let authContent = LAContext()
        var error: NSError?
        if authContent.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            //iPhoneX出厂最低系统版本号：iOS11.0.0
            if #available(iOS 11.0, *) {
                if authContent.biometryType == .faceID {
                    return .faceID
                }else if authContent.biometryType == .touchID {
                    return .touchID
                }
            } else {
                guard let laError = error as? LAError else{
                    return .none
                }
                if laError.code != .touchIDNotAvailable {
                    return .touchID
                }
            }
        }
        return .none
    }
    

    
    static func userFigerprintAuthenticationTipStr(withtips tips:String, block : @escaping (_ result :FingureCheckResult) -> Void){
        
        let type = self.getBiometryType()
        
        var typeStr = ""
        
        switch type {
        case .faceID:
            typeStr = "faceID"
        case .touchID:
            typeStr = "touchID"
        case .none:
            typeStr = ""
        default:
            typeStr = ""
        }
        
        if typeStr == "" {
            main {
                 block(FingureCheckResult.NotSupport)
            }
        }
        
        
        
        if #available(iOS 8.0, OSX 10.12, *) { //IOS 版本判断 低于版本无需调用
            let context = LAContext()//创建一个上下文对象
            var error: NSError? = nil//捕获异常
            if(context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)){//判断当前设备是否支持指纹解锁

                //指纹解锁开始啦
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason:tips, reply: { (success, error) in
                    if(success){
                        main {
                            block(FingureCheckResult.success)
                        }
                        //进行UI操作
                          print("操作吧");
                    }else{
                        let laerror = error as! LAError
                        switch laerror.code {
                        case LAError.authenticationFailed:
                            print("连续三次输入错误，身份验证失败。")
                            main{
                                BaseViewController.currentViewController()?.showToast("连续三次输入错误，身份验证失败。")
                                block(FingureCheckResult.failed)
                            }
                            break
                        case LAError.userCancel:
                            print("用户点击取消按钮。")
                            main{
                                BaseViewController.currentViewController()?.showToast("用户点击取消按钮。")
                                block(FingureCheckResult.canclePer)
                            }

                            break
                        case LAError.userFallback:
                            print("用户点击输入密码。")
                            main {
                                BaseViewController.currentViewController()?.showToast("用户点击输入密码。")
                                block(FingureCheckResult.inputNUm)
                            }

                            break
                        case LAError.systemCancel:
                            print("系统取消")
                            main{
                                BaseViewController.currentViewController()?.showToast("系统取消")
                                block(FingureCheckResult.cancleSys)
                            }

                            break
                        case LAError.passcodeNotSet:
                            print("用户未设置密码")
                            main{
                                BaseViewController.currentViewController()?.showToast("用户未设置密码")
                                block(FingureCheckResult.passwordNotSet)
                            }
                            break
                        case LAError.touchIDNotAvailable:
                            print(typeStr + "不可用")
                            main{
                                BaseViewController.currentViewController()?.showToast(typeStr + "不可用")
                                block(FingureCheckResult.touchidNotAvailable)
                            }

                            break
                        case LAError.touchIDNotEnrolled:
                            print(typeStr + "未设置指纹")
                            main{
                                BaseViewController.currentViewController()?.showToast(typeStr + "未设置指纹")
                                block(FingureCheckResult.touchidNotSet)
                            }
                            break
                        default: break
                            
                        }
                    }
                })
                
            }else{
                print("不支持")
                
                main {
                     block(FingureCheckResult.NotSupport)
                   
                }
            }
        }
    }

}
