//
//  AppDelegate.swift
//  renrendai-swift
//
//  Created by 周希财 on 2019/8/6.
//  Copyright © 2019 VIC. All rights reserved.
//
import UIKit

extension UIColor {
    

    /// 使用十六进制数字生成颜色
    ///
    /// - Parameter hex: hex，格式 0xFFEEDD
    /// - Returns: UIColor
    class func colorWithHex(hex:u_int) -> UIColor {
        
        let red:u_int = u_int((hex & 0xFF0000) >> 16)
        let green:u_int = u_int((hex & 0x00FF00) >> 8)
        let blue:u_int = (u_int(hex & 0x0000FF))
        return RGB(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue))
    }
    
    /// 根据RGB值创建颜色
    class  func RGB(red:CGFloat,  green:CGFloat,  blue:CGFloat ,_ alpha:CGFloat = 1) -> UIColor {
        //处理数值
        if red > 255.0 || red < 0 || green > 255.0 || green < 0  || blue > 255.0 || blue < 0 || alpha > 1 || alpha < 0 {
            return UIColor.white
        }else{
            return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
        }
    }
    //返回随机颜色
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
              let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
              }
              }

    
    
    
}
