//
//  QTHeartAnimationViewController.swift
//  SwiftDemo
//
//  Created by Jren on 16/1/19.
//  Copyright © 2016年 jr-wong. All rights reserved.
//

class QTHeartAnimationViewController: UIViewController {

    lazy var bgView : UIView = UIView()
    
    lazy var animationViews : [UIView] = [UIView]()
    
    lazy var hearts : [UIImage?] = [
        UIImage(named: "p_ico_heart_b"),
        UIImage(named: "p_ico_heart_c"),
        UIImage(named: "p_ico_heart_g"),
        UIImage(named: "p_ico_heart_o"),
        UIImage(named: "p_ico_heart_p"),
        UIImage(named: "p_ico_heart_y"),
        UIImage(named: "p_ico_heart_purple"),
        ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgView.frame = view.bounds
        view.addSubview(bgView)
        bgView.backgroundColor = jr_randomColor();
        
        setupAnimation()
    }
    
    func setupAnimation() {
        let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        bgView.addGestureRecognizer(tap)
    }
    
    func handleTap(reco:UITapGestureRecognizer) {
        
        let point = reco.locationInView(reco.view)
        
        let heart = createCommonView()
        
        heart.center = point
        
        reco.view?.addSubview(heart)
        
        animateHeart(heart, complete: nil)
    }
    
    func createCommonView() -> UIView {
        let imageView = UIImageView(image: hearts[random() % hearts.count])
        return imageView
    }
    
    func animateHeart(heart: UIView, complete:(()->())?) {
        
        
        let move = CAKeyframeAnimation(keyPath: "position")
        let path = UIBezierPath()
        path.moveToPoint(heart.center)
        path.addLineToPoint(CGPointMake(heart.center.x, heart.center.y + 200))
//        move.path = path.CGPath
        move.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        move.path = createPathWithStartPoint(heart.center).CGPath
        
        
        let translucente = CABasicAnimation(keyPath: "opacity")
        translucente.toValue = 0.0
        translucente.removedOnCompletion = false
        
        
        let animateGroup        = CAAnimationGroup()
        animateGroup.duration   = _duration
        animateGroup.animations = [move, translucente]
        animateGroup.delegate   = self
        animateGroup.removedOnCompletion = false
        
        heart.layer.addAnimation(animateGroup, forKey: "group")
        
        jr_delay(animateGroup.duration - 0.2, queue: dispatch_get_main_queue()) { () -> Void in
            heart.alpha = 0.0
        }
        
        drawLayerAtBgView(move.path!)
        
        animationViews.append(heart)
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        let view = animationViews.removeFirst()
        view.alpha = 0
        view.layer.removeAllAnimations()
        view.removeFromSuperview()
    }
    
    
    private var _maxRadius : CGFloat       = 100
    private var _duration : NSTimeInterval = 2
    private var _maxVibration : CGFloat    = 5
    private var _maxTurn : CGFloat         = 2
    
    
    func createPathWithStartPoint(point:CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        
        let endPoint = getRandomEndPointWithStartPoint(point, radius: _maxRadius)
        
        path.moveToPoint(point)
//        path.addLineToPoint(endPoint)
        let points = getRandomControlPoint4Line(point, endPoint: endPoint)
        
        path.addCurveToPoint(endPoint, controlPoint1: points.0, controlPoint2: points.1)
        
        
        
        
        return path
    }
    
    func getRandomEndPointWithStartPoint(point:CGPoint, radius:CGFloat) -> CGPoint {
        
        let arc = Double(random()) % (M_PI * 2)
        
        let deltaY = getRandomRadius(radius) * CGFloat(sin(arc))
        let deltaX = getRandomRadius(radius) * CGFloat(cos(arc))
        
        return CGPointMake(point.x - deltaX, point.y + deltaY)
    }
    
    func getRandomRadius(radius: CGFloat) -> CGFloat {
        return CGFloat(random()) % radius
    }
    
    
    func getRandomControlPoint4Line(startPoint:CGPoint, endPoint:CGPoint) -> (CGPoint, CGPoint) {
    
        let centerPoint = CGPointMake((endPoint.x + startPoint.x) / 2, (endPoint.y + startPoint.y) / 2 )
        
        let deltaX = centerPoint.x * 2
        let deltaY = centerPoint.y * 2
        
        let radius = sqrt(deltaX * deltaX + deltaY * deltaY)
        
        let p1 = getRandomEndPointWithStartPoint(centerPoint, radius: radius)
        let p2 = getRandomEndPointWithStartPoint(centerPoint, radius: radius)
        
        print("center:\(centerPoint), start:\(startPoint), end:\(endPoint), c1:\(p1), c2:\(p2), radius:\(radius)")
        
        return (p1, p2)
    }
    
    func drawLayerAtBgView(path:CGPathRef) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = path
        shapeLayer.lineWidth = 0.5
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 1
        
        bgView.layer.addSublayer(shapeLayer)
        
        let ba = CABasicAnimation(keyPath: "strokeEnd")
        ba.duration = _duration
        ba.fromValue = 0
        ba.toValue = 1
        ba.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        shapeLayer.addAnimation(ba, forKey: "abc")

        
        jr_delay(10, queue: dispatch_get_main_queue()) { () -> Void in
            shapeLayer.removeAllAnimations()
            shapeLayer.removeFromSuperlayer()
        }
        
        return shapeLayer
    }
}
