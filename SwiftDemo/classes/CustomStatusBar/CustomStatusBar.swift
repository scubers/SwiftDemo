//
//  CustomStatusBar.swift
//  SwiftDemo
//
//  Created by Jren on 15/12/17.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

import UIKit

class CustomStatusBar : UIWindow {
    
    var label: UILabel!
    
    // MARK: - 生命周期
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.windowLevel = UIWindowLevelStatusBar + 1.0
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        label = UILabel()
        self.addSubview(label)
        
        label.textAlignment = .Center
        
        label.textColor = UIColor.whiteColor()
        self.backgroundColor = UIColor.yellowColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.frame = UIApplication.sharedApplication().statusBarFrame
        label.frame = self.frame
    }
    
    // MARK: - 公共方法
    func show() {
        self.makeKeyAndVisible()
        if Double(UIDevice.currentDevice().systemVersion) >= 9.0 {
            self.resignKeyWindow()
        }
        
    }
    
    func dismiss() {
        self.resignKeyWindow()
        self.hidden = true
    }
}