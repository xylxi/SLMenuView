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
            var items = [CLItem]()
            for i in 0..<5  {
                items.append(CLItem(title: "haha\(i)", imageName: "love", handler: { (item) in
                    print(item.title);
                }))
            }
            let  v  = CLMeunView(items: items, direction: .downright, point: CGPoint(x: UIScreen.mainScreen().bounds.width / 2,y: UIScreen.mainScreen().bounds.height / 2 - 15), config: nil)
            v.show()
    }
    
    @IBAction func top(sender: AnyObject) {
        let s = TestView(frame: CGRectMake(100, 100, 100, 100))
        s.backgroundColor = UIColor.redColor()
        s.al(.Top)
    }
    
    @IBAction func center(sender: AnyObject) {
        let s = TestView(frame: CGRectMake(100, 100, 100, 100))
        s.backgroundColor = UIColor.redColor()
        s.al(.Center)
    }
    
    @IBAction func bottom(sender: AnyObject) {
        let s = TestView(frame: CGRectMake(100, 100, 100, 100))
        s.backgroundColor = UIColor.redColor()
        s.al(.Bottom)
    }
}

