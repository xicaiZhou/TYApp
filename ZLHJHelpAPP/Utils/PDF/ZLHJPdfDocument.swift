//
//  ZLHJPdfDocument.swift
//  ZLHJHelpAPP
//
//  Created by zhy on 2020/5/13.
//  Copyright © 2020 VIC. All rights reserved.
//

import UIKit
// MARK: pdf文件读取
class ZLHJPdfDocument: NSObject {
    /// 根据url字符串生成pdf数据
    ///
    /// - Parameter urlString: pdf的路径
    /// - Returns: pdf数据
    static func getPdfDocumentRef(urlString: String) -> CGPDFDocument? {
        
        /// url字符串转成URL类型
        let str = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        guard let url = URL.init(string: str) else { return nil }
        
        /// 通过url获取文件内容
        let pdfData = try? Data.init(contentsOf: url, options: Data.ReadingOptions.init(rawValue: 0)) as CFData
        
        var proRef: CGDataProvider?
        if pdfData != nil {
            proRef = CGDataProvider.init(data: pdfData!)
        }
        if proRef != nil {
            let documentRefDocu = CGPDFDocument.init(proRef!)
            if documentRefDocu != nil {
                return documentRefDocu
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
