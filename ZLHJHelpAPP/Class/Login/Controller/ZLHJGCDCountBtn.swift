//
//  ZLHJGCDCountBtn.swift
//  ZLHJHelpAPP
//
//  Created by zhy on 2020/1/3.
//  Copyright © 2020 VIC. All rights reserved.
//

import UIKit

typealias ActionBlock = () -> ()
typealias cancelBlock = () -> ()

class ZLHJGCDCountBtn: NSObject {
    static let share = ZLHJGCDCountBtn()
    lazy var timerContainer = [String : DispatchSourceTimer]()
    
    /// 创建一个名字为loginCountBtn的定时
    ///
    /// - Parameters:
    ///   - name: 定时器的名字
    ///   - timeInterval: 时间间隔
    ///   - queue: 线程
    ///   - repeats: 是否重复
    ///   - action: 执行的操作
    func scheduledDispatchTimer(withName name:String?, timeInterval:Double, queue:DispatchQueue, repeats:Bool, action:@escaping ActionBlock ) {
        if name == nil {
            return
        }
        var timer = timerContainer[name!]
        if timer==nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
            timer?.resume()
            timerContainer[name!] = timer
        }
        timer?.schedule(deadline: .now(), repeating: timeInterval, leeway: .milliseconds(100))
        timer?.setEventHandler(handler: { [weak self] in
            action()
            if repeats==false {
                self?.destoryTimer(withName: name!, action: {
                    
                })
            }
        })
        
    }
    
    /// 销毁名字为name的计时器
    ///
    /// - Parameter name: 计时器的名字
    func destoryTimer(withName name:String?, action:@escaping cancelBlock ) {
        let timer = timerContainer[name!]
        if timer == nil {
            return
        }
        timerContainer.removeValue(forKey: name!)
        timer?.cancel()
        print("销毁倒计时按钮的定时器===\(name!)")
        action()
    }
    
    
    /// 检测是否已经存在名字为loginCountBtn的计时器
    ///
    /// - Parameter name: 计时器的名字
    /// - Returns: 返回bool值
    func isExistTimer(withName name:String?) -> Bool {
        if timerContainer[name!] != nil {
            return true
        }
        return false
    }
    
}
