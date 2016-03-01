//
//  BasicAnimation.swift
//  SwiftDemo
//
//  Created by Jren on 15/12/29.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

import pop

class BasicAnimationShapeLayer : CAShapeLayer {
    
    var progress : CGFloat = 0 {
        didSet {
            didSetProgress()
        }
    }
    
    override init () {
        super.init()
        self.strokeColor = jr_randomColor()?.CGColor
        self.fillColor = UIColor.clearColor().CGColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didSetProgress() {
        
        let path = UIBezierPath(arcCenter: self.frame.center, radius: 50, startAngle: 0, endAngle: (2 * CGFloat(M_PI) * progress), clockwise: true)
        
        self.path = path.CGPath
        
        self.strokeStart = 0
        self.strokeEnd = 1
    }
    
    class override func needsDisplayForKey(key:String) -> Bool {
        if key == "progress" {
            return true
        }
        return super.needsDisplayForKey(key)
    }


    func animateWithProgress(aProgress: CGFloat) {
        self.progress = aProgress;
    }
    
    func animate() {
        
        self.strokeStart = 0
        self.strokeEnd = 1
        self.strokeColor = jr_randomColor()?.CGColor
        self.fillColor = UIColor.clearColor().CGColor
        
        let endAngle = CGFloat(2 * M_PI)
        
        let path = UIBezierPath(arcCenter: self.frame.center, radius: 50, startAngle: 0, endAngle: endAngle, clockwise: true)
        
        
        print(path)
        
        self.path = path.CGPath
        
        let ba : CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        ba.fromValue = 0
        ba.toValue = 1
        
        ba.duration = 3
        
        self.addAnimation(ba, forKey: "progressAnimation")
        

        
    }
    
}

class BasicAnimation: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = jr_randomColor()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        block {
            let layer = BasicAnimationShapeLayer()
            layer.frame = self.view.bounds
            self.view.layer.addSublayer(layer)
            
            jr_delay(0.1, queue: dispatch_get_main_queue(), block: { () -> Void in
                let anim = POPSpringAnimation()
                let prop = POPAnimatableProperty.propertyWithName("progress", initializer: { (prop : POPMutableAnimatableProperty!) -> Void in
                    prop.setupReadBlock({ (obj, values) -> Void in
                        values[0] = (obj as! BasicAnimationShapeLayer).progress
                    })
                    prop.setupWriteBlock({ (obj, values) -> Void in
                        var value : CGFloat = values[0]
                        value = value * 100.0 / (100.0 * 100.0)
                        print(value)
                        (obj as! BasicAnimationShapeLayer).progress = value
                    })
                }) as! POPAnimatableProperty
                anim.property            = prop
                anim.fromValue           = 0
                anim.toValue             = 50
                anim.springBounciness    = 15;
                anim.removedOnCompletion = true
                
                layer.pop_addAnimation(anim, forKey: "123")
                
                anim.completionBlock = { (anim: POPAnimation!, finish : Bool) in
                    print("complete")
                    let ani                 = POPSpringAnimation(propertyNamed: kPOPLayerTranslationXY)
                    ani.toValue             = NSValue(CGPoint: CGPointMake(50, 100))
                    ani.springBounciness    = 20
                    layer.pop_addAnimation(ani, forKey: "123")
                    ani.removedOnCompletion = true
                }
            })
            
        }
        
    }

}

extension POPMutableAnimatableProperty {
    
    public typealias POPReadBlock = (obj : AnyObject!, values : UnsafeMutablePointer<CGFloat>) -> Void
    public typealias POPWriteBlock = (obj : AnyObject!, values : UnsafePointer<CGFloat>) -> Void
    
    func setupReadBlock(block : POPReadBlock) {
        self.readBlock = block
    }
    
    func setupWriteBlock(block : POPWriteBlock) {
        self.writeBlock = block
    }
}