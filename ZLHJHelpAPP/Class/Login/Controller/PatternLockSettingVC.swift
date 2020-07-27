//
//  PatternLockSettingVC.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/9/20.
//  Copyright © 2019 VIC. All rights reserved.
//

import UIKit
import JXPatternLock
import PKHUD
import JXPopupView


typealias VertifyScuuess = () -> ()
typealias setupSuccess = () -> ()
typealias setupFail = () -> ()

extension CALayer {
    func shakeBody() {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        keyFrameAnimation.values = [0, 16, -16, 8, -8 ,0]
        keyFrameAnimation.duration = 0.3
        keyFrameAnimation.repeatCount = 1
        add(keyFrameAnimation, forKey: "shake")
    }
}


class PatternLockSettingVC: BaseViewController, PatternLockViewDelegate {
    
    var lockView: PatternLockView!
    var config: PatternLockViewConfig!
    var type: PasswordConfigType!
    var vertifyScuuess:VertifyScuuess?
    var stSuccess : setupSuccess?
    var stFail:setupFail?
     var pathView: PatternLockPathView!
     var tipsLabel: UILabel!
     var currentPassword: String = ""
     var firstPassword: String = ""
     var secondPassword: String = ""
     var canModify: Bool = false
     var isLogin: Bool = false
     var popupView:JXPopupView!
     var maxErrorCount: Int = 5
     var currentErrorCount: Int = 0
    
    let otherBtn:UIButton = {
        let btn = UIButton.button(title: "账号密码登录?", font: UIFont.systemFont(ofSize: 15), titleColor:systemColor)
        btn.frame = CGRect(x: kScreenWidth / 2 - 50, y: kScreenHeight - 40, width: 100, height: 20)
        return btn
    }()
    let loginPasswordBtn:UIButton = {
        let btn = UIButton.button(title: "验证登录密码", font: UIFont.systemFont(ofSize: 15), titleColor:systemColor)
        btn.frame = CGRect(x: kScreenWidth / 2 - 50, y: kScreenHeight - 40, width: 100, height: 20)
        return btn
    }()
    
    fileprivate lazy var vertifyLoginPassword : VertifyLoginPassword  = {
        var View = VertifyLoginPassword.loadFromNib()
        View.width = 300
        View.height = 165
        View.center = view.center
       
        return View
    }()
 
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "手势"
    
        self.view.backgroundColor = UIColor.white
        self.setupBarButtonItemSelectorName { [weak self] in
            if((self?.stFail) != nil){
                self!.stFail!()
            }
            self?.navigationController?.popViewController(animated: true)
        }
        maxErrorCount = Utils.getMaxErrorCount()

        lockView = PatternLockView(config: config)
        lockView.delegate = self
        
        let lockWidth = 300
        lockView.bounds = CGRect(x: 0, y: 0, width: lockWidth, height: lockWidth)
        lockView.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        view.addSubview(lockView)
        tipsLabel = UILabel()
        tipsLabel.textColor = .lightGray
        view.addSubview(tipsLabel)
        tipsLabel.translatesAutoresizingMaskIntoConstraints = false
        tipsLabel.bottomAnchor.constraint(equalTo: lockView.topAnchor, constant: -40).isActive = true
        tipsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        var pathConifg = LockConfig()
        pathConifg.gridSize = CGSize(width: 10, height: 10)
        pathConifg.matrix = Matrix(row: 3, column: 3)
        let tintColor = UIColor.RGB(red: 18, green: 143, blue: 235, 1)
        pathConifg.initGridClosure = {(matrix) -> PatternLockGrid in
            let gridView = GridView()
            let outerStrokeLineWidthStatus = GridPropertyStatus<CGFloat>.init(normal: 1, connect: 1, error: 1)
            let outerStrokeColorStatus = GridPropertyStatus<UIColor>(normal: tintColor, connect: tintColor, error: UIColor.red)
            let outerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: tintColor, error: UIColor.red)
            gridView.outerRoundConfig = RoundConfig(radius: 5, lineWidthStatus: outerStrokeLineWidthStatus, lineColorStatus: outerStrokeColorStatus, fillColorStatus: outerFillColorStatus)
            gridView.innerRoundConfig = RoundConfig.empty
            return gridView
        }



        let lineView = ConnectLineView()
        lineView.lineColorStatus = .init(normal: tintColor, error: .red)
        lineView.lineWidth = 1
        pathConifg.connectLine = lineView
        
        pathView = PatternLockPathView(config: pathConifg)
        view.addSubview(pathView)
        pathView.translatesAutoresizingMaskIntoConstraints = false
        pathView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pathView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pathView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pathView.bottomAnchor.constraint(equalTo: tipsLabel.topAnchor, constant: -10).isActive = true
        
        
        if type == .vertify{
            if maxErrorCount <= 0 {
                lockView.isUserInteractionEnabled = false
                if isLogin {
                    if UserDefaults.standard.bool(forKey: "iSTouchIDOrFaceID") {
                        self.showErrorText("手势验证错误次数超限,请使用指纹或面部验证！")
                    }else {
                        Window?.rootViewController = LoginVC()
                    }
                }else{
                    if UserDefaults.standard.bool(forKey: "iSTouchIDOrFaceID") {
                        self.showErrorText("手势验证错误次数超限,请使用指纹或面部验证！")
                    }else {
                        self.showErrorText("手势验证错误次数超限,请使用登录密码验证！")
                    }
                }
                
            }
        }
        
        
        switch type! {
        case .setup:
            tipsLabel.text = "绘制解锁图案"
        case .modify:
            tipsLabel.text = "请输入原手势密码"
            pathView.isHidden = true
        case .vertify:
            if maxErrorCount > 0{
                tipsLabel.text = "请输入解锁密码"
            }
            if isLogin{
                view.addSubview(otherBtn)
            }else {
                view.addSubview(loginPasswordBtn)
            }
            pathView.isHidden = true
        }
        vertifyLoginPassword.cancel.rx.tap.subscribe(onNext: { [weak self] in
           
            self?.popupView.dismiss(animated: true, completion: nil)
        }).disposed(by:disposeBag)
        
        vertifyLoginPassword.ok.rx.tap.subscribe(onNext: { [weak self] in
           
            if  Utils.getPassword() == self?.vertifyLoginPassword.textField.text {
                self?.navigationController?.popViewController(animated: true)
               self?.vertifyScuuess!()
            }else{
                HUD.flash(.labeledError(title: "密码错误！！", subtitle: ""))
            }
           
        }).disposed(by:disposeBag)
        
        otherBtn.rx.tap.subscribe(onNext: {
           
            Window?.rootViewController = LoginVC()
           
        }).disposed(by:disposeBag)
        
        loginPasswordBtn.rx.tap.subscribe(onNext: { [weak self] in
                  
            self?.showReasonView()
                  
        }).disposed(by:disposeBag)
        
        if type! == .vertify{
            if UserDefaults.standard.bool(forKey: "iSTouchIDOrFaceID"){
                FingureCheckTool.userFigerprintAuthenticationTipStr(withtips: "验证登录") { (result) in
                    if result == .success {
                        self.navigationController?.popViewController(animated: true)
                        self.vertifyScuuess!()
                    }
                }
            }
        }
        
    }
    
    

    
    //MARK: - Event
    @objc func didRestButtonClicked() {
        showNormalText("绘制解锁图案")
        currentPassword = ""
        firstPassword = ""
        secondPassword = ""
        pathView.reset()
        lockView.reset()
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func showResetButtonIfNeeded() {
        guard type == .setup || type == .modify else {
            return
        }
        if !firstPassword.isEmpty {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "重设", style: .plain, target: self, action: #selector(didRestButtonClicked))
        }
    }
    
    func shouldShowErrorWithSavedAndCurrentPassword() -> Bool {
        if currentPassword == Utils.currentPassword() {
            //当前密码与保存的密码相同，不需要显示error
            return false
        }else {
            return true
        }
    }
    
    func shouldShowErrorWithFirstAndSecondPassword() -> Bool {
        if firstPassword.isEmpty {
            //第一次密码还未配置，不需要显示error
            return false
        }else if firstPassword == currentPassword {
            //两次输入的密码相同，不需要显示error
            return false
        }else {
            return true
        }
    }
    
    func setupPassword() {
        if firstPassword.isEmpty {
            firstPassword = currentPassword
            showNormalText("再次绘制解锁图案")
        } else {
            secondPassword = currentPassword
            if firstPassword == secondPassword {
                Utils.updatePassword(firstPassword)
                let alert = UIAlertController(title: nil, message: "恭喜您！密码设置成功", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "确定", style: .cancel){ (_) in
                    self.stSuccess!()
                    Utils.saveMaxErrorCount(count: 5)
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(confirm)
                present(alert, animated: true, completion: nil)
            } else {
                showResetButtonIfNeeded()
                showErrorText("与上次绘制不一致，请重新绘制")
                secondPassword = ""
            }
        }
    }
    
    func showErrorText(_ text: String) {
        tipsLabel.text = text
        tipsLabel.textColor = .red
        tipsLabel.layer.shakeBody()
    }
    
    func showNormalText(_ text: String) {
        tipsLabel.text = text
        tipsLabel.textColor = .lightGray
    }
    
    func showPasswordError() {
        currentErrorCount += 1
        if currentErrorCount == maxErrorCount {
            //真实的业务代码是跳转到登录页面
            let alert = UIAlertController(title: nil, message: "错误次数已达上限", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "确定", style: .cancel){ (_) in
               
                if self.type == .vertify{
                    Utils.saveMaxErrorCount(count: 0)
                    self.lockView.isUserInteractionEnabled = false
                    if self.isLogin {
                        if UserDefaults.standard.bool(forKey: "iSTouchIDOrFaceID") {
                            self.showErrorText("手势验证错误次数超限,请使用指纹或面部验证！")
                        }else {
                            Window?.rootViewController = LoginVC()
                        }
                    }else{
                        if UserDefaults.standard.bool(forKey: "iSTouchIDOrFaceID") {
                            self.showErrorText("手势验证错误次数超限,请使用指纹或面部验证！")
                        }else {
                            self.showErrorText("手势验证错误次数超限,请使用登录密码验证！")
                        }
                    }
                    
                }else if self.type == .setup {
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
            alert.addAction(confirm)
            present(alert, animated: true, completion: nil)
        }else {
            showErrorText("密码错误，还可以输入\(maxErrorCount - currentErrorCount)次")
        }
    }
    
    func shouldHandlePathView() -> Bool {
        if firstPassword.isEmpty {
            //第一次的密码未输入，才需要更新path
            if type == .setup {
                return true
            }else if type == .modify {
                if canModify {
                    //修改时，第一次验证成功之后才需要更新path
                    return true
                }
            }
        }
        return false
    }
    
    //MARK: - PatternLockViewDelegate
    func lockView(_ lockView: PatternLockView, didConnectedGrid grid: PatternLockGrid) {
        print(grid.identifier)
        currentPassword += grid.identifier
        if shouldHandlePathView() {
            pathView.addGrid(at: grid.matrix)
        }
    }
    
    func lockViewDidConnectCompleted(_ lockView: PatternLockView) {
        if currentPassword.count < 4 {
            showErrorText("至少链接4个点，请重新输入")
            if shouldHandlePathView() {
                pathView.reset()
            }
            showResetButtonIfNeeded()
        } else {
            switch type! {
            case .setup:
                setupPassword()
            case .modify:
                if canModify {
                    setupPassword()
                } else {
                    if currentPassword == Utils.currentPassword() {
                        pathView.isHidden = false
                        showNormalText("绘制解锁图案")
                        canModify = true
                    } else {
                        showPasswordError()
                    }
                }
            case .vertify:
                if currentPassword == Utils.currentPassword() {
                    Utils.saveMaxErrorCount(count: 5)
                    navigationController?.popViewController(animated: true)
                    vertifyScuuess!()
                } else {
                    showPasswordError()
                }
            }
        }
        print(currentPassword)
        currentPassword = ""
    }
    
    func lockViewShouldShowErrorBeforeConnectCompleted(_ lockView: PatternLockView) -> Bool {
        if type == .vertify {
            return shouldShowErrorWithSavedAndCurrentPassword()
        }else if type == .setup {
            return shouldShowErrorWithFirstAndSecondPassword()
        }else if type == .modify {
            if !canModify {
                return shouldShowErrorWithSavedAndCurrentPassword()
            }else {
                return shouldShowErrorWithFirstAndSecondPassword()
            }
        }
        return false
    }

}
extension PatternLockSettingVC {
    fileprivate func showReasonView() {
       popupView = JXPopupView(containerView: self.view, contentView: vertifyLoginPassword, animator: JXPopupViewZoomInOutAnimator())
       //配置交互
       popupView.isDismissible = true
       popupView.isInteractive = true
       popupView.isPenetrable = false
       //- 配置背景
       popupView.backgroundView.style = JXPopupViewBackgroundStyle.solidColor
       popupView.backgroundView.blurEffectStyle = UIBlurEffect.Style.light
       popupView.backgroundView.color = UIColor.black.withAlphaComponent(0.7)
       popupView.display(animated: true, completion: nil)
    }
}
