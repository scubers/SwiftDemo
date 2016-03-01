//
//  CustomPush.swift
//  SwiftDemo
//
//  Created by Jren on 15/12/23.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

import Foundation
import UIKit

class CustomPush : NSObject, UIViewControllerAnimatedTransitioning {
    
    override private init() {}
    static let shareInstance = CustomPush()
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fvc = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let tvc = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let fromView = fvc?.view
        let toView = tvc?.view
        
        let containerView = transitionContext.containerView()
        
        containerView?.addSubview(fromView!)
        containerView?.addSubview(toView!)
        
        
        toView?.transform = CGAffineTransformMakeScale(0.1, 0.1)
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: { () -> Void in
            
            fromView?.transform = CGAffineTransformMakeScale(0.9, 0.9)
            toView?.transform = CGAffineTransformIdentity
            
        }) { (finished: Bool) -> Void in
            
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}