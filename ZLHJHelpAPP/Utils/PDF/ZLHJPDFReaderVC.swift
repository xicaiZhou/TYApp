//
//  ZLHJPDFReaderVC.swift
//  ZLHJHelpAPP
//
//  Created by zhy on 2020/5/13.
//  Copyright © 2020 VIC. All rights reserved.
//

import UIKit
import PKHUD
import WebKit
import Foundation
import Alamofire

class ZLHJPDFReaderVC: BaseViewController, UIDocumentPickerDelegate {
    
    /// 要显示的pdf文档地址
    var url: String? {
        didSet {
            if url != nil{
                //                docRef = ZLHJPdfDocument.getPdfDocumentRef(urlString: url!)
            }
        }
    }
    
    /// 要显示的pdf文档
    //    private var docRef: CGPDFDocument? {
    //        didSet {
    //            totalPage = docRef?.numberOfPages
    //        }
    //    }
    
    /// 存数据的数组
    //    fileprivate var dataArray: Array<ZLHJPdfReaderView>? {
    //        get {
    //            var array = [ZLHJPdfReaderView]()
    //            for i in 0..<(totalPage ?? 0) {
    //                let pdfV = ZLHJPdfReaderView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), documentRef: docRef, pageNum: i)
    //                array.append(pdfV)
    //            }
    //            return array
    //        }
    //    }
    
    /// 一共多少页
    //    private var totalPage: Int?
    /// 下载进度
    lazy var downloadProgress: UIProgressView = {
        let downloadProgress = UIProgressView.init(progressViewStyle: .bar)
        downloadProgress.frame = CGRect(x: 0, y: KHeight_NavBar+5, width: kScreenWidth, height: 2)
        downloadProgress.progressTintColor = .orange
        downloadProgress.backgroundColor = .gray
        downloadProgress.isHidden = false
        return downloadProgress
    }()
    
    lazy var pdfWebImage: WKWebView = {
        let pdfWebImage = WKWebView.init(frame: CGRect(x: 0, y: KHeight_NavBar+2, width: kScreenWidth, height: kScreenHeight - KHeight_NavBar-2))
        return pdfWebImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "PDF"
        view.backgroundColor = UIColor.white
        self.setupBarButtonItemSelectorName { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(pdfWebImage)
        view.addSubview(downloadProgress)
        useWKWebViewLoadingdWithPDF()
        //        configePage()
        // dowloanPDF()
        
        
        //        let fileName = "ZLHJ***"
        //        let pathFile = FilePathUtils.setupFilePath(directory: .documents, name: fileName)
        //        let readData : Data? = FileUtils.readFile(filePath: pathFile.path)
        //        if readData == nil {
        //            downloadAnyFileWithSaveImage()
        //        }else {
        //            let deletePath = FilePathUtils.setupFilePath(directory: .documents, name: fileName)
        //            let deleteBool : Bool = FileUtils.deleteFile(filePath: deletePath.path)
        //            if deleteBool {
        //                downloadAnyFileWithSaveImage()
        //            }
        //        }
        
    }
    
    func useWKWebViewLoadingdWithPDF(){
        //指定下载路径和保存文件名
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("file1/\(String(describing: self.url))")
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        showHUD()
        Alamofire.download(URLRequest(url: URL(string: url!)! ), to: destination)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                
                DispatchQueue.main.async {
                    print("下载进度：\(progress.fractionCompleted)")
                    let pro: Double = Double(progress.fractionCompleted)
                    self.downloadProgress.setProgress(Float(pro), animated: true)
                    if pro == 1.0 {
                        self.downloadProgress.isHidden = true
                    }
                }
        }
        .responseData { response in
            if let data = response.result.value {
                if data.count > 0 {
                    DispatchQueue.main.async {
                        self.hideHUD()
                        if let path = response.destinationURL?.path{
                            
                            let urlStr = URL.init(fileURLWithPath:path);
                            let data = try! Data(contentsOf: urlStr)
                            self.pdfWebImage.load(data, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: NSURL() as URL)
                        }
                        
                    }
                }
            }
        }
    }
    
    
    /// 下载任何文件并保存到照片（如果是图像文件）或文件（如果是PDF）
    //    func downloadAnyFileWithSaveImage() {
    //        DispatchQueue.main.async {
    //            HUD.show(.progress)
    //        }
    //        let urlString = url
    //        let url = URL(string: urlString!)
    //        let fileName = String((url!.lastPathComponent)) as NSString
    //        // Create destination URL
    //        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    //        let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName)")
    //        // Create URL to the source file you want to download
    //        let fileURL = URL(string: urlString!)
    //        let sessionConfig = URLSessionConfiguration.default
    //        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
    //        let request = URLRequest(url:fileURL!)
    //        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
    //            if let tempLocalUrl = tempLocalUrl, error == nil {
    //                // Success
    //                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
    //                    print("Successfully downloaded. Status code: \(statusCode)")
    //                    DispatchQueue.main.async {
    //                        HUD.hide()
    //                    }
    //                }
    //                do {
    //                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
    //                    do {
    //                        //Show UIActivityViewController to save the downloaded file
    //                        let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
    //                        for indexx in 0..<contents.count {
    //                            if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
    //                                DispatchQueue.main.async { // Correct
    //                                   let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
    //                                   self.present(activityViewController, animated: true, completion: nil)
    //                                }
    //                            }
    //                        }
    //                    }
    //                    catch (let err) {
    //                        print("error: \(err)")
    //                    }
    //                } catch (let writeError) {
    //                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
    //                }
    //            }else {
    //                print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
    //            }
    //        }
    //        task.resume()
    //    }
    
    
    /// 下载pdf
    //    func dowloanPDF() {
    //        let pdfNSData = try? Data.init(contentsOf: NSURL.init(string: url!)! as URL, options: Data.ReadingOptions.init(rawValue: 0)) as CFData
    //
    //        let fileName = "ZLHJ"
    //        let pathFile = FilePathUtils.setupFilePath(directory: .documents, name: fileName)
    //        let readData : Data? = FileUtils.readFile(filePath: pathFile.path)
    //        if readData == nil {
    //            print("第一次来吧，小哥哥")
    //            let testFolderPath = FilePathUtils.setupFilePath(directory: .documents, name: "TestFolder/")
    //            let createResult = FileUtils.createFolder(basePath: .customPath(path: testFolderPath.path), folderName: fileName)
    //
    //            if createResult {
    //                print("大保健来一套")
    //                let pathWrite = FilePathUtils.setupFilePath(directory: .documents, name: fileName)
    //                let writeResult = FileUtils.writeFile(content: pdfNSData! as Data, filePath: pathWrite.path)
    //                if writeResult {
    //                    print("大哥，吃力不？")
    //
    //                    let url = URL(fileURLWithPath: Bundle.main.path(forResource: "help.pdf", ofType: nil)!)
    //
    //                    let iCloudDocument = ICloudDocumentPickerViewController(url: url, in: .exportToService)
    //                    iCloudDocument.delegate = self
    //                    self.present(iCloudDocument, animated: true) {}
    //
    //                }
    //            }
    //
    //        }else {
    //            let deletePath = FilePathUtils.setupFilePath(directory: .documents, name: fileName)
    //            let deleteBool : Bool = FileUtils.deleteFile(filePath: deletePath.path)
    //            if deleteBool {
    //                dowloanPDF()
    //            }
    //        }
    //    }
    
    
    /// 配置页面
    //    func configePage() -> Void {
    //        view.addSubview(collectionView)
    //    }
    
    
    /// 用于显示的collectionView
    //    lazy var collectionView: UICollectionView = {
    //
    //        let layout = UICollectionViewFlowLayout.init()
    //        layout.itemSize = self.view.frame.size
    //        layout.scrollDirection = .vertical
    //        layout.minimumLineSpacing = 0
    //        layout.minimumInteritemSpacing = 0
    //
    //        let collectionV = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
    //        collectionV.isPagingEnabled = true
    //        collectionV.register(ZLHJPDFCollectionViewCell.self, forCellWithReuseIdentifier: "XYJPDFCollectionViewCell")
    //        collectionV.dataSource = self
    //        collectionV.delegate = self
    //        collectionV.backgroundColor = UIColor.white
    //
    //        return collectionV
    //    }()
    
}

//extension ZLHJPDFReaderVC: UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.dataArray?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "XYJPDFCollectionViewCell", for: indexPath) as! ZLHJPDFCollectionViewCell
//        cell.showView = self.dataArray?[indexPath.item]
//        return cell
//    }
//
//}
//
//extension ZLHJPDFReaderVC: UICollectionViewDelegate {}
//
//extension ZLHJPDFReaderVC: UIScrollViewDelegate {
//
//    /// 当某个item不在当前视图中显示的时候，将它的缩放比例还原
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        for view in scrollView.subviews {
//            if view is ZLHJPDFCollectionViewCell {
//                (view as! ZLHJPDFCollectionViewCell).contentScrollV.zoomScale = 1.0
//            }
//        }
//    }
//
//}

// MARK: 下载进度
//extension ZLHJPDFReaderVC: URLSessionDownloadDelegate {
//    // 下载代理方法，下载结束
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        //下载结束
//        print("下载结束")
//        //输出下载文件原来的存放目录
//        print("location:\(location)")
//        //location位置转换
//        let locationPath = location.path
//
//        let fileName = "ZLHJ"
//        let pathFile = FilePathUtils.setupFilePath(directory: .documents, name: fileName)
//        let readData : Data? = FileUtils.readFile(filePath: pathFile.path)
//        if readData == nil {
//            print("第一次来吧，小哥哥")
//            let testFolderPath = FilePathUtils.setupFilePath(directory: .documents, name: "TestFolder/")
//            let createResult = FileUtils.createFolder(basePath: .customPath(path: testFolderPath.path), folderName: fileName)
//            if createResult {
//                print("大保健来一套")
//                let writeResult = FileUtils.moveFile(fileName: fileName, fromDirectory: locationPath, toDirectory: testFolderPath.path)
//                if writeResult {
//                    print("文件移动成功")
//                }
//            }
//        }else {
//
//        }
//    }
//
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//
//        //获取进度
//        let written:Float = Float(totalBytesWritten)
//        let total:Float = Float(totalBytesExpectedToWrite)
//        let pro:Float = written/total
//        if let downloadProgress = self.downloadProgress {
//            DispatchQueue.main.async {
//                print("下载进度：\(pro)")
//                downloadProgress.setProgress((pro), animated: true)
//            }
//        }
//    }
//}
