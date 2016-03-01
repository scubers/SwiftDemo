//
//  ChildViewController.swift
//  SwiftDemo
//
//  Created by Jren on 16/3/1.
//  Copyright © 2016年 jr-wong. All rights reserved.
//

import UIKit

class ChildViewController: UIViewController {
    
    private var name: String?
    
    init(name: String?) {
        super.init(nibName: nil, bundle: nil)
        self.name = name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.purpleColor()
        
        let ly = CAGradientLayer()
        
        ly.frame = CGRectMake(view.center.x - 50, view.center.y - 50, 100, 100)
        
        ly.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]
        
        ly.startPoint = CGPointMake(1, 0)
        ly.endPoint = CGPointMake(0,1)
        
        view.layer.addSublayer(ly)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("\(self)")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self.name) will appear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self.name) did appear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self.name)will disappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self.name) did disappear")
    }
    
    deinit {
        print("\(self.name) deinit")
    }

}
