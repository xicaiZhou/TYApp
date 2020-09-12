//
//  Utils.swift
//  renrendai-swift
//
//  Created by 周希财 on 2019/8/13.
//  Copyright © 2019 VIC. All rights reserved.
//

import Foundation
import UIKit
import Photos
import PKHUD

typealias loanStatusBlock = (Any) -> Void
typealias smsBlock = (Any) -> Void

let Window = UIApplication.shared.delegate?.window!

//判断机型
let isPad = UIDevice.current.userInterfaceIdiom == .pad
let isPhone = UIDevice.current.userInterfaceIdiom == .phone
let isiPhoneX :Bool = UIApplication.shared.statusBarFrame.height >= 44

//屏幕宽高
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height
let KStatusHeight = UIApplication.shared.statusBarFrame.size.height
let KHeight_NavBar: CGFloat = isiPhoneX ? 88.0 : 64.0
let KHeight_TabBat: CGFloat = isiPhoneX ? 83.0 : 49.0
let KHeight_StatusBar: CGFloat = isiPhoneX ? 44.0 : 24.0
let KBottomView_Height: CGFloat = isiPhoneX ? 104 : 70
/// 控件是否减去tabBar高度
let KBottomTabBar_Height: CGFloat = isiPhoneX ? 44 : 0
//color
let systemColor: UIColor = UIColor.colorWithHex(hex:0xFD9226)
let textFontColor: UIColor = UIColor.colorWithHex(hex: 0x333333)
let textGrayColor: UIColor = UIColor.colorWithHex(hex: 0xD8D8DB)


//GCD - 返回主线程
func main(mainTodo:@escaping ()->()){
    DispatchQueue.main.async {
        mainTodo()
    }
}
func async(todo:@escaping ()->()){
    DispatchQueue.global().async {
        todo()
    }
}

//GCD - after延时
func after(_ seconds: Int, _ afterToDo: @escaping ()->()) {
    let deadlineTime = DispatchTime.now() + .seconds(seconds)
    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
        afterToDo()
    }
}

class Utils{
    
    static func updateApp(){
        

        UIApplication.shared.openURL(URL(string: "https://www.pgyer.com/1ob9")!)

        UIView.animate(withDuration: 1.0, animations: {
            Window?.alpha = 0
            Window?.frame = CGRect(x: 0, y: kScreenWidth, width: 0, height: 0)
        }) { (finish) in
            exit(0)
        }
        
    }
    
    
    // MARK: 后台返回字段不统一怎么办，使用此方法，可以解析 bool，int，string等类型，是不是很刺激很easy
    // return String
    static func stringFromObject(object:AnyObject) -> String {
        var value = ""
        if let code = object as? NSNumber {
            value = code.stringValue
        }else if let code = object as? String {
            value = "\(code)"
        }else if let code = object as? Bool {
            if code == true {
                value = "1"
            }else {
                value = "0"
            }
        }else if let code = object as? CGFloat {
            value = "\(code)"
        }else if  object is NSNull {
            value = ""
        }
        return value
    }
    /// NSUserDefault --- save
    static func userDefaultSave(Key: String, Value: Any){
        return UserDefaults.standard.setValue(Value, forKey: Key)
    }
    
    /// NSUserDefault --- read
    static func userDefaultRead(key:String) -> Any{
        return UserDefaults.standard.object(forKey: key) as Any
    }
    
    /// NSUserDefault --- Remove
    static func userDefaultRemove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    static func saveMaxErrorCount(count:Int) {
        return UserDefaults.standard.setValue(count, forKey: "MaxErrorCount")
        
    }
    
    static func getMaxErrorCount() -> Int {
        return UserDefaults.standard.object(forKey: "MaxErrorCount") as? Int ?? 0
        
    }
    //是否开启定位权限
    static func IsOpenLocation() -> Bool{
        let authStatus = CLLocationManager.authorizationStatus()
        return authStatus != .restricted && authStatus != .denied
    }
    
    /// 打电话
    static func callToNum( PhoneNumber: String){
        
        let telNumber = "tel:"+PhoneNumber
        let callWebView = UIWebView()
        callWebView.loadRequest(URLRequest.init(url: URL.init(string: telNumber)!))
        UIApplication.shared.keyWindow?.addSubview(callWebView)
    }
    
    /// 获取APP版本号
    static func appVersion() -> String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    /// 获取文件路径
    static func getFilePath(fileName: String, ofType: String) ->(String){
        return  Bundle.main.path(forResource: fileName, ofType: ofType)!
    }
    
    /// 获取buildID
    static func appBuildID() -> String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }
    
    /// 获取UUID（设备唯一编码）
    static func UUID() ->String{
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    /// 时间戳
    static func getTimeStamp() ->String{
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return "\(arc4random() % 900001 + 100000)" + dateFormatter.string(from: Date())
    }
    
    /// NSUserDefault --- getUserInfo
    static func getUserInfo() -> UserModel {
        return ((Utils.userDefaultRead(key: "USER")) as? [String: Any])?.kj.model(UserModel.self) ?? UserModel()
    }
    
    /// NSUserDefault --- cleanUserInfo
    static func cleanUserInfo(){
        return Utils.userDefaultRemove(key: "USER")
    }
    
    /// NSUserDefault --- getToken
    static func getToken() ->String{
        return getUserInfo().token
    }
    
    /// NSUserDefault --- isLogin?
    static func isLogin() ->Bool {
        var isLogin = false
        let token = self.getToken()
        print("token:", token)
        isLogin = token.count > 0 ? true : false
        return isLogin
    }
    /********************************************手势密码**********************************************/
    
    static func currentPassword() -> String? {
        return UserDefaults.standard.string(forKey: "kPatterLockPassowrd")
    }
    
    static func updatePassword(_ password: String?) {
        UserDefaults.standard.setValue(password, forKey: "kPatterLockPassowrd")
    }
    /********************************************登录成功后保留用户中文名**********************************************/
    /// 7.登录成功后保留用户中文名
    static func saveUserNameWithHZ(userNmae:String){
        Utils.userDefaultSave(Key: "userNmaeHZ", Value: userNmae)
    }
    /// 7.获取用户中文名
    static func getUserNmaeWithHZ() ->String{
        return  Utils.userDefaultRead(key: "userNmaeHZ") as? String ?? ""
    }
    
    
    /**********************************************登录成功后保留密码************************************************/
    /// 8.登录成功后保留密码
    static func savePassword(Password:String){
        Utils.userDefaultSave(Key: "password", Value: Password)
    }
    /// 8.获取password
    static func getPassword() -> String{
        return Utils.userDefaultRead(key: "password") as! String
    }
    /// 8.登录成功后保留userName
    static func saveUserName(userName:String){
        Utils.userDefaultSave(Key: "userName", Value: userName.uppercased())
    }
    /// 8.获取userName
    static func getUserName() -> String{
        return (Utils.userDefaultRead(key: "userName") as! String).uppercased()
    }
    /// mark RGB -> UIColor
    static func getRootPath() ->String{
        return NSHomeDirectory()
    }
    static func documentPath() ->String{
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    static func cachePath() ->String{
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }
    static func getCacheSize() ->String{
        // 取出cache文件夹目录
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        
        //快速枚举出所有文件名 计算文件大小
        var size = 0
        for file in fileArr! {
            
            // 把文件名拼接到路径中
            let path = cachePath! + ("/\(file)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (key, fileSize) in floder {
                // 累加文件大小
                if key == FileAttributeKey.size {
                    size += (fileSize as AnyObject).integerValue
                }
            }
        }
        let totalCache = Double(size) / 1024.00 / 1024.00
        return String(format: "%.2fM", totalCache)
        
    }
    
    static func clearCache(){
        // 取出cache文件夹目录
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        // 遍历删除
        for file in fileArr! {
            let path = (cachePath! as NSString).appending("/\(file)")
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                    
                } catch {}
            }
        }
    }
}



public class PhotoTool: NSObject {
    
    // 跳到手机设置
    static func openIphoneSetting() {
        UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    // 相机
    static func IsOpenCamera() -> Bool{
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    static func requestAccess(authorized: @escaping () -> Void, rejected: @escaping () -> Void){
        AVCaptureDevice.requestAccess(for: .video) { (status) in
            DispatchQueue.main.async {
                if status {
                    authorized()
                }else{
                    rejected()
                }
            }
        }
    }
    
    // 相册
    static func canAccessPhotoLib() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    static func requestAuthorizationForPhotoAccess(authorized: @escaping () -> Void, rejected: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    authorized()
                } else {
                    rejected()
                }
            }
        }
    }
}




