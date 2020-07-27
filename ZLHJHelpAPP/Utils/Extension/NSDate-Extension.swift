//
//  AppDelegate.swift
//  renrendai-swift
//
//  Created by 周希财 on 2019/8/6.
//  Copyright © 2019 VIC. All rights reserved.
//

import UIKit
/**
 *   properties
 */
extension Date{
    /// 获取当前 秒级 时间戳 - 10位
        var timeStamp : String {
            let timeInterval: TimeInterval = self.timeIntervalSince1970
            let timeStamp = Int(timeInterval)
            return "\(timeStamp)"
        }

        /// 获取当前 毫秒级 时间戳 - 13位
        var milliStamp : String {
            let timeInterval: TimeInterval = self.timeIntervalSince1970
            let millisecond = CLongLong(round(timeInterval*1000))
            return "\(millisecond)"
        }

    func getComponent(component: Calendar.Component) -> Int {
        let calendar = Calendar.current
        return calendar.component(component, from: self)
    }
    /// 根据时间获取年
    public var Year: Int {
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self).year!
    }
    
    
    /// 根据时间获取月份
    public var Month: Int {
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self).month!
    }
    
    
    /// 根据时间获取日期
    public var Day: Int {
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self).day!
    }
    
    
    /// 根据时间获取时
    public var Hour: Int {
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self).hour!
    }
    
    
    /// 根据时间获取分
    public var Minute: Int {
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self).minute!
    }
    
    
    /// 根据时间获取秒
    public var Second: Int {
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self).second!
    }
    
    static func afterDay(days:Int,formatter:String) -> String{
        //获取当前时间
        let now = Date()
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let sum = 86400 * days + Int(timeInterval);
        let new = Date(timeIntervalSince1970: TimeInterval(sum));
        return new.dateToString(formatter: formatter)
        
    }
    
    
}

extension Date {
    
    static func getCurrentTime() -> String {
        
        let nowDate = NSDate()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
        
    }
    
    /// 字符串z -> Date
    ///
    /// - Parameters:
    ///   - dateStr: Date字符串
    ///   - formatter: 格式
    /// - Returns: Date
    static func dateWithDateStr(_ dateStr : String, formatter:String) -> Date {
        
        let format = DateFormatter()
        format.dateFormat = formatter
        
        return format.date(from: dateStr)!
        
    }
    
    
    /// date -> 字符串
    ///
    /// - Parameter formatter: 格式
    /// - Returns: String
    func dateToString(formatter:String)->String{
    
        let format = DateFormatter();
        format.dateFormat = formatter;
        return format.string(from: self as Date)
        
    }
    
    
}
