//
//  ZLHJPellBgView.swift
//  ZLHJHelpAPP
//
//  Created by zhy on 2020/1/16.
//  Copyright © 2020 VIC. All rights reserved.
//

import UIKit

class ZLHJPellBgView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let startPoint = CGPoint(x: frame.size.width - 36.0, y:8.0)
        let middlePoint = CGPoint(x: frame.size.width - 24.0 , y:0)
        let endPoint = CGPoint(x: frame.size.width - 16 , y:8.0)
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.beginPath()
        context.move(to: startPoint)
        context.addLine(to: middlePoint)
        context.addLine(to: endPoint)
        context.closePath()
        context.setFillColor(UIColor.white.cgColor)
        context.setStrokeColor(UIColor.white.cgColor)
        context.drawPath(using: .fillStroke)
        
        
    }
}

class ZLHJPellTableViewSelect: UIView {
    
    var selecctData: [String]?
    var action: ((_ index: Int) -> ())?
    var imagesData: [String]?
    
    static var bgView: ZLHJPellBgView?
    
    static var backgroundView: ZLHJPellTableViewSelect?
    static var tableView:UITableView?
    
    class func addPellView(frame:CGRect, selectData: Array<Any>, images: Array<String>, animate:Bool, action:@escaping ((_ index: Int)->())) {
    
        if backgroundView != nil {
            hidden()
        }
        
        let win:UIWindow = UIApplication.shared.keyWindow!
        backgroundView = ZLHJPellTableViewSelect(frame: win.bounds)
        backgroundView?.action = action
        backgroundView?.imagesData = images
        backgroundView?.selecctData = selectData as? [String]
        backgroundView?.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.4)
        
        win.addSubview(backgroundView!)
        
        bgView = ZLHJPellBgView(frame: CGRect(x: frame.origin.x + kWidth/4-80, y: KHeight_NavBar - (40.0 * CGFloat(selectData.count)/2.0) - 3 + 40, width: frame.size.width, height: 40.0 * CGFloat(selectData.count) + 8))
        
        tableView = UITableView(frame: CGRect(x: 0, y: 8, width: frame.size.width, height: 40.0 * CGFloat(selectData.count)), style: .plain)
        tableView?.dataSource = backgroundView
        tableView?.delegate = backgroundView
        tableView?.layer.cornerRadius = 6
        tableView?.rowHeight = 40
        
        // 锚点

    //  bgView?.layer.anchorPoint = CGPoint(x: 1.0, y: 0)
        bgView?.layer.anchorPoint = CGPoint(x: 1.0 - 24.0/(frame.size.width), y: 0)
        bgView?.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        win.addSubview(bgView!)
        bgView?.addSubview(tableView!)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapbackgroundClick))
        backgroundView?.addGestureRecognizer(tap)
        backgroundView?.action = action
        backgroundView?.selecctData = (selectData as! [String])
        
        
        if animate {
            backgroundView?.alpha = 0
            UIView.animate(withDuration: 0.3) {
                backgroundView?.alpha = 0.5
                bgView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

            }
        }
        
    }
    
    class func hidden() {
        if backgroundView != nil {
            UIView.animate(withDuration: 0.15, animations: {
                bgView?.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
            }) { (finished) in
                backgroundView?.removeFromSuperview()
                tableView?.removeFromSuperview()
                bgView?.removeFromSuperview()
                bgView = nil
                tableView = nil
                backgroundView = nil
            }
        }
    }
    
    @objc class func tapbackgroundClick() {
        if backgroundView?.action != nil {
            backgroundView?.action!(10086)
        }
        hidden()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let ZLHJPellTableViewSelectIdentifier = "ZLHJPellTableViewSelectIdentifier"
extension ZLHJPellTableViewSelect: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (selecctData?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ZLHJPellTableViewSelectIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: ZLHJPellTableViewSelectIdentifier)
        }
        if (imagesData?.count)! > 0 {
            cell?.imageView?.image = UIImage(named: imagesData![indexPath.row])
        }
        
        cell?.textLabel?.text = selecctData?[indexPath.row]
        cell?.textLabel?.textAlignment = NSTextAlignment.center
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.textLabel?.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (self.action != nil) {
            self.action!(indexPath.row)
        }
        ZLHJPellTableViewSelect.hidden()
    }
}
