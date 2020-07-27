//
//  VertifyLoginPassword.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/10/21.
//  Copyright © 2019 VIC. All rights reserved.
//

import UIKit

class VertifyLoginPassword: UIView,NibLoadable {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var leftTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var cancel: UIButton!
    
    @IBOutlet weak var ok: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.colorWithHex(hex: 0xEFEFF3)

    }
    
}
