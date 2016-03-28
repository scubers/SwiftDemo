//
//  QTHeartAnimationController2.swift
//  SwiftDemo
//
//  Created by Jren on 16/1/19.
//  Copyright © 2016年 jr-wong. All rights reserved.
//

class QTHeartAnimationController2: UIViewController {
    
    
    lazy var bgView : UIView = UIView()
    
    lazy var animationViews : [UIView] = [UIView]()
    
    lazy var hearts = [
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
        bgView.backgroundColor = UIColor.blackColor()
        
        setupAnimation()
    }
    
    func setupAnimation() {
        let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        bgView.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        bgView.addGestureRecognizer(pan)
    }
    
    func handlePan(reco:UIPanGestureRecognizer) {
        let point = reco.locationInView(reco.view)
        let heart = createCommonView()
        heart.center = point
        reco.view?.addSubview(heart)
        animateHeart(heart, complete: nil)
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
        move.path           = createPathWithStartPoint(heart.center).CGPath
        move.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let translucente                 = CABasicAnimation(keyPath: "opacity")
        translucente.fromValue           = 1.0
        translucente.toValue             = 0.0
        translucente.removedOnCompletion = false
        
        let scale                 = CABasicAnimation(keyPath: "transform.scale")
        scale.toValue             = Double(random() % 3 + 3)
        scale.removedOnCompletion = false
        
        
        let animateGroup        = CAAnimationGroup()
        animateGroup.duration   = _duration
        animateGroup.animations = [move, translucente, scale]
        animateGroup.delegate   = self
        animateGroup.removedOnCompletion = false
        
        
        heart.layer.opacity = 0.0
        heart.layer.addAnimation(animateGroup, forKey: "group")
        
        animationViews.append(heart)
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        let view = animationViews.removeFirst()
        view.alpha = 0
        view.layer.removeAllAnimations()
        view.removeFromSuperview()
    }
    
    
    private var _maxRadius : CGFloat       = 150
    private var _minRadius : CGFloat       = 100
    private var _duration : NSTimeInterval = 2
    private var _maxVibration : CGFloat    = 5
    private var _maxTurn : CGFloat         = 2
    
    private var _minR : Double         = M_PI + M_PI_4
    private var _maxR : Double         = 2 * M_PI - M_PI_4
    
    
    
    func createPathWithStartPoint(point:CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        
        let endPoint = getRandomEndPointWithStartPoint(point, radius: _maxRadius)
        
        path.moveToPoint(point)
        
        let points = getRandomControlPoint4Line(point, endPoint: endPoint)
        
        path.addQuadCurveToPoint(endPoint, controlPoint: points.0)
        
        return path
    }
    
    func getRandomEndPointWithStartPoint(point:CGPoint, radius:CGFloat) -> CGPoint {
        
        let arc = getRandomR(_minR, maxR: _maxR)
        
        let ra = getRandomRadiusWith(_minRadius, maxRadius: _maxRadius)
        
        let deltaY = ra * CGFloat(sin(arc))
        let deltaX = ra * CGFloat(cos(arc))
        
        return CGPointMake(point.x + deltaX, point.y - deltaY)
    }
    
    func getRandomRadiusWith(minRadius: CGFloat, maxRadius: CGFloat) -> CGFloat {
        var ra: CGFloat = 0.0
        while ra < minRadius {
            ra = CGFloat(random()) % maxRadius
        }
        return ra
    }
    
    
    func getRandomControlPoint4Line(startPoint:CGPoint, endPoint:CGPoint) -> (CGPoint, CGPoint) {
        
        let deltaX = endPoint.x - startPoint.x
        let deltaY = endPoint.y - startPoint.y
        
        let conX = startPoint.x + CGFloat(random()) % deltaX
        let conY = startPoint.y + CGFloat(random()) % deltaY
        
        print("\(deltaX), \(deltaY)")
        
        
        return (CGPointMake(conX, conY), CGPointZero)
    }
    
    func getRandomR(minR:Double, maxR: Double) -> Double {
        var arc : Double = 0.0
        while arc < minR || arc > maxR {
            arc = Double(random()) % (M_PI * 2)
        }
        return arc - M_PI
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
