//
//  CustomPop.swift
//  SwiftDemo
//
//  Created by Jren on 15/12/23.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

import Foundation


class CustomPop : NSObject, UIViewControllerAnimatedTransitioning {
    
    override private init() {}
    static let shareInstance = CustomPop()
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fvc = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let tvc = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let fromView = fvc?.view
        let toView = tvc?.view
        
        let containerView = transitionContext.containerView()
        
        containerView?.addSubview(toView!)
        containerView?.addSubview(fromView!)
        
//        toView?.frame = transitionContext.finalFrameForViewController(tvc!)
        toView?.transform = CGAffineTransformMakeScale(0.9, 0.9)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: { () -> Void in
            
            fromView?.transform = CGAffineTransformMakeScale(0.1, 0.1)
            toView?.transform = CGAffineTransformIdentity
            
        }) { (finished: Bool) -> Void in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            
        }

    }
}