//
//  Data-Extension.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/9/25.
//  Copyright © 2019 VIC. All rights reserved.
//

import Foundation
extension Data{
    func getImageFormat()->(String?){
        var c:UInt8 = UInt8()
        self.copyBytes(to: &c, count: 1)
        switch c {
        case 0xFF:
            return "image/jpeg"
        //  return ".jpg"
        case 0x89:
            return "image/png"
        //  return ".png"
        case 0x47:
            return "image/gif"
        //  return ".gif"
        case 0x4D:
            return "image/tiff"
        //  return ".tiff"
        default:
            return "image/jpeg"
            //  return ".png"
        }
    }
}
