//
//  ParentViewController.swift
//  SwiftDemo
//
//  Created by Jren on 15/12/25.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

class ParentViewController: UIViewController {
    
    var currentVC : UIViewController?
    var scrollView : UIScrollView?
    var segmentControl : UISegmentedControl?
    
    /// <NSIndexPath , UIView>
    lazy var screenShots : NSMutableDictionary? = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = jr_randomColor()
        
        setupSubviewAndController()
        
        setupSubviews()
        
        setupNavigationBar()
        
    }
    
    func setupSubviews() {
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView?.delegate = self
        self.view.addSubview(scrollView!)
        
        scrollView?.contentSize = CGSizeMake(self.view.frame.size.width * CGFloat(self.childViewControllers.count), 0)
        scrollView?.pagingEnabled = true
        
        self.childViewControllers.first!.view.frame = scrollView!.bounds
        
        scrollView?.addSubview(self.childViewControllers.first!.view)
        
        currentVC = self.childViewControllers.first
    }
    
    func setupSubviewAndController() {
        let c1 = Child1ViewController()
        let c2 = Child2ViewController()
        let c3 = Child3ViewController()
//        let c1 = FirstDemoViewController()
//        let c2 = SwiftKVOViewController()
//        let c3 = CustomStatusBarController()
        
        self.addChildViewController(c1)
        self.addChildViewController(c2)
        self.addChildViewController(c3)
    }
    
    func setupNavigationBar() {
        let segment = UISegmentedControl(items: ["Child1", "Child2", "Child3"])
        segment.frame = CGRectMake(150, 0, 100, 30)
        segment.selectedSegmentIndex = 0
        self.navigationItem.titleView = segment
        
        segment.addTarget(self, action: "segmentClick:", forControlEvents: .ValueChanged)
        
        segmentControl = segment
        
    }
    
    func segmentClick(sender:UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        let toVC = self.childViewControllers[sender.selectedSegmentIndex]
        if currentVC == toVC {
            return;
        }
        let point = CGPointMake(self.scrollView!.frame.size.width * CGFloat(sender.selectedSegmentIndex), 0)
        self.scrollView?.setContentOffset(point, animated: false)
        
        transitionViewControllerFrom(currentVC!, toController: toVC)
        
    }
    
    /**
     处理转场的操作，截屏等
     */
    func transitionViewControllerFrom(fvc: UIViewController, toController: UIViewController) {
        
        // 获取之前的截屏
        let screenShot = fvc.view.snapshotViewAfterScreenUpdates(false)
        let currentIndex = self.childViewControllers.indexOf(fvc)
        if currentIndex != nil {
            let indexPath = NSIndexPath(forRow: currentIndex!, inSection: 0)
            let view = self.screenShots![indexPath]
            if view != nil {
                (view as! UIView).removeFromSuperview()
            }
            self.screenShots![indexPath] = screenShot
        }
        screenShot.frame = (currentVC?.view.frame)!
        
        // 计算新界面的位置
        let toIndex = self.childViewControllers.indexOf(toController)
        if toIndex != nil {
            toController.view.frame = CGRectMake(CGFloat(toIndex!) * self.scrollView!.frame.size.width, 0, self.scrollView!.frame.size.width, self.scrollView!.frame.size.height)
        }
        
        
        toController.willMoveToParentViewController(self)
        toController.isMovingToParentViewController()
        currentVC?.isMovingFromParentViewController()
        transitionFromViewController(currentVC!, toViewController: toController, duration: 0, options: [.CurveEaseInOut], animations: { () -> Void in
            
            }) { (finished: Bool) -> Void in
                
                if finished {
                    self.currentVC = toController
                    toController.didMoveToParentViewController(self)
                    
                    let view = self.screenShots![NSIndexPath(forRow: currentIndex!, inSection: 0)]
                    
                    if view != nil {
                        self.scrollView!.addSubview(view as! UIView)
                    }
                    
                }
        }
    }
    

}

extension ParentViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width
        segmentControl?.selectedSegmentIndex = Int(currentPage)
        self.segmentClick(segmentControl!)
    }
}