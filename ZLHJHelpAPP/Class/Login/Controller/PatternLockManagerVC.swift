//
//  PatternLockManagerVC.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/9/19.
//  Copyright © 2019 VIC. All rights reserved.
//

import UIKit
import JXPatternLock
import RxCocoa
import RxSwift



enum PasswordConfigType {
    case setup
    case modify
    case vertify
}



class PatternLockManagerVC: BaseViewController {
    
    fileprivate let SettingThreeCellIdentifier       = "SettingThreeCellIdentifier"
    fileprivate let SettingFourCellIdentifier       = "SettingFourCellIdentifier"
    
    
    var iSGesLogin: Bool = false
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x:0, y:KHeight_NavBar, width:kScreenWidth, height:kScreenHeight - KHeight_NavBar), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView(frame:.zero)
        tableView.isScrollEnabled = false
        tableView.register(UINib(nibName: "SettingThreeCell", bundle: nil), forCellReuseIdentifier: SettingThreeCellIdentifier)
        tableView.register(UINib(nibName: "SettingFourCell", bundle: nil), forCellReuseIdentifier: SettingFourCellIdentifier)
        return tableView

    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "手势管理"
        self.view.backgroundColor = UIColor.white
        self.setupBarButtonItemSelectorName { [weak self] in
            
            if Utils.currentPassword() == "999999999999" && UserDefaults.standard.bool(forKey: "iSGesLogin"){
                Alert.showAlert2(self!, title: "提示", message: "您还没有设置手势密码！", alertTitle1: "设置密码", style1: .default, confirmCallback1: {
                    let vc = PatternLockSettingVC()
                    vc.config = ArrowConfig()
                    vc.type = .setup
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                }, alertTitle2: "返回", style2: .cancel, confirmCallback2: {
                    UserDefaults.standard.set(false, forKey: "iSGesLogin")
                    self?.navigationController?.popViewController(animated: true)
                });
            }else{
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        iSGesLogin = Utils.userDefaultRead(key: "iSGesLogin") as! Bool
        view.addSubview(tableView)
    }

}
extension PatternLockManagerVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return iSGesLogin ? 2 : 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell: SettingFourCell = tableView.dequeueReusableCell(withIdentifier: SettingFourCellIdentifier, for: indexPath) as! SettingFourCell
            cell.title.text =  "手势开关"
            cell.muSwitch.isUserInteractionEnabled = true
            cell.muSwitch.addTarget(self, action: #selector(switchDidChange(_:)), for: .valueChanged)
            cell.muSwitch.setOn(iSGesLogin, animated: true)

            return cell
                
        }else {
            let cell: SettingThreeCell = tableView.dequeueReusableCell(withIdentifier: SettingThreeCellIdentifier, for: indexPath) as! SettingThreeCell
//            if indexPath.row == 0{
                cell.title.text = "修改密码"
                cell.value.text = ""
//            }else{
//                cell.title.text = "修改密码"
//                cell.value.text = ""
//            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 45
    }
    
    @objc
    func switchDidChange(_ sender: UISwitch){
        //打印当前值
        if iSGesLogin && Utils.currentPassword()!.count > 0 {
            let vc = PatternLockSettingVC()
            vc.config = ArrowConfig()
            vc.type = .vertify
            self.tableView.reloadData()
            vc.vertifyScuuess = {
                self.iSGesLogin = !self.iSGesLogin
                UserDefaults.standard.set(self.iSGesLogin, forKey: "iSGesLogin") // 用户是否运行手势登录
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)

        }else{
            iSGesLogin = !iSGesLogin
            UserDefaults.standard.set(self.iSGesLogin, forKey: "iSGesLogin") // 用户是否运行手势登录
            self.tableView.reloadData()

            let vc = PatternLockSettingVC()
            vc.config = ArrowConfig()
            vc.type = .setup
            self.navigationController?.pushViewController(vc, animated: true)
        }
      

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        
        let vc = PatternLockSettingVC()
        vc.config = ArrowConfig()
        vc.type = .vertify
        self.tableView.reloadData()
        self.navigationController?.pushViewController(vc, animated: true)
        vc.vertifyScuuess = {
            
            let vc1 = PatternLockSettingVC()
            vc1.config = ArrowConfig()
            vc1.type = .setup
            self.navigationController?.pushViewController(vc1, animated: true)
            
        }
        
    }
    
    
}
