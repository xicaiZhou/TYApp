//
//  UIImage-Extension.swift
//  ZLHJHelpAPP
//
//  Created by 周希财 on 2019/9/18.
//  Copyright © 2019 VIC. All rights reserved.
//

import Foundation
import PKHUD

typealias imageResult = (Array<Dictionary<String,Any>>)->()

//二维码生成器
extension UIImage {
    
    class func getImageFroBase64(data:String) -> UIImage {
        // 将 base64的图片字符串转化成Data
        let imageData = Data(base64Encoded: data)!

        // 将Data转化成图片
        let image = UIImage(data: imageData)
        
        return image!
    }
    
    // MAKR: - 二维码生成器 中间有图片
    class func QRCodeGenerate(QRCodeInfo message:String,QRCodeImageSize size:CGSize,logo centerImage:UIImage) -> UIImage {
        
        let image = QRCodeGenerate(QRCodeInfo: message, QRCodeImageSize: size)
        UIGraphicsBeginImageContextWithOptions(image.size, true, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let logoWidth = min(image.size.width, image.size.height)/5
        let x         = (image.size.width - logoWidth)/2.0
        let y         = (image.size.height - logoWidth)/2.0
        let rect      = CGRect.init(x: x, y: y, width: logoWidth, height: logoWidth)
        let path      = UIBezierPath.init(roundedRect: rect, cornerRadius: logoWidth/5.0)
        path.lineWidth = 2.0
        UIColor.white.set()
        path.stroke()
        path.addClip()
        centerImage.draw(in: rect)
        let logoQRCodeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return logoQRCodeImage!
    }
    
    // MAKR: - 二维码生成器（中间没有图片）
    class func QRCodeGenerate(QRCodeInfo message:String,QRCodeImageSize size:CGSize) -> UIImage {
        
        assert(message.count > 0)
        assert(!size.equalTo(CGSize.zero))
        
        let infoData = message.data(using: .utf8)
        let filter   = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(infoData!, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        var ciImage  = filter?.outputImage
        let scaleX   = min(size.width, size.height)/(ciImage?.extent.size.width)!
        let scaleY   =  min(size.width, size.height)/(ciImage?.extent.size.height)!
        ciImage      = ciImage?.transformed(by: CGAffineTransform.init(scaleX: scaleX, y: scaleY))
        let image = UIImage.init(ciImage: ciImage!)
        return image
    }
    
    
    //MARK: - 条形码生成器
    class func QRBarCodeGenerate(QRBarCodeInfo message:String,QRBarCodeImageSize size:CGSize) -> UIImage {
        
        //        assert(message.count > 0)
        //        assert(!size.equalTo(CGSize.zero))
        
        let infoData = message.data(using: .utf8)
        let filter   = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(infoData!, forKey: "inputMessage")
        filter?.setValue(NSNumber(value: 0), forKey:"inputQuietSpace")
        var ciImage  = filter?.outputImage
        let scaleX   = min(size.width, size.height)/(ciImage?.extent.size.width)!
        let scaleY   =  min(size.width, size.height)/(ciImage?.extent.size.height)!
        ciImage      = ciImage?.transformed(by: CGAffineTransform.init(scaleX: scaleX, y: scaleY))
        let image = UIImage.init(ciImage: ciImage!)
        return image
    }
    
    
    class func imgaetoByte(imageArr:[UIImage], result:@escaping imageResult) {
        
        var arr = Array<Dictionary<String,Any>>()
        main {
            HUD.show(.labeledProgress(title: "正在处理...", subtitle: ""))
        }
        async{
            
            for image:UIImage in imageArr {
                var dic = Dictionary<String,Any>()
                if let data = image.compressImageOnlength(){
                    let bytes = [UInt8](data)
                    let IMGName = data.getImageFormat()
                    dic.updateValue(bytes, forKey: "content")
                    dic.updateValue(IMGName ?? "image/png", forKey: "type")
                    dic.updateValue("test.png", forKey: "name")
                    arr.append(dic)
                }
            }
            main {
                HUD.hide()
                result(arr)
            }
        }
    }
    
    
    /// 压缩图片数据-不压尺寸
    ///
    /// - Parameters:
    ///   - maxLength: 最大长度
    /// - Returns:
    func compressImageOnlength(maxLength: Int = 1048576) -> Data? {
        
        guard let vData = self.jpegData(compressionQuality: 1) else { return nil }
        if vData.count < maxLength {
            return vData
        }
        var compress:CGFloat = 0.9
        guard var data = self.jpegData(compressionQuality: compress) else { return nil }
        while data.count > maxLength && compress > 0.01 {
            compress -= 0.02
            data = self.jpegData(compressionQuality: compress)!
        }
        return data
    }
    
    // MARK: 宽度固定，高度根据宽度自适应
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
          
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
          
        return newImage!
    }
    
}

