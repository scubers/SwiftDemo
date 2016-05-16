//
//  GaussAnimator.swift
//  SwiftDemo
//
//  Created by JMacMini on 16/5/16.
//  Copyright © 2016年 jr-wong. All rights reserved.
//

import UIKit

class GaussAnimator: NSObject, UIViewControllerAnimatedTransitioning {

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

extension GaussAnimator : UIViewControllerTransitioningDelegate {
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