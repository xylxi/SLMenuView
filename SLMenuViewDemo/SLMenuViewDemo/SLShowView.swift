//
//  ELShowView.swift
//  ELibrarySeller
//
//  Created by WangZHW on 16/1/24.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//  用于从底部弹出视图的辅助类

import UIKit

public protocol DisPlay: class {
    func show()
    func dismiss()
}

public protocol ShowDelegate: class {
    weak var delegate: DisPlay?{set get}
}

public typealias ShowAnimalClosure   = (view: UIView?) ->Void
public typealias DismissAimalClosure = (view: UIView?, time: NSTimeInterval) ->Void

public enum SLPosition {
    // 从上滑下
    case Top
    // 中间渐显
    case Center
    // 从下往上
    case Bottom
    // 自定义展示和隐藏动画效果
    case Custom(ShowAnimalClosure,DismissAimalClosure)
}

class SLShowView: UIView,DisPlay {
    var dismissClosuer:(()->Void)?
    var showClosure:(()->Void)?
    
    let screenW = UIScreen.mainScreen().bounds.width
    let screenH = UIScreen.mainScreen().bounds.height
    
    /// 添加的视图必须遵守这个协议
    weak var addView: ShowDelegate!
    var height: CGFloat
    private(set) var position: SLPosition
    var blueView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .Light)
        let v = UIVisualEffectView(effect: effect)
        return v
    }()
    
    init(addView: ShowDelegate,height: CGFloat, position: SLPosition = .Bottom, needVisua:Bool = true) {
        self.addView = addView
        self.height  = height
        self.position = position
        super.init(frame: CGRectMake(0, 0, screenW, screenH))
        // 高斯模糊
        if needVisua {
            self.blueView.frame = CGRectMake(0, 0, screenW, screenH)
            self.addSubview(blueView)
        }
        self.backgroundColor = UIColor(red: CGFloat(204)/CGFloat(255), green: CGFloat(204)/CGFloat(255), blue: CGFloat(204)/CGFloat(255), alpha: 1.0)
        addView.delegate = self
        self.addSubview(addView as! UIView)
        // 确认x,w,h
        let v = addView as! UIView
        let space = CGFloat(10)
        var rect = v.frame
        switch position {
        case .Custom(_): break
        default:
            rect.origin.x   = space
            rect.size.width = screenW - 2 * space
        }
        
        switch position {
        case .Top:
            rect.origin.y = -self.height
            v.frame = rect
        case .Center:
            v.frame = rect
            v.center = CGPoint(x: screenW / 2, y: screenH / 2)
        case .Bottom:
            rect.origin.y = screenH
            v.frame = rect
        case .Custom(_):
            break;
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        let supV = UIApplication.sharedApplication().keyWindow!
        supV.addSubview(self)
        supV.bringSubviewToFront(self)
        let tap = UITapGestureRecognizer(target: self, action: #selector(SLShowView.dismiss))
        self.addGestureRecognizer(tap)
        
        let addv = self.addView as! UIView
        var rect = addv.frame
        self.blueView.alpha = 0.0
        switch self.position {
        case .Center:
            addv.transform = CGAffineTransformMakeScale(0.0, 0.0)
        case .Custom(_):
            addv.alpha = 0.0
        default:
            break;
        }
        switch self.position {
        case .Custom(let s, _):
            s(view: self)
        default:
            UIView.animateWithDuration(0.33) { () -> Void in
                self.blueView.alpha = 1.0
                switch self.position{
                case .Top:
                    rect.origin.y = 0
                    addv.frame    = rect
                case .Center:
                    addv.transform = CGAffineTransformMakeScale(1.0, 1.0)
                case .Bottom:
                    rect.origin.y = self.screenH - rect.height
                    addv.frame    = rect
                case .Custom(_,_):break
                }
            }
        }
        self.showClosure?()
    }
    func dismiss() {
        let addv = self.addView as! UIView
        var rect = addv.frame
        switch self.position {
        case .Custom(_, let d):
            d(view: self,time: 0.33)
        default:
            UIView.animateWithDuration(0.33, animations: { () -> Void in
                self.blueView.alpha = 0.0
                switch self.position{
                case .Top:
                    rect.origin.y = -rect.height
                    addv.frame = rect
                case .Center:
                    (self.addView as! UIView).transform = CGAffineTransformMakeScale(0.5, 0.5)
                    (self.addView as! UIView).alpha     = 0.0
                case .Bottom:
                    rect.origin.y = self.screenH
                    addv.frame = rect
                default:break
                }
                })
            { (finish) -> Void in
                self.removeFromSuperview()
            }
        }
        self.dismissClosuer?()
        
    }
}
