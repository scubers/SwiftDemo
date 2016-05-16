//
//  TestCustViewController.swift
//  SwiftDemo
//
//  Created by JMacMini on 16/5/16.
//  Copyright © 2016年 jr-wong. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import JRUtils

class TestCustViewController: UITableViewController {
    
    var bag = DisposeBag()
    var animator: BaseCustomPresentAndDismissAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        tableView.rx_contentOffset.subscribeNext { [weak self] (point) in
            if point.y > 0 {return}
            
            if point.y < self!.tableView.contentInset.top
                && !self!.isBeingPresented()
                && self!.tableView.dragging
                && self!.animator == nil
                {
                
                let vc = TTTViewController()
                self!.animator = BaseCustomPresentAndDismissAnimator(interationEnable: true, type: .Present, target: vc, animateBlock: { (animator: BaseCustomPresentAndDismissAnimator,transitionContext, type) in
                    print("\(type)")
                    if type == .Present {
                        let fvc = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
                        let tvc = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
                        
                        let fv = fvc?.view
                        let tv = tvc?.view
                        
                        let containerView = transitionContext.containerView()
                        
                        containerView?.addSubview(fv!)
                        containerView?.addSubview(tv!)
                        tv?.frame = transitionContext.finalFrameForViewController(tvc!)
                        tv?.frame.origin.y -= (tv?.frame.size.height)!
                        
                        UIView.animateWithDuration(animator.transitionDuration(transitionContext), animations: { () -> Void in
                            tv?.frame = transitionContext.finalFrameForViewController(tvc!)
                        }) { (finished) -> Void in
                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                        }
                    }
                })
                self!.presentViewController(vc, animated: true, completion: nil)
            } else if self!.tableView.dragging
                 {
                let progress = point.y / 100
                print("progress: \(progress)")
                self?.animator?.percentDriven.updateInteractiveTransition(min(abs(progress), 1))
            }
        }.addDisposableTo(bag)
    }

    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < -1 || animator?.percentDriven.percentComplete > 0.4 {
            animator?.percentDriven.finishInteractiveTransition()
        } else {
            animator?.percentDriven.cancelInteractiveTransition()
        }
        animator = nil
        print("velocity: \(velocity)");
    }
//    override func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
//        animator?.percentDriven.finishInteractiveTransition()
//        animator = nil
//    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
    
    

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = indexPath.description
        return cell
    }


}
