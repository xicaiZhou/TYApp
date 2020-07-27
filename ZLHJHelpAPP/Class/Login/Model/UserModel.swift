//
//  UserModel.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/9/6.
//  Copyright © 2019 VIC. All rights reserved.
//

import UIKit

import KakaJSON
struct UserModel: Convertible{
    
    
    var loginSysUserVo: LoginSysUserVo?
    var token:String = ""
    
}
struct LoginSysUserVo: Convertible {
    var departmentId: String = ""
    var departmentName: String = ""
    var gender: String = ""
    var id: String = ""
    var nickname: String = ""
    var roleCode: String = ""
    var roleId: String = ""
    var roleName: String = ""
    var state: String = ""
    var username: String = ""
}
