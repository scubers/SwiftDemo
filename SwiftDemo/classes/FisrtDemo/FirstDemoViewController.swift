//
//  FirstDemoViewController.swift
//  SwiftDemo
//
//  Created by mima on 15/12/5.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

import UIKit
import AFNetworking
import SDWebImage
import RxSwift
import ReactiveCocoa
import pop

class FirstDemoViewController: UIViewController {
    
    var shapeLayer: CAShapeLayer!
    var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        setupLayer()
        setupNetworking()
        setupImageView()
        setupSignal()
        testBlock()
        testPointer()
        
        testNSDateExtension()
        
    }
    
    // MARK: - 测试指针
    func testPointer() {
        
        block {
            func needPointer(pointer: UnsafeMutablePointer<Int>) {
                print(pointer.memory)
            }
            var count : Int = 4
            needPointer(&count)
            
            func needPointer2(pointer: UnsafeMutablePointer<FirstDemoViewController>) {
                pointer.memory.imgView = UIImageView()
                print(pointer.memory.imgView)
            }
            var fvc = FirstDemoViewController()
            fvc.imgView = self.imgView
            print(fvc.imgView)
            needPointer2(&fvc)
            
            
            withUnsafeMutablePointer(&fvc) { (pointer: UnsafeMutablePointer<FirstDemoViewController>) -> Void in
                let iv = UIImageView()
                pointer.memory.imgView = iv
                print(iv)
                print(fvc.imgView)
            }
            print(NSStringFromClass(NSString.self))
        }
        
        
    }
    
    // MARK: - 测试闭包
    func testBlock() {
        let array = NSMutableArray();
        
        array.addObject("sdfsdf")
        array.addObject("sferg")
        array.addObject("fergh")
        array.addObject("vrth")
        array.addObject("sefwfe")
        array.addObject("HTYJUYT")
        array.addObject("ERRH")
        
        array.enumerateObjectsUsingBlock { (obj, idx, stop) -> Void in
            if idx == 3 {
                stop.memory = true
            }
            print(obj)
        }
    }
    
    // MARK: - 测试pop动画
    var i: CGFloat = 1
    func setupAnimation() {
        let spring = POPSpringAnimation(propertyNamed: "position")
        spring.toValue = NSValue(CGPoint: CGPointMake(CGFloat(CGFloat(random())%UIScreen.mainScreen().bounds.size.width), CGFloat((CGFloat(random())%UIScreen.mainScreen().bounds.size.height))))
        self.imgView.pop_addAnimation(spring, forKey: "position")
        i *= -1
    }
    
    // MARK: - 测试信号
    func setupSignal() {
        
        let txf = UITextField()
        
        weak var ws = self
        txf.rac_textSignal().filter { (x) -> Bool in
            return (x as! NSString).length > 2
        }.subscribeNext { (x) -> Void in
            ws?.setupAnimation()
        }
        
        self.view.addSubview(txf)
        txf.frame = CGRectMake(100, 200, 40, 100)
        
        txf.backgroundColor = UIColor.yellowColor()
        
        
    }
    
    // MARK: - 测试sdwebimage
    func setupImageView() {
        imgView = UIImageView()
        self.view.addSubview(imgView)
        imgView.frame = CGRectMake(9, 100, 100, 100)
        
        imgView.sd_setImageWithURL(NSURL(string: "http://cc.cocimg.com/api/uploads/20150629/1435559914957299.jpg"))
    }
    
    // MARK: - 测试afn
    func setupNetworking() {
        let webView = UIWebView()
        self.view.addSubview(webView)
        webView.frame = self.view.bounds
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.baidu.com")!))
    }
    
    // MARK: - 测试日期分类
    func testNSDateExtension() {
        
        let date : NSDate = NSDate()
        
        print("year:\(date.year() as Int);\nmonth::\(date.month());\nday:\(date.day());\nhour:\(date.hour());\nminute:\(date.minute());\nsecond:\(date.second());\n")
        
        print("tommorow:\(date.tommorow())")
        print("yesterday:\(date.yesterday())")
        
        var tempDate = date
        print(" + : \(tempDate += 10)")
        tempDate = date
        print(" - : \(tempDate -= 10)")
        
        
        let dateString1 = "2013-11-11 22:22:22"
        let date1 = NSDate.parseDateWithString(dateString1, format: DateFormat.yyyy_MM_dd_HH_mm_mm)
        print(date1)
        
        let dateString2 = "2013/11/11 22.22.22"
        let date2 = NSDate.parseDateWithString(dateString2, format: DateFormat.yyyy_MM_dd_HH_mm_mm.toString("/", timeSeparator: ".")!)
        print(date2)
        
        
        if (date + 10) > (date) {
            print("")
        }
        
        if (date - 10) < date {
            print("")
        }
        
    }
    
    // MARK: - 私有方法
    func setupLayer() {
        shapeLayer = CAShapeLayer()
        
        shapeLayer.fillColor   = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = UIColor.blackColor().CGColor
        shapeLayer.lineWidth   = 4
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd   = 1
        
        let path = UIBezierPath()
        
        path.moveToPoint(CGPointMake(100, 100))
        path.addLineToPoint(CGPointMake(100, 200))

        shapeLayer.path = path.CGPath
        
        let link = CADisplayLink(target: self, selector: "animateLink")
        
        link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.view.layer.addSublayer(shapeLayer)
        
    }
    
    var b: CGFloat = 0.0
    func animateLink() {
        let rate = b % 100.0
        shapeLayer.strokeEnd = rate / 100
        b++
    }
    
    deinit {
        print("deinite\(self)")
    }

}
