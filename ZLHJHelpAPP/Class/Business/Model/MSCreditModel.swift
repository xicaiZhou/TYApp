//
//  MSCreditModel.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/12/20.
//  Copyright © 2019 VIC. All rights reserved.
//

import KakaJSON

struct MSCreditModel: Convertible {

    var NOT_IDCard: String = ""
    var confirmIncome: String = ""
    var confirmPhone: String = ""
    var creditFlag: String = ""
    var customerName: String = ""
    var faceSignFlag: String = ""
    var fileName1: String = ""
    var fileName2: String = ""
    var fileName3: String = ""
    var guarantorType: String = ""
    var idNum: String = ""
    var idType: String = ""
    var income: String = ""
    var index: String = ""
    var isBlack: String = ""
    var isBlackFlag: String = ""
    var isUpload: String = ""
    var loanID: String = ""
    var loanNumber: String = ""
    var phone: String = ""
    var teleState: String = ""
    var userId: String = ""
    var userType: String = ""
    var credentials1: Credentials?
    var credentials2: Credentials?
    var credentials3: Credentials?
    var credentials1Arr : [String]?
    var credentials2Arr : [String]?
    var credentials3Arr : [String]?


}
struct Credentials: Convertible {
    var credentials: String = ""
    var filePaths: String = ""
    var fileUid: String = ""
}
