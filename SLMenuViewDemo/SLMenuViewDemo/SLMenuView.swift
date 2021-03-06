
//
//  SLMenuView.swift
//  SLMenu
//
//  Created by WangZHW on 16/5/5.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit

public enum CLMenuDirection {
    case up,down
}

public class CLItem {
    
    public typealias hClosure = (item: CLItem) -> Void
    let title: String
    let imageName: String?
    let handler: hClosure?
    
    public init(title: String,imageName: String? = nil , handler:hClosure?) {
        self.title     = title
        self.imageName = imageName
        self.handler   = handler
    }
}

public struct MenuConfig {
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
//    public let imagetitleSpace: CGFloat
    // 菜单的宽带
    let menuWidth: CGFloat
    // 箭头的的x对于width的百分比
    let percentage: CGFloat
    
    public init(bgColor: UIColor, rectColor: UIColor, separateColor: UIColor, titleColor: UIColor, radius: CGFloat, arrowLength: CGFloat, itemHeight: CGFloat, imagetitleSpace: CGFloat, menuWidth: CGFloat, percentage: CGFloat = CGFloat(5) / CGFloat(6)) {
        self.bgColor         = bgColor
        self.rectColor       = rectColor
        self.separateColor   = separateColor
        self.titleColor      = titleColor
        self.radius          = radius
        self.arrowLength     = arrowLength
        self.itemHeight      = itemHeight
//        self.imagetitleSpace = imagetitleSpace
        self.menuWidth       = menuWidth
        self.percentage      = percentage
    }
}

public class MeunView: UIView,ShowDelegate {
    public weak var delegate : DisPlay?
    let config   : MenuConfig
    let items    : [CLItem]
    let direction: CLMenuDirection
    // 箭头的位置
    let point    : CGPoint
    public init(items: [CLItem], direction: CLMenuDirection = .up, point: CGPoint, config: MenuConfig? = nil) {
        self.items     = items
        self.direction = direction
        self.point     = point
        let bgColor = UIColor(red: CGFloat(204)/CGFloat(255), green: CGFloat(204)/CGFloat(255), blue: CGFloat(204)/CGFloat(255), alpha: 0.2)
        let separateColor = UIColor(red: CGFloat(179)/CGFloat(255), green: CGFloat(180)/CGFloat(255), blue: CGFloat(210)/CGFloat(255), alpha: 1.0)
        self.config    = config ??
            MenuConfig(bgColor: bgColor, rectColor: UIColor.whiteColor(), separateColor: separateColor, titleColor: UIColor.blackColor(),radius: 5,arrowLength: 6, itemHeight: 44,imagetitleSpace: 10, menuWidth: 150)
        // 计算高
        let h = CGFloat(items.count) * (self.config.itemHeight + 0.5) + CGFloat(self.config.arrowLength * pow(3, 0.5)) + self.config.radius
        // 计算宽
        let w = self.config.menuWidth + self.config.radius * 2
        var x: CGFloat = 0
        var y: CGFloat = 0
        // 调整point
        switch self.direction {
        case .up:
            x = point.x - self.config.menuWidth * self.config.percentage
            y = point.y
        case .down:
            x = point.x - self.config.menuWidth * self.config.percentage
            y = point.y - h
        }
        
        let rect = CGRectMake(x, y, w, h);
        
        super.init(frame: rect)
        self.backgroundColor = UIColor.clearColor()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func drawRect(rect: CGRect) {        
        // 设置颜色
        self.config.rectColor.set()
        
        // 设置三角
        let offX = rect.width * self.config.percentage
        var offY = CGFloat(0)
        switch self.direction {
        case .up:
            offY = rect.origin.y
        case .down:
            offY = rect.origin.y + rect.height - self.config.arrowLength * pow(3, 0.5)
        }
        let xl = offX - self.config.arrowLength
        let xr = offX + self.config.arrowLength
        let yt = offY
        let yd = offY + self.config.arrowLength * pow(3, 0.5)
        
        var pointl:CGPoint,pointr:CGPoint,pointh:CGPoint
        switch self.direction {
        case .up:
            pointl = CGPoint(x: xl, y: yd)
            pointr = CGPoint(x: xr, y: yd)
            pointh = CGPoint(x: xl + self.config.arrowLength, y: yt)
        case .down:
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
        case .up:
            roundRect = CGRectMake(0, yd, rect.width, rect.height - yd)
        default:
            roundRect = CGRectMake(0, 0, rect.width, rect.height - self.config.arrowLength * pow(3, 0.5))
        }
        let roundPath = UIBezierPath(roundedRect: roundRect, cornerRadius: self.config.radius)
        roundPath.addClip()
        roundPath.fill()
    }
    
    private var bc = [UIButton : CLItem]()
    
    override public func layoutSubviews() {
        
        
        let margin1 = self.config.arrowLength * pow(3, 0.5)
        let margin2 = self.config.radius / 2
        
        var starty  = margin2
        let startx  = margin2
        if self.direction == .up {
            starty += margin1
        }
        
        for (index, item) in self.items.enumerate() {
            // 按钮
            let btn = SLButton(type: .Custom)
            btn.addTarget(self, action: #selector(MeunView.click(_:)), forControlEvents: .TouchUpInside)
            btn.frame = CGRectMake(startx, starty, self.config.menuWidth, self.config.itemHeight)
            btn.setTitle(item.title, forState: .Normal)
            btn.setTitleColor(self.config.titleColor, forState: .Normal)
            if let name = item.imageName {
                btn.setImage(UIImage(named: name), forState: .Normal)
                btn.setImage(UIImage(named: name), forState: .Highlighted)
            }
            self.addSubview(btn)
//            btn.addSpace(self.config.imagetitleSpace)
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
    
    public func show() {
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

class SLButton: UIButton {
    let scale: CGFloat = 1.0 / 3.0
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(0, 0, contentRect.width * scale, contentRect.height)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(contentRect.width * scale, 0, contentRect.width * (1 - scale), contentRect.height)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView?.contentMode = .Center
        self.titleLabel?.textAlignment = .Left
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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




