//
//  AppDelegate.swift
//  renrendai-swift
//
//  Created by 周希财 on 2019/8/6.
//  Copyright © 2019 VIC. All rights reserved.
//

import UIKit
import Foundation

extension NSString {
    
    // MARK: 自动计算Label文字决定宽高的封装
    class func getLabHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        
        let statusLabelText: NSString = labelStr as NSString
        
        let size = CGSize(width: width, height: 900)
        
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context:nil).size
        
        return strSize.height
        
    }
    
    // MARK: 根据字体大小计算字符串长度
    func calculateStringLengthWithFontSize(fontSize: CGFloat) -> CGFloat {
        
        let textSize = CGSize(width: UIScreen.main.bounds.size.width, height: CGFloat(MAXFLOAT))
        
        let stringWidth = self.boundingRect(with: textSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size.width
        
        return stringWidth
    }
    
    
    func getValue(array:[Dictionary<String,String>]) ->String{
        
        for dic:Dictionary<String,String> in array {
            
            if dic.keys.first! == self as String {
                return dic.values.first!
            }
        }
        return ""
    }
    
    func getKey(array:[Dictionary<String,String>]) ->String{
        
        for dic:Dictionary<String,String> in array {
            
            if dic.values.first! == self as String {
                return dic.keys.first!
            }
        }
        return ""
    }
    
    
    
    /// 寻找某个字符在字符串中的位置
    fileprivate func findCharIndex(str: String, char: String) -> Int? {
        for (idx, item) in str.enumerated() {
            if String(item) == char {
                return idx
            }
        }
        return nil
    }
    /// 密码格式数字和字谜最少八位
    func isPassword()->Bool{
        print(self)
        let regex = "^[a-zA-Z\\d]{8,}$"
        print(regex)
        return self.isValidateBy(regex: regex)
    }
    
    ///是否包含字符串
    func containsIgnoringCase(find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    /// 获取字符串长度
    ///
    /// - Returns: 长度
    func length() -> Int {
        return (self as NSString).length
    }

    static func convert(fromJSON object: Any) -> String? {
        if JSONSerialization.isValidJSONObject(object) {
            if let data = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted) {
                return String.init(data: data, encoding: .utf8)
            }
        }
        return nil
    }

    
    /// 正则相关
    private func isValidateBy(regex: String) -> Bool{
        
        /// 帐号
        var acount: String = self as String
        /// 正则规则字符串
        let pattern = regex
        /// 正则规则
        let regex1 = try? NSRegularExpression(pattern: pattern, options: [])
        /// 进行正则匹配
        if let results = regex1?.matches(in: acount, options: [], range: NSRange(location: 0, length: acount.count)), results.count != 0 {
            return true
            print("帐号匹配成功")
            for result in results{
                let string = (acount as NSString).substring(with: result.range)
                print("对应帐号:",string)
            }
        }
 

        return false;
    }
    
    /// 是否是手机号
    func isMobileNumber() -> Bool{
        let regex = "^[1](([3][0-9])|([4][5-9])|([5][0-3,5-9])|([6][5,6])|([7][0-8])|([8][0-9])|([9][1,8,9]))[0-9]{8}$"
        return self.isValidateBy(regex: regex)
    }
    /// 是否是邮箱号
    func isEmail() -> Bool{
        let regex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return self.isValidateBy(regex: regex)
    }
   
    /// 是否是网址
    func isUrl() -> Bool{
        let regex = "^((http)|(https))+:[^\\s]+\\.[^\\s]*$"
        return self.isValidateBy(regex: regex)
    }
    /// 是否是邮编
    func isPostalcode() -> Bool{
        let regex = "^[0-8]\\d{5}(?!\\d)$";
        return self.isValidateBy(regex: regex)
    }
    
}
