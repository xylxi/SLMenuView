//
//  TestView.swift
//  SLMenu
//
//  Created by WangZHW on 16/5/5.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit


class TestView: UIView,ShowDelegate {
    weak var delegate: DisPlay?
    func al(position:SLPosition) {
        let sh = SLShowView(addView: self, height: 100, position: position, needVisua: false)
        sh.show()
    }
}
