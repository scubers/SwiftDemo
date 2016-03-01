//
//  ViewController.swift
//  SwiftDemo
//
//  Created by mima on 15/12/5.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

import UIKit

class BaiduMapDemoViewController: UIViewController {
    
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
        infos.addObject(["普通地图":PuTongDiTuViewController.self])

    }
    
    
}

extension BaiduMapDemoViewController : UITableViewDelegate, UITableViewDataSource {
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
        
        cell?.textLabel?.text = self.infos.objectAtIndex(indexPath.row).allKeys.last as? String
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let clazz: UIViewController.Type! = (self.infos.objectAtIndex(indexPath.row).allValues.last as! UIViewController.Type)
        let vc = clazz.init()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

