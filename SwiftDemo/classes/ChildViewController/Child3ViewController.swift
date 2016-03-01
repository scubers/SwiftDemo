//
//  Child3ViewController.swift
//  SwiftDemo
//
//  Created by Jren on 15/12/25.
//  Copyright © 2015年 jr-wong. All rights reserved.
//


class Child3ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellowColor()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("\(self)")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("c3 will appear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("c3 did appear   \(self.navigationController)")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("c3 will disappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("c3 did disappear")
    }
    
    deinit {
        print("")
    }
}
