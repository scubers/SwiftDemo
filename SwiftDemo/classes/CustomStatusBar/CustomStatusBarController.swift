//
//  CustomStatusBarControllerViewController.swift
//  SwiftDemo
//
//  Created by Jren on 15/12/16.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

import UIKit
import BlocksKit
import ReactiveCocoa

class CustomStatusBarController: UIViewController {
    
    var bar:CustomStatusBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.purpleColor()
        
        bar = CustomStatusBar()
        bar.label.text = "怎么做啊???????"
        
        bar.show()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.bar.dismiss()
        }
        
        
        
    }
    


}
