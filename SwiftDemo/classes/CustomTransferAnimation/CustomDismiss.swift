//
//  CustomDismiss.swift
//  SwiftDemo
//
//  Created by Jren on 15/12/24.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

import Foundation


class CustomDismiss : NSObject, UIViewControllerAnimatedTransitioning {
    
    override private init() {}
    static let shareInstance = CustomDismiss()

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fvc = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let tvc = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let fv = fvc?.view
        let tv = tvc?.view
        
        let containerView = transitionContext.containerView()
        
        containerView?.addSubview(fv!)
        containerView?.addSubview(tv!)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: { () -> Void in            
            fv?.frame.origin.y -= (fv?.frame.size.height)!
            
            }) { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        
        
    }
}

extension CustomDismiss : UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}