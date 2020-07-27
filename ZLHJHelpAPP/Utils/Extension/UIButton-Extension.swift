//
//  UIButton-Extension.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/9/22.
//  Copyright © 2019 VIC. All rights reserved.
//

import Foundation
extension UIButton {
    
    

    func countDownWithInterval(interval: Int = 60, text:String){
//        func countDownWithInterval(interval: Int = 60, text:String){

        var timeCount = interval
        
        // 创建时间源
        
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        
        timer.schedule(deadline: .now(), repeating: .seconds(1))
        
        timer.setEventHandler {
            
            timeCount -= 1
            if timeCount <= 0 {
                main {
                self.setTitle(text, for: .normal)
                self.setTitleColor(.white, for: .normal)
                self.backgroundColor = systemColor
                self.isEnabled = true
                    timer.cancel()

                }
            }else {
                main {
                    print("\(timeCount)s")
                    self.setTitle("\(timeCount)s", for: .normal)
                    self.setTitleColor(.white, for: .normal)
                    self.backgroundColor = textGrayColor
                    self.isEnabled = false
                }
            }
        }
        // 启动时间源
        timer.resume()
    }

    
    // 图片和文字 共存，你懂的
    // 使用样例 https://blog.csdn.net/u013406800/article/details/55506039
    
    @objc func set(image anImage: UIImage?, title: String,
                   titlePosition: UIView.ContentMode, additionalSpacing: CGFloat, state: UIControl.State){
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
         
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    
    private func positionLabelRespectToImage(title: String, position: UIView.ContentMode,
        spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont!])
         
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
         
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),
                left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),
                left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
         
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
    
    
}
