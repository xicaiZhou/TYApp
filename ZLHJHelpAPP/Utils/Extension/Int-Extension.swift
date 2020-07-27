//
//  Int-Extension.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/10/24.
//  Copyright © 2019 VIC. All rights reserved.
//

import Foundation

extension Int {
    
    func getAmountString() -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        
        let amount = formatter.string(from: NSNumber(value: self)) ?? ""
        
        return amount
    }
    
}
