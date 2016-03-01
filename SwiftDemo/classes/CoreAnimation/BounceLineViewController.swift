//
//  BounceLineViewController.swift
//  SwiftDemo
//
//  Created by Jren on 16/2/17.
//  Copyright © 2016年 jr-wong. All rights reserved.
//

import BlocksKit


class BounceLineViewController: UIViewController {
    
    var layer : CAShapeLayer!
    var controlLayer : CAShapeLayer! {
        didSet {
            oldValue?.removeFromSuperlayer()
            view.layer.addSublayer(controlLayer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = jr_randomColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.lightGrayColor()
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
        
        layer = CAShapeLayer()

        layer.fillColor   = jr_randomColor()?.CGColor
        layer.lineWidth   = 2
        layer.strokeStart = 0
        layer.strokeEnd   = 1
        
        view.layer.addSublayer(layer)
        
    }
    
    private var startPoint = CGPointMake(0, 300)
    private var endPoint = CGPointMake(375, 300)
    private var controlPoint = CGPointMake(375 / 2.0, 300) {
        didSet {
            drawPath()
        }
    }
    func drawPath() {
        
        let path = UIBezierPath()

        path.moveToPoint(CGPointZero)
        path.addLineToPoint(startPoint)
        path.addQuadCurveToPoint(endPoint, controlPoint: controlPoint)
        path.addLineToPoint(CGPointMake(375, 0))
        
        layer.path = path.CGPath
        
//        controlLayer = createControlLayer()
    }
    
    func createControlLayer() -> CAShapeLayer! {
        let p = CAShapeLayer()
        p.frame = CGRectMake(controlPoint.x, controlPoint.y, 10, 10)
        p.backgroundColor = UIColor.whiteColor().CGColor
        return p
    }

    
    
}

extension BounceLineViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.controlPoint = CGPointMake(endPoint.x / 2 - scrollView.contentOffset.x, startPoint.y - scrollView.contentOffset.y)
        print(scrollView.contentOffset)
    }
}
