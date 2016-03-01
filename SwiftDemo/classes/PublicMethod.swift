//
//  PublicMethod.swift
//  SwiftDemo
//
//  Created by Jren on 15/12/17.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

import Foundation
import UIKit

/**
 *用来替代swift中无法直接使用大括号
 */
func block(@noescape closure:()->()) {
    closure()
}

func example(description:String? = "", @noescape closure:()->()) {
    print("-----------\(description)------------")
    closure()
}

/**
 *颜色的方便方法
 */
func jr_rgbaColor(r r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor? {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

/**
 *随机颜色
 */
func jr_randomColor() -> UIColor? {
    return UIColor(red: (CGFloat(random())%100 / 100), green: (CGFloat(random())%100 / 100), blue: (CGFloat(random())%100 / 100), alpha: (CGFloat(random())%100 / 100))
}
/**
 *获取appDelegate
 */
func appDelegate() -> AppDelegate? {
    return (UIApplication.sharedApplication().delegate as? AppDelegate)!
}

/**
 *获取包版本
 */
func bundleVersion() -> String? {
    return (NSBundle.mainBundle().infoDictionary?["CFBundleVersion"])! as? String;
}

/**
 *系统版本 ios7.8.9
 */
func systemVersion() -> Double {
    return Double(UIDevice.currentDevice().systemVersion)!
}

// MARK: - 路径
func documentsDirectory() -> String {
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
}
func libraryDirectory() -> String {
    return NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true).first!
}
func cacheDirectory() -> String {
    return NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first!
}

// 工具
func jr_uuid() -> String {
    let uuidRef = CFUUIDCreate(kCFAllocatorDefault)
    let string = CFUUIDCreateString(kCFAllocatorDefault, uuidRef)
    return string as String
}

// MARK: - GCD相关
func jr_delay(seconds:Double, queue:dispatch_queue_t, block:dispatch_block_t) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC))), queue, block)
}

extension CGRect {

    var center : CGPoint {
        get {
            return CGPointMake(CGRectGetMidX(self), CGRectGetMidY(self))
        }
    }
}


extension UIView {
    var x : CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var y : CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var width : CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var height : CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
}

extension CALayer {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, self.contentsScale)
        self.renderInContext(UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
