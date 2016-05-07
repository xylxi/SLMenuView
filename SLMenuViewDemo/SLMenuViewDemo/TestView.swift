//
//  TestView.swift
//  SLMenu
//
//  Created by WangZHW on 16/5/5.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit


class TestView: UIView,ShowDelegate {
    // 协议需要的代理
    weak var delegate: DisPlay?
    // 简单使用
    func alert(position:SLPosition) {
        let sh = SLShowView(addView: self, height: 100, position: position, needVisua: true)
        sh.show()
    }
}
