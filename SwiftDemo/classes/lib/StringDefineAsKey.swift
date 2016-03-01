//
//  StringDefineAsKey.swift
//  SwiftDemo
//
//  Created by Jren on 15/12/18.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

import Foundation

class Keys : NSObject {
    
    private override init(){}
    
    static let kk = Keys()
    
    lazy var keyDicts : NSMutableDictionary = {
        return self.setupKeyDicts()
    }()
    
    func setupKeyDicts() -> NSMutableDictionary {
        
        let dict:NSMutableDictionary = NSMutableDictionary()
        
        let mirror = Mirror(reflecting: Keys.kk)
        
        for i in mirror.children.startIndex ..< mirror.children.endIndex {
            
            print("key: \(mirror.children[i].0!), value: \(mirror.children[i].1)")
            
            let key : String = mirror.children[i].0!
            
            dict[key] = key
        }
        
        print("======")
        
        return dict

    }
    
    func configure() {
        
        objc_getAssociatedObject(self, "sdfdsf")
        
        let countPointer:UnsafeMutablePointer<UInt32> = UnsafeMutablePointer<UInt32>.alloc(1)
        
        let ivarList:UnsafeMutablePointer<Ivar> = class_copyIvarList(Keys.self, countPointer)
        
        print(countPointer.memory)
        
        for i in 0..<countPointer.memory {
            
            let ivar : UnsafeMutablePointer<Ivar>;
            
            if i == 0 {
                ivar = ivarList
            } else {
                ivar = ivarList.successor()
            }
            
            let name = String.fromCString(ivar_getName(ivar.memory))!
            
            print(name)
            
            var range = name.rangeOfString(".")
            
            
            var a = range?.startIndex
            var b = range?.endIndex
            
            print(a, b)
            
            dump(a)
            
            if !name.containsString(".") {
                object_setIvar(Keys.kk, ivar.memory, ".........")
            }
            
        }
        
        print(Keys.kk.abc)
        
        countPointer.dealloc(1)
        
        print(abc)
    }
    
    var abc:String! = "abc"
    
}