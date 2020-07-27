//
//  BaseViewController.swift
//  renrendai-swift
//
//  Created by 周希财 on 2019/8/7.
//  Copyright © 2019 VIC. All rights reserved.
//

import UIKit
import Toast_Swift
import RxCocoa
import RxSwift
import HEPhotoPicker
import PKHUD


typealias BarBlock = () -> ()

typealias camera = ( [UIImage]) -> ()

class BaseViewController: UIViewController {

    var block:camera?
    
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        AudioManager.shared.openBackgroundAudioAutoPlay = true

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    func setupRightBarButtonItemSelectorName(text: String, block: @escaping BarBlock) -> UIButton{
        
        let button : UIButton = UIButton.init(type: UIButton.ButtonType.system)
        button.frame = CGRect(x: -20, y: 0, width: 90, height: 30)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.setTitleColor(systemColor, for: UIControl.State.normal)
        button.setTitle(text, for: UIControl.State.normal)
        button.setTitle(text, for: UIControl.State.highlighted)
        button.rx.tap
            .subscribe(onNext: {
                block()
            })
            .disposed(by: disposeBag)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        return button

    }
    func setupRightBarButtonItemSelectorName(imageName: String, block: @escaping BarBlock) -> UIButton {
        
        let button : UIButton = UIButton.init(type: UIButton.ButtonType.system)
        button.frame = CGRect(x: -20, y: 0, width: 30, height: 30)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.setTitleColor(systemColor, for: UIControl.State.normal)
        button.setImage(UIImage(named: imageName)!.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(UIImage(named: imageName)!.withRenderingMode(.alwaysOriginal), for: .selected)
        button.rx.tap
            .subscribe(onNext: {
                block()
            })
            .disposed(by: disposeBag)
        button.isHidden = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        return button

    }
    
    
    func setupBarButtonItemSelectorName(text:String = "返回", block: @escaping BarBlock){
        
        let button : UIButton = UIButton.init(type: UIButton.ButtonType.system)
        let barButton = UIBarButtonItem.init(customView: button)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0);
        self.navigationItem.leftBarButtonItem = barButton
        button.setTitle(text, for: UIControl.State.normal)
        button.setTitle(text, for: UIControl.State.highlighted)
        button.setTitleColor(systemColor, for: UIControl.State.normal)
        button.setImage(UIImage(named: "ic_turn")!.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(UIImage(named: "ic_turn")!.withRenderingMode(.alwaysOriginal), for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.rx.tap
            .subscribe(onNext: { 
                block()
            })
            .disposed(by: disposeBag)
    }

    
    // 获取当前显示的ViewController
    class func currentViewController(base: UIViewController? = Window!.rootViewController) -> BaseViewController?
    {
        if let nav = base as? UINavigationController
        {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController
        {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController
        {
            return currentViewController(base: presented)
        }
        return base as? BaseViewController
    }
    
    deinit {
        print("==============","\(self)","被销毁")
    }
    
    func showToast(_ message: String?){
        main { 
            self.view.makeToast(message,position:.top)
        }
    }
    
    func showHUD(){
        main{
            HUD.show(.progress)
        }
    }
    func hideHUD(){
        main{
            HUD.hide()
        }
    }

}
extension BaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, HEPhotoPickerViewControllerDelegate{
    
    func open(maxCountOfImage:Int = 9, result: @escaping camera){
        block = result
                
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)

        if isPad {
            alertVC.popoverPresentationController?.sourceView = self.view
            alertVC.popoverPresentationController?.permittedArrowDirections = []
            alertVC.popoverPresentationController?.sourceRect = CGRect(origin:self.view.center, size: CGSize(width:1, height: 1))
            
        }
       
        let action1 = UIAlertAction(title: "拍照", style:.default) { (action) in
            
            if PhotoTool.IsOpenCamera(){
                self.openCamera()
            }else{
                PhotoTool.requestAccess(authorized: {
                    self.openCamera()
                }, rejected: {
                    Alert.showAlert2(self, title: "提示", message: "请开启相机功能", alertTitle1: "开启", style1: .default, confirmCallback1: {
                        PhotoTool.openIphoneSetting()
                    }, alertTitle2: "取消", style2: .cancel, confirmCallback2: {
                        
                    });
                })
            }
        }
        let action2 = UIAlertAction(title: "从相册选择", style:.default) { (action) in

            if PhotoTool.canAccessPhotoLib(){
                self.openAlbum(maxCountOfImage:maxCountOfImage)
            }else{
                PhotoTool.requestAuthorizationForPhotoAccess(authorized: {
                                   self.openAlbum(maxCountOfImage:maxCountOfImage)

                }, rejected: {
                    Alert.showAlert2(self, title: "提示", message: "请开启相册功能", alertTitle1: "开启", style1: .default, confirmCallback1: {
                        PhotoTool.openIphoneSetting()
                    }, alertTitle2: "取消", style2: .cancel, confirmCallback2: {
                        
                    });
                })
                
            }

        }
        let action3 = UIAlertAction(title: "取消", style:.cancel) { (action) in

        }

        alertVC.addAction(action1)
        alertVC.addAction(action2)
        alertVC.addAction(action3)
        self.present(alertVC, animated: true, completion: nil)
        
      
    }
    
    func openAlbum(maxCountOfImage:Int){
        // 配置项
        let option = HEPickerOptions.init()
        // 图片和视频只能选择一种
        option.mediaType = .image
        // 选择图片的最大个数
        option.maxCountOfImage = maxCountOfImage
        // 创建选择器
        let picker = HEPhotoPickerViewController.init(delegate: self, options: option)
        picker.modalPresentationStyle = .fullScreen
        // 弹出
        self.hePresentPhotoPickerController(picker: picker, animated: true)
    }
    func openCamera(){
        let IPC = UIImagePickerController()
        IPC.sourceType = .camera
        IPC.allowsEditing = true
        IPC.delegate = self
        self.present(IPC, animated: true) {}
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePickerc = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
            main {
                self.block!([imagePickerc])
                self.dismiss(animated: true, completion: nil)
            }
    }
    
    func pickerController(_ picker: UIViewController, didFinishPicking selectedImages: [UIImage], selectedModel: [HEPhotoAsset]) {
        
            main {
                 self.block!(selectedImages)
            }
    }
}
