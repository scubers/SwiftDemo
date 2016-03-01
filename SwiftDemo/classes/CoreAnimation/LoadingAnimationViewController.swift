//
//  LoadingAnimationViewController.swift
//  SwiftDemo
//
//  Created by Jren on 16/2/18.
//  Copyright © 2016年 jr-wong. All rights reserved.
//

import pop

enum LoadingState : Int {
    case Default = 0
    case Loading
    case Success
    case Failure
}

class LoadingLayer : CALayer {
    
    override init() {
        super.init()
        self.state = .Default
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal var state : LoadingState = .Loading {
        didSet {
            switch (state) {
            case .Default: break
            case .Loading: startAnimation()
            case .Success: endAnimationWithAngle(2 * M_PI * 0.625)
            case .Failure: break
            }
        }
    }
    
    internal var progress : Double = 0 {
        didSet {
            redrawLayer()
//            print(progress)
        }
    }
    
    private var roundLayer : CAShapeLayer? {
        didSet {
            oldValue?.removeFromSuperlayer()
            if roundLayer != nil && roundLayer?.superlayer == nil {
                roundLayer?.frame = self.bounds
                self.addSublayer(roundLayer!)
            }
        }
    }
    
    private var successLayer : CAShapeLayer?
    private var failureLayer : CAShapeLayer?
    
    func redrawLayer() {
        roundLayer = createRoundLayer()
    }
    
    func createRoundLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        
        layer.strokeColor = UIColor.whiteColor().CGColor
        layer.fillColor   = UIColor.clearColor().CGColor
        layer.strokeStart = 0
        layer.strokeEnd   = 1
        layer.lineCap     = "round"
        
        let x = CGRectGetMidX(self.frame)
        let y = CGRectGetMidY(self.frame)
        
        let d = 0.625
        let maxWidth : Double = 10
        
        layer.lineWidth = CGFloat(maxWidth * sin(progress * M_PI) + 1)
        
        let endAngle = CGFloat(2 * M_PI * progress)
        var startAngle : CGFloat = 0
        if progress > d {
            startAngle = CGFloat(((progress - d)/(1 - d)) * 2 * M_PI)
        }
        
        
        let path = UIBezierPath(arcCenter: CGPointMake(x, y), radius: 30, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        layer.path = path.CGPath
        
        var transform3D = CATransform3DMakeRotation(CGFloat(progress * M_PI * 2), 0, 1, 0)
        transform3D = CATransform3DRotate(transform3D, CGFloat(progress * M_PI * 2), 1, 0, 0)
        transform3D = CATransform3DRotate(transform3D, CGFloat(progress * M_PI * 2), 0, 0, 1)
        transform3D = CATransform3DScale(transform3D, 1, 1, 3)
        
        layer.transform = transform3D
        
//        let scale = CGFloat(d * sin(progress * M_PI) + 1)
//        layer.transform = CATransform3DMakeScale(scale, scale, scale)
        
        return layer
    }
    
    func endAnimation() {
        self.pop_removeAllAnimations()
        self.removeAllAnimations()
    }
    
    func endAnimationWithAngle(angle: Double) {
        
        if angle / (2 * M_PI) < progress {
            jr_delay(0.2, queue: dispatch_get_main_queue(), block: { () -> Void in
                self.endAnimationWithAngle(angle)
            })
            return
        }
        
        self.endAnimation()
        
        let ani = POPBasicAnimation()
        ani.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        ani.property = createAnimationPropertyForProgress()
        ani.toValue = angle / (2 * M_PI)
        ani.duration = 0.3
        ani.removedOnCompletion = true
        
        
        
        ani.completionBlock = {[weak self](animate, finished) in
            
            let endAni = CABasicAnimation(keyPath: "strokeStart")
            
            endAni.fromValue = NSNumber(double: 0)
            endAni.toValue = NSNumber(double: 1)
            endAni.duration = 0.15
            endAni.removedOnCompletion = true
            endAni.delegate = self
            
            self?.roundLayer?.strokeStart = 1
            self?.roundLayer?.addAnimation(endAni, forKey: "endAnimation");
            
            
        }
        
        self.pop_addAnimation(ani, forKey: "endAnimation")
        
        
        
    }
    
    func startAnimation() {
        
        let ani = POPBasicAnimation()
        
        successLayer?.removeFromSuperlayer()
        failureLayer?.removeFromSuperlayer()
        
        let prop = createAnimationPropertyForProgress()
        
        ani.property = prop
        ani.fromValue = 0
        ani.toValue = 1
        ani.duration = 2
        ani.repeatCount = Int.max
        
        roundLayer?.strokeStart = 0
        roundLayer?.strokeEnd = 1
        
        self.pop_addAnimation(ani, forKey: "animation")
        
    }

    func createAnimationPropertyForProgress() -> POPAnimatableProperty {
        return POPAnimatableProperty.propertyWithName("progress") { (prop : POPMutableAnimatableProperty!) -> Void in
            prop.setupReadBlock({ (obj, values) -> Void in
                values[0] = CGFloat((obj as! LoadingLayer).progress)
            })
            
            prop.setupWriteBlock({ (obj, values) -> Void in
                (obj as! LoadingLayer).progress = Double(values[0])
            })
            } as! POPAnimatableProperty
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
    }
    
}


class LoadingAnimationViewController: UIViewController {
    
    var ly : LoadingLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let layer = LoadingLayer()
        layer.frame = view.bounds;
        
        view.layer.addSublayer(layer)
        
        ly = layer
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if ly?.state == .Loading {
            jr_delay(0.5, queue: dispatch_get_main_queue()) { () -> Void in
                self.ly?.state = .Success
            }
        } else if ly?.state != .Loading {
            jr_delay(0.5, queue: dispatch_get_main_queue()) { () -> Void in
                self.ly?.state = .Loading
            }
        }
        
    }
    
}

