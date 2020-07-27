//
//  Array-Extension.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/9/17.
//  Copyright © 2019 VIC. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    
    static func delLabelNameForKey(changeArr: [Dictionary<String,Any>] ) -> [Dictionary<String,Any>]{
        
        if changeArr.isEmpty {return changeArr}
        
        var resultArr:[Dictionary<String,Any>] = [Dictionary<String,Any>]()
        
        for dic in changeArr {
            var resultDic:[String:Any] = [:]
            for str in dic.keys {
                
                let value = dic[str] as Any
                let key:String = str.contains(".") ? str.components(separatedBy: ".").first! : str
                resultDic.updateValue(value, forKey: key )
            }
            resultArr.append(resultDic)
        }

        
        return resultArr
    }
    
    func getAllvalues() -> Array<String>{
        
        var temp: Array<String> = []
        for dic in self{
            temp.append((dic as! Dictionary<String, String>).values.first!)
        }
        
        return temp
        
    }
    func getAllKeys() -> Array<String>{
        
        var temp: Array<String> = []
        for dic in self{
            temp.append((dic as! Dictionary<String, String>).keys.first!)
        }
        
        return temp
        
    }
    
    
    
    
    
    
}
