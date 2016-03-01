//
//  CustomTransitionAnimateGuide.swift
//  SwiftDemo
//
//  Created by Jren on 15/12/24.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

import Foundation

// MARK: - UINavigationControllerDelegate
class First : NSObject, UINavigationControllerDelegate {
    
    /// 用来模拟控制器的view
    var tempView : UIView?
    
    override init() {
        super.init()
        tempView = UIView()
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        tempView?.addGestureRecognizer(pan)
    }
    
    /**
     使用此类，可以让转场动画根据百分比来执行
     
     使用此对象需要在某个时刻，调用 gestureDriven?.updateInteractiveTransition(CGFloat)来更新动画的进度 0~1
     
     如果是使用手势进行返回，可以在某个view上添加滑动手势，然后在处理手势的时候调用上述方法
     */
    var gestureDriven : UIPercentDrivenInteractiveTransition?
    
    /**
     如果需要进行手势驱动对转场动画进行交互的话，需要在本方法里面返回一个id<UIViewControllerInteractiveTransitioning>
     如果没有特殊需要，可以使用默认实现类 UIPercentDrivenInteractiveTransition
     */
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return gestureDriven
    }
    
    /**
     此方法返回导航控制器push或者pop 控制器时的动画控制器 id<UIViewControllerAnimatedTransitioning>
     */
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch (operation) {
        case .Push:
            return nil //< 返回id<UIViewControllerAnimatedTransitioning>
        case .Pop:
            return nil //< 返回id<UIViewControllerAnimatedTransitioning>
        default:break;
        }
        return nil
    }
    
    func handlePan(reco:UIPanGestureRecognizer) {
        let progress = reco.translationInView(tempView).x / (tempView?.frame.size.width)! // 自己计算动画百分比
        switch (reco.state) {
        case .Began:
            gestureDriven = UIPercentDrivenInteractiveTransition()
            // TODO: 一般为控制器，需要执行导航栏的.popViewController(animated:true)
            // navigationController.popViewController(animated:true)
        case .Changed:
            gestureDriven?.updateInteractiveTransition(progress)
        case .Ended, .Cancelled:
            if progress > 0.5 {
                gestureDriven?.finishInteractiveTransition()
            } else {
                gestureDriven?.cancelInteractiveTransition()
            }
            gestureDriven = nil
        default: break
        }
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
// MARK: 动画控制器，控制转场时执行怎样的动画
class Second : NSObject, UIViewControllerAnimatedTransitioning {
    
    /**
     返回转场动画的时长
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    /**
     具体执行动画的方法
     执行动画需要在 transitionContext的containerView中执行
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fvc = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let tvc = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let fv = fvc?.view
        let tv = tvc?.view
        
        let containerView = transitionContext.containerView()
        
        containerView?.addSubview(fv!)
        containerView?.addSubview(tv!)
        
        print("\(fvc),\(tvc),\(tv),\(fv),\(containerView)")

    }
}

// MARK: - UIViewControllerTransitioningDelegate 
// MARK: 此协议是处理Present已经Dismiss 控制器时的转场动画
class Third : NSObject, UIViewControllerTransitioningDelegate {
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}