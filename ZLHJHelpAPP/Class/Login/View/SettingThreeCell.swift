//
//  SettingThreeCell.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/9/19.
//  Copyright © 2019 VIC. All rights reserved.
//

import UIKit

class SettingThreeCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var value: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
