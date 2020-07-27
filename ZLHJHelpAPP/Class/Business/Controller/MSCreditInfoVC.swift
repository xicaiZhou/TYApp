//
//  CreditInfoVC.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/9/17.
//  Copyright © 2019 VIC. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import HEPhotoPicker
import JXPhotoBrowser
import PKHUD
import Kingfisher



class MSCreditInfoVC: BaseViewController {
    fileprivate let hCellIdentifier       = "HCreditInfoCell"
    fileprivate let CellIdentifier       = "CreditInfoCell"
    fileprivate let headerIdentifier = "CollectionHeaderView"
    
    fileprivate var hcollectionView: UICollectionView!
    fileprivate var collectionView: UICollectionView!
    private var titles = ["征信授权书", "身份证正面","身份证反面"]

    private var model = MSCreditModel()

    var loanID = "0"
    var orderState = ""
    var sourceType = "" // 来源

    let bottomView = BottomThreeView.loadFromNib()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "征信"
        self.view.backgroundColor = UIColor.white
        
        loanID = Utils.userDefaultRead(key: "loanID") as! String
        orderState = Utils.userDefaultRead(key: "orderState") as! String
        sourceType = Utils.userDefaultRead(key: "sourceType") as! String
        
        self.setupBarButtonItemSelectorName{[weak self] in
            
            if self?.sourceType == "old" {
                self?.navigationController?.pushViewController(SearchVC(), animated: true)
            }else{
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
        bottomView.PerviousStepBtn.rx.tap.subscribe(onNext: { [weak self] in
            
           let vc = BaseInfoVC()
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: disposeBag)
        
        bottomView.creditBtn.rx.tap.subscribe(onNext: { [weak self] in
            if self!.dataIsSuccess() {
                self?.checkLoadIsCredit()
            }
        }).disposed(by: disposeBag)
        
        bottomView.nextBtn.rx.tap.subscribe(onNext: { [weak self] in
            
            if self!.dataIsSuccess() && self?.model.creditFlag == "1" {
                self?.changeState()
            }
        }).disposed(by: disposeBag)
        
        initView()
        loadData()
    }
    
    
    
    func initView(){
        
        let hLayout = UICollectionViewFlowLayout()
        hLayout.scrollDirection = .horizontal
        hcollectionView = UICollectionView(frame: CGRect(x: 0, y: KHeight_NavBar + 10, width: kScreenWidth, height: 175), collectionViewLayout: hLayout)
        hcollectionView.showsVerticalScrollIndicator = false
        hcollectionView.backgroundColor = UIColor.white
        hcollectionView.delegate = self
        hcollectionView.dataSource = self
        hcollectionView.register(UINib(nibName: "HCreditInfoCell", bundle: nil), forCellWithReuseIdentifier: hCellIdentifier)
        hcollectionView.register(UINib(nibName: "HomeCollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)

        view.addSubview(hcollectionView)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 195 + KHeight_NavBar, width: kScreenWidth, height: kScreenHeight - 265 - KHeight_NavBar), collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white

        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CreditInfoCell", bundle: nil), forCellWithReuseIdentifier: CellIdentifier)
        collectionView.register(UINib(nibName: "HomeCollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)

        view.addSubview(collectionView)
        bottomView.frame = CGRect(x: 0, y: kScreenHeight - 70, width: kScreenWidth, height: 70)
        view.addSubview(bottomView)
        
    }
    
    func loadData(){
        let param : [String: Any] = [
            "SERVICE_NAME": "APP_CREATEORDER",
            "APITYPE":"select",
            "CORE_SERVICENAME":"search.mainUserList.user",
            "actType": "4",
            "uid":Utils.getUserId(),
            "param":[
                "loanID.loan": self.loanID,
                "pageFlag.loan" : "1"
            ]
        ]

        HUD.show(.progress)
        XCNetWorkTools().request(type: .post, api: "old", encoding: .JSON, parameters: param, success: { (value) in
            HUD.hide()

            if  let data =  value as? Array<Dictionary<String,Any>>{
                if let dic = data.first{
                    print(dic)

                    self.model = dic.kj.model(MSCreditModel.self)
                    
                    main {
                        if self.model.creditFlag == "0" {
                            self.bottomView.creditBtn.setTitle("提交征信", for: .normal)
                        }else{
                            self.bottomView.creditBtn.setTitle("结果查询", for: .normal)
                        }
                    }
                    
                    self.imageData(model: &self.model)
                }
            }else{
                self.showToast("数据格式错误！")
            }

        }) { (error) in

        }
    }
}
extension MSCreditInfoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == hcollectionView{
            return self.model.userId.count > 0 ? 1 : 0;
        }else{
            return self.titles.count;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hcollectionView{
            return 1;
        }else{
            switch section{
            case 0: return self.model.credentials1Arr?.count ?? 0
            case 1: return self.model.credentials2Arr?.count ?? 0
            case 2: return self.model.credentials3Arr?.count ?? 0
            default:
               return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hcollectionView{
            let cell:HCreditInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: hCellIdentifier, for: indexPath) as! HCreditInfoCell
            cell.MSModel = self.model
            cell.mark.isHidden = false
            return cell
            
        }else{
            let cell:CreditInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! CreditInfoCell

            if indexPath.section  == 0{
                cell.icon.image = UIImage(named: "pdf.png")

            }else{
                var url = ""
                switch indexPath.section{
                case 1: url = self.model.credentials2Arr![indexPath.row]
                case 2: url = self.model.credentials3Arr![indexPath.row]
                default:
                    url = ""
                }
                cell.icon.kf.setImage(with: URL(string:url), placeholder: UIImage(named: "占位图"))
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == hcollectionView {
             return CGSize.init(width: 0, height: 0)
        }
        return CGSize.init(width: kScreenWidth, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == hcollectionView {
            return CGSize(width: 280, height: 155)
        }
        return CGSize(width: (kScreenWidth-35) / 3 , height: (kScreenWidth-35) / 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5);
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
            var reusableview:UICollectionReusableView? = nil
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView : HomeCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as! HomeCollectionHeaderView
                headerView.titleLabel.text = titles[indexPath.section];
                headerView.operation.isHidden = false
                headerView.operation.rx.tap.subscribe(onNext: { [weak self] in
                    
                    if indexPath.section == 0 {
                        guard ICloudManager.iCloudEnable() else {
                            debugPrint("请在设置->AppleID、iCloud->iCloud中打开访问权限")
                            return
                        }
                        
                        let iCloudDocument = ICloudDocumentPickerViewController.init(documentTypes: ["com.adobe.pdf"], in: .import)
                        iCloudDocument.delegate = self
                        self?.navigationController?.present(iCloudDocument, animated: true) {}
                    }else{
                        self?.open(result: { [weak self] (result, images)  in
                            
                            let file: [String : Any] = [
                                 "loanId":self?.loanID as Any,
                                 "files" : result
                            ]
                            
                            let param:[String : Any] = [
                               
                                "SERVICE_NAME" : "APP_CREATEORDER",
                                "APITYPE" : "system",
                                "CORE_SERVICENAME" : "upload.creditFile.sys",
                                "actType": "1",
                                "uid"              : Utils.getUserNmae(),
                                "param": file
                            ]
                            HUD.show(.progress)
                            XCNetWorkTools().request(type: .post, api: "old", encoding: .JSON, parameters: param, success: { (value) in

                                HUD.hide()
                                let resultValue = value as! Dictionary<String, String>
                                
                                self?.saveData(dic: resultValue,fileTypeName:indexPath.section == 1 ? "身份证正面" : "身份证反面"){ (value) in
                                    
                                    if indexPath.section == 1 { // 身份证正面
                                        var credentialModel:Credentials = self!.model.credentials2 ?? Credentials()
                                        credentialModel.credentials = resultValue["fileCodes"] ?? ""
                                        credentialModel.filePaths = resultValue["pathCodes"] ?? ""
                                        self?.model.credentials2 = credentialModel
                                        self?.imageData(model: &self!.model)
                                    }else if indexPath.section == 2 { // 身份证反面
                                        var credentialModel:Credentials = self!.model.credentials3 ?? Credentials()
                                        credentialModel.credentials = resultValue["fileCodes"] ?? ""
                                        credentialModel.filePaths = resultValue["pathCodes"] ?? ""
                                        self?.model.credentials3 = credentialModel
                                        self?.imageData(model: &self!.model)
                                    }
                                }

                           
                            
                            }) { (error) in

                            }
                        })
                    }
                    
                }).disposed(by: self.disposeBag)
                reusableview = headerView
            }
            return reusableview!
        }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        
        if collectionView == self.collectionView{
            
            if indexPath.section == 0{
                let pdfvc = PDFReadVC()
                
                let url = self.model.credentials1Arr?[indexPath.row]
                
                if url == ""{
                    return 
                } else{
                    pdfvc.pdfPath = url! + "&m=" + String.randomStr() + "&type=pdf"
                    let nav = BaseNavigationController(rootViewController: pdfvc)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav,animated:true,completion:nil)
                }
            }else{
                // 网图加载器
                let loader = JXKingfisherLoader()
                // 数据源
                let dataSource = JXNetworkingDataSource(photoLoader: loader, numberOfItems: { () -> Int in
                    switch indexPath.section{
                        
                    case 1: return self.model.credentials2Arr!.count
                    case 2: return self.model.credentials3Arr!.count
                        
                    default:
                        return 0
                    }
                }, placeholder: { index -> UIImage? in
                    let cell = collectionView.cellForItem(at: indexPath) as? CreditInfoCell
                    return cell?.icon.image
                }) { index -> String? in
                    switch indexPath.section{
                        
                    case 1: return self.model.credentials2Arr![index]
                    case 2: return self.model.credentials3Arr![index]
                        
                    default:
                        return ""
                    }
                }
                // 视图代理，实现了光点型页码指示器
                let delegate = JXDefaultPageControlDelegate()
                // 转场动画
                let trans = JXPhotoBrowserZoomTransitioning { (browser, index, view) -> UIView? in
                    let indexPath = IndexPath(item: index, section: indexPath.section)
                    let cell = collectionView.cellForItem(at: indexPath) as? CreditInfoCell
                    return cell?.icon
                }
                // 打开浏览器
                JXPhotoBrowser(dataSource: dataSource, delegate: delegate, transDelegate: trans)
                    .show(pageIndex: indexPath.item)
            }
            
            
        }
    }
    
}

extension MSCreditInfoVC {
    
    
    func imageData( model:inout MSCreditModel){
       
        let credentialModel1:Credentials = model.credentials1 ?? Credentials()
        let credentialModel2:Credentials = model.credentials2 ?? Credentials()
        let credentialModel3:Credentials = model.credentials3 ?? Credentials()
        
        model.credentials1Arr = Array<String>()
        model.credentials2Arr = Array<String>()
        model.credentials3Arr = Array<String>()


        for str:String in credentialModel1.credentials.split(string: "|") {
            if str.count == 0{
                break
            }
            
            model.credentials1Arr?.append(NewImageNetwork() + str)
        }
        for str:String in credentialModel2.credentials.split(string: "|") {
            if str.count == 0{
                break
            }
            model.credentials2Arr?.append(NewImageNetwork() + str)
        }
        for str:String in credentialModel3.credentials.split(string: "|") {
            if str.count == 0{
                break
            }
            model.credentials3Arr?.append(NewImageNetwork() + str)
        }
        hcollectionView.reloadData()
        collectionView.reloadData()
               
    }

}
//MARK: -接口部分
extension MSCreditInfoVC {
    
    func dataIsSuccess()->Bool{

        if self.model.credentials1Arr?.count == 0  {
            Alert.showAlert1(self, title: "提示", message: "请上传征信授权书", alertTitle: "知道啦", style: .default, confirmCallback: nil)
            return false
        }
        if self.model.credentials1Arr?.count == 0{
            Alert.showAlert1(self, title: "提示", message: "请上传身份证正面", alertTitle: "知道啦", style: .default, confirmCallback: nil)
            return false
        }
        if self.model.credentials1Arr?.count == 0{
            Alert.showAlert1(self, title: "提示", message: "请上传身份证反面", alertTitle: "知道啦", style: .default, confirmCallback: nil)
            return false
        }
        return true

    }

    
    func saveData(dic:Dictionary<String,String>, fileTypeName:String, success:@escaping ([String:String]) ->()){

        var fileCodes:Dictionary = [String:[String]]()
        
        fileCodes.updateValue(dic["fileCodes"]!.split(string: "|"), forKey: "fileCodes")
        fileCodes.updateValue(dic["pathCodes"]!.split(string: "|"), forKey: "filePaths")

        
        let param : [String : Any] = [
            "SERVICE_NAME": "APP_CREATEORDER",
            "APITYPE":"update",
            "CORE_SERVICENAME":"data.saveCreditInfo.loan",
            "actType": "3",
            "param":[
                "loanID.loan" : self.loanID,
                "userID.loan" : self.model.userId,
                "fileName.loan": dic["fileNames"]!,
                "fileTypeName.loan" : fileTypeName,
                "fileCode.doc":fileCodes]
            ]
        print(param)

        XCNetWorkTools().request(type: .post, api: "old", encoding: .JSON, parameters: param, success: { (value) in
            let temp = value as! Dictionary<String,Any>
            
            if  (temp["isSuccess"] as! NSNumber).intValue == 1 {
                success(dic)
            }else {
                HUD.flash(.labeledError(title: "提示", subtitle: "保存失败！"), delay: 2)
            }
            
            
        }, faild: { (error) in
            
        })
    }
        
    // 修改节点状态
    func changeState(){
        let param : [String : Any] = [
            "SERVICE_NAME": "APP_CREATEORDER",
            "APITYPE":"update",
            "CORE_SERVICENAME":"data.setMainLoanStatus.loan",
            "actType": "3",
            "param":[
                "loanID.loan" :self.loanID,
                "status.loan":"20",
                "userID": Utils.getUserId(),
                "userType":Utils.getUserType()]
            ]

        XCNetWorkTools().request(type: .post, api: "old", encoding: .JSON, parameters: param, success: { (value) in
            self.orderState = "20"
            Utils.userDefaultSave(Key: "orderState", Value: self.orderState) // 订单状态
            let vc = DecisionRulesVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }, faild: { (error) in
            
        })
    }
    
    
    //1。判断是否已经征信
    func checkLoadIsCredit(){
        let param : [String: Any] = [
            "SERVICE_NAME": "APP_CREATEORDER",
            "APITYPE":"select",
            "CORE_SERVICENAME":"check.creditState.msfl",
            "actType": "4",
            "param":[
                "loanID": self.loanID,
                "initFlag": ""]
            ]
        //查询主贷款人的征信状态(0-未征信 1-已征信 2-待征信 3-征信中)
        XCNetWorkTools().request(type: .post, api: "old", encoding: .JSON, parameters: param, success: { (value) in
            
            let dic = value as! Dictionary<String,Any>
            if dic["result"] as! String == "0" { //未征信
                self.goCredit()
            }else{
                self.creditResult()
            }
        }, faild: { (error) in
            
        })
    }
    
    
    /// 2.征信接口
    func goCredit(){
        let param:[String:Any] = [
        "SERVICE_NAME": "APP_CREATEORDER",
        "APITYPE":"update",
        "CORE_SERVICENAME":"send.creditApplication.info",
         "actType": "4",
        "param":[
            "loanID":self.loanID,
            "mainUserID":self.model.userId
       ]]
        // 调用此接口后会把征信状态 0 -> 3
        XCNetWorkTools().request(type: .post, api: "old", encoding: .JSON, parameters: param, success: { (value) in
            let dic = value as! Dictionary<String,Any>
            
            if (dic["result"] as! NSNumber).intValue == 1 { //
                Alert.showAlert1(self, title: "提示", message: "征信已提交，请10分钟后查询征信结果!", alertTitle: "知道啦", style: .default, confirmCallback: {
                                //刷新数据
                    self.loadData()
                })
            }else{
                Alert.showAlert1(self, title: "提示", message: self.model.customerName + "征信失败，请稍后重试!", alertTitle: "知道啦", style: .default, confirmCallback: {
                    //刷新数据
                    self.loadData()
                })
            }


           
        }, faild: { (error) in
            
        })
    }
    /// 征信结果查询接口
    func creditResult(){
        let param:[String:Any] = [
         "SERVICE_NAME": "APP_CREATEORDER",
         "APITYPE":"update",
         "CORE_SERVICENAME":"send.searchCreditResult.info",
          "actType": "4",
         "param":[
             "loanID":self.loanID,
             "mainUserID":self.model.userId
        ]]
         XCNetWorkTools().request(type: .post, api: "old", encoding: .JSON, parameters: param, success: { (value) in
            let dic = value as! Dictionary<String,Any>
            if dic["result"] as? String == "1" { //
                self.saveDTIOneAndTwo()
            }else if dic["result"] as! String == "5"{
                Alert.showAlert1(self, title: "提示", message: "征信自动拒绝", alertTitle: "知道啦", style: .default, confirmCallback: {
                    let param : [String : Any] = [
                               "SERVICE_NAME": "APP_CREATEORDER",
                               "APITYPE":"update",
                               "CORE_SERVICENAME":"data.setMainLoanStatus.loan",
                               "actType": "3",
                               "param":[
                                   "loanID.loan":self.loanID,
                                   "status.loan":"-9",
                                   "result.loan":"-2",
                                   "comment.loan":"征信自动拒绝"]
                           ]
                    XCNetWorkTools().request(type: .post, api: "old", encoding: .JSON, parameters: param, success: { (value) in
                        self.navigationController?.pushViewController(SearchVC(), animated: true)
                        
                    }, faild: { (error) in
                        
                    })
                })
            }else if dic["result"] as! String == "6" {
                Alert.showAlert1(self, title: "提示", message: self.model.customerName + "资料错误,请重新上传！", alertTitle: "确定", style: .default, confirmCallback: nil)
            }else{
                Alert.showAlert1(self, title: "提示", message: self.model.customerName + "征询查询中，请稍后！", alertTitle: "确定", style: .default, confirmCallback: nil)
            }
            
            self.loadData()
            
         }, faild: { (error) in
             
         })
    }
    
    //3.保存DTI
    func saveDTIOneAndTwo(){
        
        let param :[String:Any] = [
            "SERVICE_NAME": "APP_CREATEORDER",
            "APITYPE":"update",
            "CORE_SERVICENAME":"data.saveDtiOneAndTwo.loan",
            "actType": "4",
            "param":[
                "loanID.loan":self.loanID
            ]]
        XCNetWorkTools().request(type: .post, api: "old", encoding: .JSON, parameters: param, success: { (value) in
            self.fourUnity()
        }, faild: { (error) in
            
        })
    }

    //4.四合一或五合一接口
    func fourUnity(){
        let param:[String:Any] = [
            "SERVICE_NAME": "APP_CREATEORDER",
            "APITYPE":"select",
            "CORE_SERVICENAME":"search.collectionOfInterfaceApp.loan",
            "actType": "4",
            "param":[
                "mainUserID":self.model.userId,
                "loanID":self.loanID
        ]]
        XCNetWorkTools().request(type: .post, api: "old", encoding: .JSON, parameters: param, success: { (value) in
            HUD.flash(.success, delay: 1.0) { (finish) in
              
            }
        }, faild: { (error) in
            
        })
    }
}
extension MSCreditInfoVC: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        pdftoByte(filePath: urls) { [weak self] (value) in
            
            let file: [String : Any] = [
                "loanId":self?.loanID as Any,
                "files" : value
            ]
            
            let param:[String : Any] = [
                
                "SERVICE_NAME" : "APP_CREATEORDER",
                "APITYPE" : "system",
                "CORE_SERVICENAME" : "upload.creditFile.sys",
                "actType": "1",
                "uid"              : Utils.getUserNmae(),
                "param": file
            ]
            HUD.show(.progress)
            XCNetWorkTools().request(type: .post, api: "old", encoding: .JSON, parameters: param, success: { (value) in
                
                HUD.hide()
                self?.saveData(dic: value as! Dictionary<String, String>,fileTypeName:"征信授权书"){ (value) in
                    var credentialModel:Credentials = self?.model.credentials1 ?? Credentials()
                    credentialModel.credentials = value["fileCodes"] ?? ""
                    credentialModel.filePaths = value["pathCodes"] ?? ""
                    self?.model.credentials1 = credentialModel
                    self?.imageData(model: &self!.model)
                }
                
            }) { (error) in
                
            }
        }
        
    }
    
    func pdftoByte(filePath:[URL], result:@escaping (Array<Dictionary<String,Any>>) ->()){
        
        var arr = Array<Dictionary<String,Any>>()
        
        main {
            HUD.show(.labeledProgress(title: "正在处理...", subtitle: ""))
        }
        async{
            do{
                for url:URL in filePath {
                    var dic = Dictionary<String,Any>()
                    let data = try Data(contentsOf: url)
                    let bytes = [UInt8](data)
                    let PDFName = url.absoluteString.split(string: "/").last
                    dic.updateValue(bytes, forKey: "content")
                    dic.updateValue("pdf", forKey: "type")
                    dic.updateValue(PDFName ?? "test.pdf", forKey: "name")
                    arr.append(dic)
                }
                main {
                    HUD.hide()
                    result(arr)
                }
            }catch {
                main {
                     HUD.hide()
                     print("filePath:\(filePath)")
                }
               
            }
        }
    }
}


