//
//  QTTranslucentViewController.swift
//  SwiftDemo
//
//  Created by Jren on 15/12/25.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

class QTTranslucentViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        // MARK: Key code, 不知道为毛, 不在初始化设置背景颜色, present之后父视图还是会被移除
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        self.modalPresentationStyle = .OverCurrentContext;
        
        
        // 如果需要兼容ios7 需要设置一下代码
//        UIApplication.sharedApplication().delegate?.window??.rootViewController?.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
