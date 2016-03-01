//
//  SwiftKVOViewController.swift
//  SwiftDemo
//
//  Created by mima on 15/12/5.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

import UIKit
import ReactiveCocoa

class Person {
    var name: String?
    var age: Int = 0
    var disease = ["HIV", "SARS"]
    
    static let god: String = "fozu"
    
    lazy var money: Double = {
        print("------")
        return 100
    }()
    
    convenience init(name:String, age:Int) {
        self.init()
        self.name = name
        self.age = age
    }
    
    deinit {
        print("")
    }
    
}

class SwiftKVOViewController: UITableViewController {
    
    var label: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.tableView.backgroundColor = UIColor.blackColor()
        
        self.view.addSubview(label)
        label.backgroundColor = UIColor.yellowColor()
        label.frame = CGRectMake(0, 100, 300, 100)
        
        setupKVO()
        setupMirror()
        setupLazy()
        
        setupReactiveCocoa()
        
        
        
        
        
    }

    
    func setupLazy() {
        let p = Person()
        print("\(p.money)")
        print("\(p.money)")
        print("\(p.money)")
        
        let abc = p.disease.map { (string: String) -> String in
            return string.stringByAppendingString("---1")
        }
        print(abc, p.disease)

        for str in p.disease {
            print(str)
        }
    }
    
    func setupMirror() {
        let p = Person(name: "abc", age: 3)
        let mirror = Mirror(reflecting: p)
        
        for i in mirror.children.startIndex ..< mirror.children.endIndex {
            print("key: \(mirror.children[i].0!), value: \(mirror.children[i].1)");
        }
        
        print("=============");
        dump(p)
    }

    func setupKVO() {
//        self.tableView.addObserver(self, forKeyPath: "contentOffset", options:[.New, .Old], context: nil)
    }
    
    func setupReactiveCocoa() {
        
        weak var ws = self
        let disposer:RACDisposable = self.tableView.rac_observeKeyPath("contentOffset", options: [.New, .Old], observer: self) { (obj:AnyObject!, changes:[NSObject : AnyObject]!, a:Bool, b:Bool) -> Void in
            print("\(changes) + a: \(a) + b:\(b)")
            
            let point = changes!["new"]
            ws?.label.text = "\(point!)"
        }
        
        self.rac_willDeallocSignal().subscribeCompleted { () -> Void in
            disposer.dispose()
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let point = change!["new"]
        label.text = "\(point!)"
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    deinit {
        print("")
//        self.tableView.removeObserver(self, forKeyPath: "contentOffset")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
