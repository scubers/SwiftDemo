//
//  TTTViewController.swift
//  SwiftDemo
//
//  Created by JMacMini on 16/5/16.
//  Copyright © 2016年 jr-wong. All rights reserved.
//

import UIKit

class TTTViewController: UIViewController {

    @IBAction func change(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .OverCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.lightGrayColor()
        view.backgroundColor = UIColor.clearColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        transitioningDelegate = nil
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
