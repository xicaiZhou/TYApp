//
//  PDFReadVC.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/12/20.
//  Copyright © 2019 VIC. All rights reserved.
//

import UIKit
import WebKit
import PKHUD

import Foundation
import Alamofire

class PDFReadVC: BaseViewController {
    lazy var webView: WKWebView = {
        let myWebView = WKWebView.init(frame: CGRect(x: 0, y: KHeight_NavBar, width: kScreenWidth, height: kScreenHeight - KHeight_NavBar))
        return myWebView
    }()
    
    var pdfPath = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "征信授权书";
        view.addSubview(webView);
        view.backgroundColor = .white
        self.setupBarButtonItemSelectorName {
            self.navigationController?.popViewController(animated: true)
        }
        view.addSubview(webView)
        self.setupBarButtonItemSelectorName { [weak self] in
            
            self?.navigationController?.dismiss(animated: true, completion: {
                
            })
        }
        down()

    }
    
    func down(){
        //指定下载路径和保存文件名
        var z:URL = URL(string:pdfPath)!
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("file1/\(self.pdfPath)")
            z = fileURL
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        showHUD()
        Alamofire.download(URLRequest(url: URL(string: pdfPath)! ), to: destination)
        .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                       print("Download Progress: \(progress.fractionCompleted)")
               }
        .responseData { response in
            if let data = response.result.value {

                DispatchQueue.main.async {
                    self.hideHUD()
                    if let path = response.destinationURL?.path{
                        
                        let urlStr = URL.init(fileURLWithPath:path);
                        let data = try! Data(contentsOf: urlStr)
                        self.webView.load(data, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: NSURL() as URL)
                    }
                    
                }
            }
        }
        
        
   
    }
    
    
}
