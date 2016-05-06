
//
//  SLMenuView.swift
//  SLMenu
//
//  Created by WangZHW on 16/5/5.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit

enum CLMenuDirection {
    case upleft, upright, downleft, downright
}

public class CLItem {
    
    typealias hClosure = (item: CLItem) -> Void
    
    let title: String
    let imageName: String?
    let handler: hClosure?
    
    init(title: String,imageName: String? = nil , handler:hClosure?) {
        self.title     = title
        self.imageName = imageName
        self.handler   = handler
    }
}

struct CLMeunConfig {
    // menu背景颜色
    let bgColor: UIColor
    // 添加路径的颜色
    let rectColor: UIColor
    // item分割线颜色
    let separateColor: UIColor
    // 按钮颜色
    let titleColor: UIColor
    // 圆角半径
    let radius: CGFloat
    // 三角形的边长
    let arrowLength: CGFloat
    // 按钮的高度
    let itemHeight: CGFloat
    // 图片和文字的距离
    let imagetitleSpace: CGFloat
    // 菜单的宽带
    var meunWidth: CGFloat
}

public class CLMeunView: UIView,ShowDelegate {
    public weak var delegate : DisPlay?
    let config   : CLMeunConfig
    let items    : [CLItem]
    let direction: CLMenuDirection
    // 箭头的位置
    let point    : CGPoint
    init(items: [CLItem], direction: CLMenuDirection = .upleft, point: CGPoint, config: CLMeunConfig?) {
        self.items     = items
        self.direction = direction
        self.point     = point
        let bgColor = UIColor(red: CGFloat(204)/CGFloat(255), green: CGFloat(204)/CGFloat(255), blue: CGFloat(204)/CGFloat(255), alpha: 1.0)
        let separateColor = UIColor(red: CGFloat(179)/CGFloat(255), green: CGFloat(180)/CGFloat(255), blue: CGFloat(210)/CGFloat(255), alpha: 1.0)
        self.config    = config ??
            CLMeunConfig(bgColor: bgColor, rectColor: UIColor.whiteColor(), separateColor: separateColor, titleColor: UIColor.blackColor(),radius: 5,arrowLength: 6, itemHeight: 44,imagetitleSpace: 10, meunWidth: 150)
        // 计算高
        let h = CGFloat(items.count) * (self.config.itemHeight + 0.5) + CGFloat(self.config.arrowLength * pow(3, 0.5)) + self.config.radius
        // 计算宽
        let w = self.config.meunWidth + self.config.radius * 2
        var x: CGFloat = 0
        var y: CGFloat = 0
        // 调整point
        switch self.direction {
        case .upleft:
            x = point.x - self.config.meunWidth / 5
            y = point.y
        case .upright:
            x = point.x - self.config.meunWidth / 5 * 4
            y = point.y
        case .downleft:
            x = point.x - self.config.meunWidth / 5
            y = point.y - h
        case .downright:
            x = point.x - self.config.meunWidth / 5 * 4
            y = point.y - h
        }
        
        let rect = CGRectMake(x, y, w, h);
        
        super.init(frame: rect)
        self.backgroundColor = self.config.bgColor;
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func drawRect(rect: CGRect) {
        // 背景颜色
        let bgPath = UIBezierPath(rect: rect)
        self.config.bgColor.set()
        bgPath.fill()
        
        // 设置颜色
        self.config.rectColor.set()
        
        // 设置三角
        var offX = CGFloat(0)
        var offY = CGFloat(0)
        switch self.direction {
        case .upleft:
            offX = rect.width / 5
            offY = rect.origin.y
        case .upright:
            offX = rect.width / 5 * 4
            offY = rect.origin.y
        case .downleft:
            offX = rect.width / 5
            offY = rect.origin.y + rect.height - self.config.arrowLength * pow(3, 0.5)
        case .downright:
            offX = rect.width / 5 * 4
            offY = rect.origin.y + rect.height - self.config.arrowLength * pow(3, 0.5)
        }
        let xl = offX - self.config.arrowLength
        let xr = offX + self.config.arrowLength
        let yt = offY
        let yd = offY + self.config.arrowLength * pow(3, 0.5)
        
        var pointl:CGPoint,pointr:CGPoint,pointh:CGPoint
        switch self.direction {
        case .upright,.upleft:
            pointl = CGPoint(x: xl, y: yd)
            pointr = CGPoint(x: xr, y: yd)
            pointh = CGPoint(x: xl + self.config.arrowLength, y: yt)
        case .downright,.downleft:
            pointl = CGPoint(x: xl, y: yt)
            pointr = CGPoint(x: xr, y: yt)
            pointh = CGPoint(x: xl + self.config.arrowLength, y: yd)
            
        }
        let arrowPath = UIBezierPath()
        arrowPath.moveToPoint(pointl)
        arrowPath.addLineToPoint(pointh)
        arrowPath.addLineToPoint(pointr)
        arrowPath.closePath()
        arrowPath.fill()
        
        var roundRect: CGRect
        switch self.direction {
        case .upleft, .upright:
            roundRect = CGRectMake(0, yd, rect.width, rect.height - yd)
        default:
            roundRect = CGRectMake(0, 0, rect.width, rect.height - self.config.arrowLength * pow(3, 0.5))
        }
        let roundPath = UIBezierPath(roundedRect: roundRect, cornerRadius: self.config.radius)
        roundPath.fill()
    }
    
    private var bc = [UIButton : CLItem]()
    
    override public func layoutSubviews() {
        
        
        let margin1 = self.config.arrowLength * pow(3, 0.5)
        let margin2 = self.config.radius / 2
        
        var starty  = margin2
        let startx  = margin2
        if self.direction == .upright || self.direction == .upleft {
            starty += margin1
        }
        
        for (index, item) in self.items.enumerate() {
            // 按钮
            let btn = UIButton(type: .Custom)
            btn.addTarget(self, action: #selector(CLMeunView.click(_:)), forControlEvents: .TouchUpInside)
            btn.frame = CGRectMake(startx, starty, self.config.meunWidth, self.config.itemHeight)
            btn.setTitle(item.title, forState: .Normal)
            btn.setTitleColor(self.config.titleColor, forState: .Normal)
            if let name = item.imageName {
                btn.setImage(UIImage(named: name), forState: .Normal)
                btn.setImage(UIImage(named: name), forState: .Highlighted)
            }
            self.addSubview(btn)
            btn.addSpace(self.config.imagetitleSpace)
            starty = CGRectGetMaxY(btn.frame)
            // 分割线
            if index != self.items.count - 1 {
                let v = UIImageView(image: UIImage.imageWithColor(self.config.separateColor))
                v.frame = CGRectMake(0, starty, self.bounds.width, 0.5)
                self.addSubview(v)
                starty += 0.5
            }
            
            self.bc[btn] = item
        }
    }
    
    func click(sender: UIButton) {
        if let item = self.bc[sender] {
            item.handler?(item: item)
        }
        delegate?.dismiss()
    }
    
    func show() {
        // 自定义显示和隐藏动画
        let s: ShowAnimalClosure = {[weak self]
            v in
            self?.alpha = 0.0
            UIView.animateWithDuration(0.33, animations: { 
                self?.alpha = 1.0
            })
        }
        let d: DismissAimalClosure = {[weak self]
            v , time in
            self?.alpha = 1.0
            UIView.animateWithDuration(time, animations: {
                self?.alpha = 0.0
                v?.alpha    = 0.0
                }, completion: { (finish) in
                    v?.removeFromSuperview()
            })
        }
        let showView = SLShowView(addView: self, height: self.bounds.height, position: .Custom(s,d), needVisua: false)
        showView.show()
    }
}
extension UIButton {
    func addSpace(space: CGFloat) {
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: space / 2, bottom: 0, right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: space / 2)
    }
}

extension UIImage {
    class func imageWithColor(color: UIColor) ->UIImage{
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }
}




