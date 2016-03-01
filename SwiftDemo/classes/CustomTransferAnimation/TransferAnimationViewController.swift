//
//  TransferAnimationViewController.swift
//  SwiftDemo
//
//  Created by Jren on 15/12/23.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

import UIKit

class TransferAnimationViewController: UIViewController {
    
    var panDriven : UIPercentDrivenInteractiveTransition?
    var slidePanDriven : UIPercentDrivenInteractiveTransition?
    var backgroundView : UIView?
    var slideView : UIView?
    
    var tag = TransferAnimationViewController.i++
    
    static var i : Int = 0
    
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = jr_randomColor()
        self.transitioningDelegate = self

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        block {
            let v = UIView(frame: self.view.bounds)
            self.view.addSubview(v)
            v.backgroundColor = jr_randomColor()
        }
        
        block {
            self.backgroundView = UIView(frame: self.view.frame)
            self.view.addSubview(self.backgroundView!)
            self.backgroundView?.backgroundColor = jr_randomColor()
        }
        
        block {
            let button = UIButton(type: .ContactAdd)
            button.frame = CGRectMake(0, 100, 20, 20)
            self.view.addSubview(button)
            button.addTarget(self, action: "click:", forControlEvents: .TouchUpInside)
        }

        block {
            let presentButton = UIButton(type: .Custom)
            presentButton.frame = CGRectMake(0, 200, 100, 20)
            presentButton.setTitle("present", forState: .Normal)
            self.view.addSubview(presentButton)
            presentButton.backgroundColor = jr_randomColor()
            presentButton.addTarget(self, action: "present:", forControlEvents: .TouchUpInside)
        }
        
        block {
            let dismissButton = UIButton(type: .Custom)
            dismissButton.frame = CGRectMake(0, 300, 100, 20)
            dismissButton.setTitle("dismiss", forState: .Normal)
            self.view.addSubview(dismissButton)
            dismissButton.backgroundColor = jr_randomColor()
            dismissButton.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
        }
        
        block {
            self.slideView = UIView()
            self.slideView?.backgroundColor = jr_randomColor()
            self.view.addSubview(self.slideView!)
            self.slideView?.frame = CGRectMake(200, 0, self.view.frame.size.width - 200, self.view.frame.size.height)
            let pan = UIPanGestureRecognizer(target: self, action: "slidePan:")
            self.slideView?.addGestureRecognizer(pan)
        }
    }
    
    func click(sender:UIButton) {
        self.navigationController?.pushViewController(TransferAnimationViewController(), animated: true)
    }
    
    func present(sender: UIButton) {
        self.presentViewController(TransferAnimationViewController(), animated: true, completion: nil)
    }
    func dismiss(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.delegate = self
        
        if self.navigationController != nil {
            let pan = UIPanGestureRecognizer(target: self, action: "pan:")
            self.backgroundView?.addGestureRecognizer(pan)
        }
        
        self.printTag()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
    
    func pan(reco:UIPanGestureRecognizer) {
        
        var progress = (reco.translationInView(self.backgroundView!).x / self.backgroundView!.bounds.width) / 5
        
        progress = progress > 1 ? 1 : progress
        
        switch (reco.state) {
        case .Began:
            panDriven = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewControllerAnimated(true)
        case .Changed:
            self.panDriven?.updateInteractiveTransition(progress)
        case .Ended,.Cancelled:
            if progress > 0.5 {
                panDriven?.finishInteractiveTransition()
            } else {
                panDriven?.cancelInteractiveTransition()
            }
            self.panDriven = nil
        default:break
        }
        
    }
    
    func slidePan(reco:UIPanGestureRecognizer) {
        var progress = (reco.translationInView(reco.view!).y / reco.view!.bounds.height)
        progress = progress > 1 ? 1 : progress
        progress = progress < -1 ? -1 : progress
        
        print("\(progress)     \(self.tag)")
        
        switch (reco.state) {
        case .Began:
            slidePanDriven = UIPercentDrivenInteractiveTransition()
            if progress > 0 {
                let vc = TransferAnimationViewController()
                vc.transitioningDelegate = self
                self.presentViewController(vc, animated: true, completion: nil)
            } else {
//                self.presentingViewController?.transitioningDelegate = self
                self.transitioningDelegate = self
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        case .Changed:
            self.slidePanDriven?.updateInteractiveTransition(abs(progress))
        case .Ended,.Cancelled:
            if progress > 0.2 || progress < 0 {
                slidePanDriven?.finishInteractiveTransition()
            } else {
                slidePanDriven?.cancelInteractiveTransition()
            }
            self.slidePanDriven = nil
        default:break
        }
    }
    
    func printTag() {
        print("---===---===\(self.tag)")
    }

}

// MARK: -  UINavigationControllerDelegate
extension TransferAnimationViewController : UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return panDriven
        
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch (operation) {
        case .Push:
            return CustomPush.shareInstance
        case .Pop:
            return CustomPop.shareInstance
        default:
            break;
        }
        
        return nil
    }
    
    
}



// MARK: - dismiss 以及 present 需要完成的协议
extension TransferAnimationViewController : UIViewControllerTransitioningDelegate  {
    internal func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return slidePanDriven
    }
    
    internal func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return slidePanDriven
    }
    
    internal func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresent.shareInstance
    }
    
    internal func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomDismiss.shareInstance
    }
}
