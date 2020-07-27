//
//  ZLHJPDFCollectionViewCell.swift
//  ZLHJHelpAPP
//
//  Created by zhy on 2020/5/13.
//  Copyright © 2020 VIC. All rights reserved.
//

import UIKit

class ZLHJPDFCollectionViewCell: UICollectionViewCell,UIScrollViewDelegate {
    /// 用于显示pdf内容的视图
    var showView: ZLHJPdfReaderView? {
        didSet {
            for view in contentScrollV.subviews {
                view.removeFromSuperview()
            }
            contentScrollV.addSubview(showView!)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(contentScrollV)
    }
    /// 用于实现缩放功能的UISCrollView
    lazy var contentScrollV: UIScrollView = {
        let contentV = UIScrollView.init(frame: self.bounds)
        contentV.contentSize = self.frame.size
//        contentV.minimumZoomScale = 0.5
//        contentV.maximumZoomScale = 2.5
        contentV.delegate = self
        return contentV
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 代理方法
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        for view in contentScrollV.subviews {
            if view is ZLHJPdfReaderView {
                return view
            }
        }
        return nil
        
    }
}
