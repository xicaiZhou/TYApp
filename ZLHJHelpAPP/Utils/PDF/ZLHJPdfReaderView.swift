//
//  ZLHJPdfReaderView.swift
//  ZLHJHelpAPP
//
//  Created by zhy on 2020/5/13.
//  Copyright © 2020 VIC. All rights reserved.
//

import UIKit

// MARK: pdf绘制板
class ZLHJPdfReaderView: UIView {

    /// pdf数据
    var documentRef: CGPDFDocument?
    /// 页数
    var pageNum = 0
    
    /// 创建一个视图
    ///
    /// - Parameters:
    ///   - frame: 尺寸
    ///   - documentRef: pdf数据
    ///   - pageNum: 当前页码数
    /// - Returns: 视图
    init(frame: CGRect, documentRef: CGPDFDocument?, pageNum: Int) {
        super.init(frame: frame)
        self.documentRef = documentRef
        self.pageNum = pageNum
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 重绘
    ///
    /// - Parameter rect: 尺寸
    override func draw(_ rect: CGRect) {
        
        self.drawPdfIn(context: UIGraphicsGetCurrentContext()!)
    }
    
    func drawPdfIn(context: CGContext) -> Void {
        
        // 调整位置
        context.translateBy(x: 0.0, y: self.frame.size.height)
        // 使图形呈正立显示
        context.scaleBy(x: 1.0, y: -1.0)
        // 获取需要绘制该页码的数据
        let pageRef = self.documentRef?.page(at: self.pageNum+1)
        // 创建一个仿射变换的参数给函数
        let pdfTransform = pageRef?.getDrawingTransform(CGPDFBox.cropBox, rect: self.bounds, rotate: 0, preserveAspectRatio: true)
        // 把创建的仿射变换参数和上下文环境联系起来
        context.concatenate(pdfTransform!)
        // 把得到的指定页的PDF数据绘制到视图上
        context.drawPDFPage(pageRef!)
    }

}
