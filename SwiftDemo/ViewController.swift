//
//  ViewController.swift
//  SwiftDemo
//
//  Created by mima on 15/12/5.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var tableView: UITableView!
    
    lazy var infos: NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        self.view.backgroundColor = UIColor.whiteColor()
        
        setupDataSource()
        
    }
    
    func setupDataSource() {
        infos.addObject(["CoreAnimationDemo" : CoreAnimationViewController.self])
        infos.addObject(["父子controller" : ParentViewController.self])
        infos.addObject(["转场动画":TransferAnimationViewController.self])
        infos.addObject(["Test":FirstDemoViewController.self])
        infos.addObject(["KVO":SwiftKVOViewController.self])
        infos.addObject(["自定义状态栏":CustomStatusBarController.self])
        infos.addObject(["百度地图":BaiduMapDemoViewController.self])
        infos.addObject(["CoreImage":CoreImageViewController.self])
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
    }

}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell))
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: NSStringFromClass(UITableViewCell))
        }
        
        let dict : Dictionary = infos.objectAtIndex(indexPath.row) as! Dictionary<String, AnyClass>
        cell?.textLabel?.text = dict.keys.first
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let dict = infos.objectAtIndex(indexPath.row) as! Dictionary<String, AnyClass>
        
        let clazz : UIViewController.Type! = dict.values.first as! UIViewController.Type
        
        let vc = clazz.init()
        if let abc = vc as? TransferAnimationViewController {
            self.navigationController?.delegate = abc
        }
        self.navigationController?.pushViewController(vc, animated: true)
     
    }
}

