//
//  String-Extersion.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/9/23.
//  Copyright © 2019 VIC. All rights reserved.
//

import Foundation


extension String {
    
    /// 四位随机数加时间戳
    static func randomStr() -> String{
        
        let num = Int(arc4random_uniform(8999) + 1000)
        let time = Date().timeStamp
        return "\(num)" + time
        
    }
    
    
    ///  字符串的截取
    public func subStringFrom(index: Int,length:Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(self.startIndex, offsetBy: index+length)
            
            let subString = self[startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    ///  字符串的截取
    func substring(from: Int, to: Int) -> String
    {
        let fromIndex = index(startIndex, offsetBy: from)
        let toIndex = index(startIndex, offsetBy: to)
        
        guard fromIndex >= startIndex, fromIndex < toIndex, toIndex <= endIndex else { return "" }
        
        return String(self[fromIndex ..< toIndex])
    }
    ///  字符串的截取
    public func substring(from: Int?, to: Int?) -> String
    {
        return substring(from: from ?? 0, to: to ?? count)
    }
    ///  字符串的截取
    func substring(from: Int) -> String
    {
        return substring(from: from, to: nil)
    }
    ///  字符串的截取
    func substring(to: Int) -> String
    {
        return substring(from: nil, to: to)
    }
    
    ///替换指定范围内的字符串
    mutating func stringByReplacingCharactersInRange(index:Int,length:Int,replacText:String) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: index)
        self.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: length), with: replacText)
        return self
    }
    /// 替换指定字符串
    mutating func stringByReplacingstringByReplacingString(text:String,replacText:String) -> String {
        return self.replacingOccurrences(of: text, with: replacText)
    }
    
    ///删除最后一个字符
    mutating func deleteEndCharacters() -> String {
        self.remove(at: self.index(before: self.endIndex))
        return self
    }
    /// 删除指定字符串
    mutating func deleteString(string:String) -> String {
        return self.replacingOccurrences(of: string, with: "")
    }
    
    /// 字符的插入
    mutating func insertString(text:Character,index:Int) -> String{
        let start = self.index(self.startIndex, offsetBy: index)
        self.insert(text, at: start)
        return self
    }
    ///字符串的插入
    mutating func insertString(text:String,index:Int) -> String{
        let start = self.index(self.startIndex, offsetBy: index)
        self.insert(contentsOf: text, at: start)
        return self
    }
    
    /// 将字符串通过特定的字符串拆分为字符串数组
    ///
    /// - Parameter string: 拆分数组使用的字符串
    /// - Returns: 字符串数组
    func split(string:String) -> [String] {
        return NSString(string: self).components(separatedBy: string)
    }
    
    func getInt() -> Int {
        let numbersString = self.filter { "0123456789".contains($0) }
        return Int(numbersString) ?? 0
    }
    
    func removeAllSapce() -> String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    func getValue(array:[Dictionary<String,String>]) ->String{
        
        for dic:Dictionary<String,String> in array {
            
            if dic.keys.first! == self {
                return dic.values.first!
            }
        }
        return ""
    }
    
    func getKey(array:[Dictionary<String,String>]) ->String{
        
        for dic:Dictionary<String,String> in array {
            
            if dic.values.first! == self {
                return dic.keys.first!
            }
        }
        return ""
    }
    func isPurnInt() -> Bool {
        
        let scan: Scanner = Scanner(string: self)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    func viewIsUserInteraction()->Bool{
        let state = Int(self) ?? 0
        // TODO 大于等于30的时候即决策时,不显示.
        return state < 0 || state >= 30 ? false : true
    }
    /// 是否是身份证
    func isIDCard() -> Bool{
        
        let identityCard = self
        
        //判断是否为空
        if identityCard.count <= 0 {
            return false
        }
        //判断是否是18位，末尾是否是x
        let regex2: String = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let identityCardPredicate = NSPredicate(format: "SELF MATCHES %@", regex2)
        if !identityCardPredicate.evaluate(with: identityCard) {
            return false
        }
        //判断生日是否合法
        let range = NSRange(location: 6, length: 8)
        let datestr: String = (identityCard as NSString).substring(with: range)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        if formatter.date(from: datestr) == nil {
            return false
        }
        //判断校验位
        if  identityCard.count == 18 {
            let idCardWi: [String] = ["7", "9", "10", "5", "8", "4", "2", "1", "6", "3", "7", "9", "10", "5", "8", "4", "2"]
            //将前17位加权因子保存在数组里
            let idCardY: [String] = ["1", "0", "10", "9", "8", "7", "6", "5", "4", "3", "2"]
            //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            var idCardWiSum: Int = 0
            //用来保存前17位各自乖以加权因子后的总和
            for i in 0..<17 {
                idCardWiSum += Int((identityCard as NSString).substring(with: NSRange(location: i, length: 1)))! * Int(idCardWi[i])!
            }
            let idCardMod: Int = idCardWiSum % 11
            //计算出校验码所在数组的位置
            let idCardLast: String = identityCard.substring(from: identityCard.index(identityCard.endIndex, offsetBy: -1))
            //得到最后一位身份证号码
            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if idCardMod == 2 {
                if idCardLast == "X" || idCardLast == "x" {
                    return true
                } else {
                    return false
                }
            } else {
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if (idCardLast as NSString).integerValue == Int(idCardY[idCardMod]) {
                    return true
                } else {
                    return false
                }
            }
        }
        return false
    }
    //获取url中对应的参数的值
    func paramValueOfUrl( param: String) -> String?  {
        if self.hasPrefix("http"){
            guard let url = URLComponents.init(string: self) else { return nil }
            return url.queryItems?.first(where: {$0.name == param})?.value
        }else{
            return self
        }
        
    }
    
    // MARK: 网络请求的时候会将get中的字符串进行URL转换
    func URLEncodedString() -> String? {
        let customAllowedSet =  NSCharacterSet(charactersIn:"!$&'()*+,-./:;=?@_~%#[]").inverted
        let escapedString = self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
        return escapedString
    }
    
}

extension String: FilePathProtocol {
    func stringPath() -> String {
        return self
    }
    func filePathUrl() -> URL {
        return URL(fileURLWithPath: self)
    }
}
