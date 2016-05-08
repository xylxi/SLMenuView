//
//  ViewController.swift
//  SLMenu
//
//  Created by WangZHW on 16/5/5.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var count = 0
    
//    var v: CLMeunView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var btn: UIButton!
    
    @IBAction func menu(sender: AnyObject) {
        // 简单用法
        let titles = ["创建讨论组","加好友","扫一扫","发送到电脑","付款"]
        var items = [CLItem]()
        for i in 0..<5  {
            items.append(CLItem(title: titles[i], imageName: titles[i], handler: { (item) in
                print(item.title);
            }))
        }
        let  menuView  = MeunView(items: items, direction: .up, point: CGPoint(x: UIScreen.mainScreen().bounds.width - 42,y: 60), config: nil)
        menuView.show()
    }
    
    
    @IBAction func top(sender: AnyObject) {
        let s = TestView(frame: CGRectMake(100, 100, 100, 100))
        s.backgroundColor = UIColor.redColor()
        s.alert(.Top)
    }
    
    @IBAction func center(sender: AnyObject) {
        let s = TestView(frame: CGRectMake(100, 100, 100, 100))
        s.backgroundColor = UIColor.redColor()
        s.alert(.Center)
    }
    
    @IBAction func bottom(sender: AnyObject) {
        let s = TestView(frame: CGRectMake(100, 100, 100, 100))
        s.backgroundColor = UIColor.redColor()
        s.alert(.Bottom)
    }
}

