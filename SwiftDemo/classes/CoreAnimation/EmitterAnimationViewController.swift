//
//  EmitterAnimationViewController.swift
//  SwiftDemo
//
//  Created by Jren on 16/2/19.
//  Copyright © 2016年 jr-wong. All rights reserved.
//

import UIKit

class EmitterAnimationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let rect = CGRect(x: 0.0, y: -70.0, width: view.bounds.width,
            height: 50.0)
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        view.layer.addSublayer(emitter)
        emitter.emitterShape = kCAEmitterLayerVolume
        
        //kCAEmitterLayerPoint
        //kCAEmitterLayerLine
        //kCAEmitterLayerRectangle
        
        emitter.emitterPosition = view.center
//        emitter.emitterSize = rect.size
        
        configureCellsForEmitter(emitter)
        
        
        
    }
    
    func configureCellsForEmitter(emitter: CAEmitterLayer) {
        
        var images = [
            UIImage(named: "p_ico_heart_b"),
            UIImage(named: "p_ico_heart_c"),
            UIImage(named: "p_ico_heart_g"),
            UIImage(named: "p_ico_heart_o"),
            UIImage(named: "p_ico_heart_p"),
            UIImage(named: "p_ico_heart_y"),
            UIImage(named: "p_ico_heart_purple"),
        ]
        
        var cells : [CAEmitterCell] = []
        for i in 0..<7 {
            let emitterCell = CAEmitterCell()
            
            emitterCell.contents = images[i]?.scaleImageToWidth(10).CGImage
            
            emitterCell.birthRate = 10  //每秒产生120个粒子
            emitterCell.lifetime = 3    //存活1秒
            emitterCell.lifetimeRange = 3.0
            
            emitterCell.yAcceleration = 100.0  //给Y方向一个加速度
//            emitterCell.xAcceleration = 20.0 //x方向一个加速度
            emitterCell.emissionLongitude = CGFloat(-M_PI) //向左
            emitterCell.velocity = 20.0 //初始速度
            emitterCell.velocityRange = 200.0   //随机速度 -200+20 --- 200+20
            emitterCell.emissionRange = CGFloat(M_PI_2) //随机方向 -pi/2 --- pi/2
            //emitterCell.color = UIColor(red: 0.9, green: 1.0, blue: 1.0,
            //   alpha: 1.0).CGColor //指定颜色
//            emitterCell.redRange = 0.3
//            emitterCell.greenRange = 0.3
//            emitterCell.blueRange = 0.3  //三个随机颜色
            
            emitterCell.scale = 0.8
            emitterCell.scaleRange = 0.8  //0 - 1.6
            emitterCell.scaleSpeed = 0.15  //逐渐变小
            
            emitterCell.alphaRange = 0.75   //随机透明度
            emitterCell.alphaSpeed = -0.15  //逐渐消失
            
            cells.append(emitterCell)
        }
        
        emitter.emitterCells = cells  //这里可以设置多种粒子 我们以一种为粒子
        
    }
    
}


extension UIImage {
    
    /// 将当前图片缩放到指定宽度
    ///
    /// - parameter width: 指定宽度
    ///
    /// - returns: UIImage，如果本身比指定的宽度小，直接返回
    func scaleImageToWidth(width: CGFloat) -> UIImage {
        
        // 1. 判断宽度，如果小于指定宽度直接返回当前图像
        if size.width < width {
            return self
        }
        
        // 2. 计算等比例缩放的高度
        let height = width * size.height / size.width
        
        // 3. 图像的上下文
        let s = CGSize(width: width, height: height)
        // 提示：一旦开启上下文，所有的绘图都在当前上下文中
        UIGraphicsBeginImageContext(s)
        
        // 在制定区域中缩放绘制完整图像
        drawInRect(CGRect(origin: CGPointZero, size: s))
        
        // 4. 获取绘制结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5. 关闭上下文
        UIGraphicsEndImageContext()
        
        // 6. 返回结果
        return result
    }
}
