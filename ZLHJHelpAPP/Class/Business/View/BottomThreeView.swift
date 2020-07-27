//
//  BottomThreeView.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/12/23.
//  Copyright © 2019 VIC. All rights reserved.
//

import UIKit

class BottomThreeView: UIView,NibLoadable {

    @IBOutlet weak var PerviousStepBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var creditBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        PerviousStepBtn.backgroundColor = systemColor
        creditBtn.backgroundColor = systemColor
        nextBtn.backgroundColor = systemColor
        PerviousStepBtn.height = 50
        creditBtn.height = 50
        nextBtn.height = 50
    }
}
