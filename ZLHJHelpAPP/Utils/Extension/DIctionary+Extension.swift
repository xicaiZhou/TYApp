//
//  DIctionary+Extension.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/12/31.
//  Copyright © 2019 VIC. All rights reserved.
//

import Foundation
import UIKit

extension Dictionary {
    
    static func delLabelNameForKey(changeDic: [String:Any]) -> [String:Any]{
        
        if changeDic.isEmpty {return changeDic}
        
        var resultDic:[String:Any] = [:]
        
        for str in changeDic.keys {
            
            let value = changeDic[str] as Any
            let key:String = str.contains(".") ? str.components(separatedBy: ".").first! : str
            resultDic.updateValue(value, forKey: key )
        
        }
        
        
        
        
        return resultDic
    }
    static func toJSONString(dict:Dictionary)->String{

        let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)

        let strJson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

        return strJson! as String

    }


    
    
}


extension NSDictionary {
    
    //检查key是否存在
    func objectForCheckedKey(key:AnyObject)-> (AnyObject){
        let object = self.object(forKey: key)
        if object == nil  {
            return "" as (AnyObject)
        }
        return object as (AnyObject)
    }
    
    
    func stringForCheckedKey(key:String)-> (AnyObject){
        let object = self.object(forKey: key)
        if object is String  {
            return object as (AnyObject)
        }
        if object is NSNumber{
            return object as (AnyObject)
        }
        return "" as (AnyObject)
    }
}
