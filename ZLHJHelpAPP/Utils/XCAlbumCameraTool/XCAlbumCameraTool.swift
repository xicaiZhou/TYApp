//
//  XCAlbumCameraTool.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/9/18.
//  Copyright © 2019 VIC. All rights reserved.
//

import Foundation
import Photos


class XCAlbumCameraTool: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let IPC = UIImagePickerController()

    func open(){
        
        IPC.sourceType = .camera
        IPC.allowsEditing = true
        BaseViewController.currentViewController()!.present(IPC, animated: true) {
            self.IPC.delegate = self
        }
        
//        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
//
//        let action1 = UIAlertAction(title: "拍照", style:.default) { (action) in
//            if self.IsOpenCamera(){
//                self.openCamera()
//            }else{
//
//                Alert.showAlert1(BaseViewController.currentViewController()!, title: "提示", message: "请开启相机功能", alertTitle: "前往开启", style: .default) {
//                    let url:URL = URL(string: UIApplication.openSettingsURLString)!
//                    if UIApplication.shared.canOpenURL(url){
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    }
//                }
//            }
//
//        }
//        let action2 = UIAlertAction(title: "从相册选择", style:.default) { (action) in
//
//            if self.IsOpenAlbum(){
//                self.openAlbum()
//            }else{
//                Alert.showAlert1(BaseViewController.currentViewController()!, title: "提示", message: "请开启相机功能", alertTitle: "前往开启", style: .default) {
//                    let url:URL = URL(string: UIApplication.openSettingsURLString)!
//                    if UIApplication.shared.canOpenURL(url){
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    }
//                }
//            }
//
//        }
//        let action3 = UIAlertAction(title: "取消", style:.cancel) { (action) in
//
//        }
//
//        alertVC.addAction(action1)
//        alertVC.addAction(action2)
//        alertVC.addAction(action3)
//        BaseViewController.currentViewController()!.present(alertVC, animated: true, completion: nil)
       
    }
    
    func openCamera(){
        let IPC = UIImagePickerController()
        IPC.sourceType = .camera
        IPC.allowsEditing = true
        BaseViewController.currentViewController()!.present(IPC, animated: true) {
            IPC.delegate = self
        }

    }
    
    func openAlbum(){
        
    }
   

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
    }
}

