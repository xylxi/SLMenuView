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
    @IBAction func click(sender: AnyObject) {
            // 简单用法
            let titles = ["itme1","itme2","time3","itme4","item5"]
            var items = [CLItem]()
            for i in 0..<5  {
                items.append(CLItem(title: titles[i], imageName: "love", handler: { (item) in
                    print(item.title);
                }))
            }
            let  menuView  = MeunView(items: items, direction: .downright, point: CGPoint(x: UIScreen.mainScreen().bounds.width / 2,y: UIScreen.mainScreen().bounds.height / 2 - 15), config: nil)
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

