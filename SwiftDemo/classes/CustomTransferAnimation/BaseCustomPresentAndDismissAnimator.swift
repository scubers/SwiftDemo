//
//  BaseCustomPresentAndDismissAnimator.swift
//  SwiftDemo
//
//  Created by JMacMini on 16/5/16.
//  Copyright © 2016年 jr-wong. All rights reserved.
//

import UIKit

public enum BaseCustomPresentAndDismissAnimatorType {
    case Present
    case Dismiss
}

public class BaseCustomPresentAndDismissAnimator: NSObject {
    
    public typealias AnimateBlock = (animator: BaseCustomPresentAndDismissAnimator,transitionContext: UIViewControllerContextTransitioning, type: BaseCustomPresentAndDismissAnimatorType)->Void
    
    private(set) var animateBlock: AnimateBlock?
    private(set) var percentDriven: UIPercentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
    private(set) var type: BaseCustomPresentAndDismissAnimatorType = .Present
    
    private(set) weak var viewController: UIViewController?
    
    var interactionEnable: Bool = false

    convenience init(interationEnable: Bool = false, type: BaseCustomPresentAndDismissAnimatorType , target vc: UIViewController, animateBlock: AnimateBlock?) {
        self.init()
        self.interactionEnable = interationEnable
        self.type = type
        self.animateBlock = animateBlock
        self.viewController = vc
        self.viewController?.transitioningDelegate = self
    }
}

extension BaseCustomPresentAndDismissAnimator : UIViewControllerTransitioningDelegate {
    
    public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionEnable ? percentDriven : nil
    }
    
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionEnable ? percentDriven : nil
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

extension BaseCustomPresentAndDismissAnimator : UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        animateBlock?(animator: self,transitionContext: transitionContext, type: type)
    }
}