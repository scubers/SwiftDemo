//
//  CoreImageViewController.swift
//  SwiftDemo
//
//  Created by Jren on 16/2/24.
//  Copyright © 2016年 jr-wong. All rights reserved.
//

import UIKit
import SnapKit
import CoreImage

class WaterFloatAnimationViewController: UIViewController {
    
    @IBOutlet weak var processor: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cictx: CIContext = CIContext(EAGLContext: EAGLContext(API: .OpenGLES2))
    
    private var filterNames: [String] = []
    
    private var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupSubviews()
        setupFilterNames()
    }
    
    func setupNavigationItem() {
        let item = UIBarButtonItem(title: "选择图片", style: .Plain, target: self, action: "itemClick:")
        let start = UIBarButtonItem(title: "开始", style: .Plain, target: self, action: "startClick:")
        
        navigationItem.rightBarButtonItems = [item, start]
    }
    
    func setupFilterNames() {
        filterNames = CIFilter.filterNamesInCategory(kCICategoryBuiltIn)
    }
    
    func setupSubviews() {
        
        block {
            collectionView.backgroundColor = jr_randomColor()
            collectionView.registerClass(CoreImageCell.self, forCellWithReuseIdentifier: "111")
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.itemSize = CGSizeMake(90, 120)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
        
        block {
            let tap = UITapGestureRecognizer(target: self, action: "imageTap:")
            imageView.addGestureRecognizer(tap)
            
            let pan = UIPanGestureRecognizer(target: self, action: "imagePan:")
            imageView.addGestureRecognizer(pan)
            imageView.userInteractionEnabled = true
        }
        
        block {
            let ly = CAShapeLayer()
            
            ly.frame = imageView.bounds
            
            let path = UIBezierPath()
            
            ly.strokeColor = UIColor.blackColor().CGColor
            ly.backgroundColor = UIColor.whiteColor().CGColor
            ly.lineWidth = 10
            
            for i in 0..<Int(ly.frame.size.width / ly.lineWidth) / 2 + 1 {
                path.moveToPoint(CGPointMake(CGFloat(i) * ly.lineWidth * 2 + ly.lineWidth / 2, 0))
                path.addLineToPoint(CGPointMake(CGFloat(i) * ly.lineWidth * 2 + ly.lineWidth / 2, ly.bounds.size.height))
                
                path.moveToPoint(CGPointMake(0, CGFloat(i) * ly.lineWidth * 2 + ly.lineWidth / 2))
                path.addLineToPoint(CGPointMake(ly.bounds.size.width, CGFloat(i) * ly.lineWidth * 2 + ly.lineWidth / 2))
            }
            
            ly.strokeStart = 0
            ly.strokeEnd = 1
            ly.path = path.CGPath
            
            let img = ly.toImage()
            image = img
            imageView.image = img
            
        }
        
        block {
            processor.rac_signalForControlEvents(.ValueChanged).subscribeNext({ [weak self] (x: AnyObject!) -> Void in
                let slider = x as! UISlider
                self?.startFloat2(CGPointMake(0.5, 0.5), progress: Double(slider.value))
                })
        }
    }
    
    func imagePan(reco: UIPanGestureRecognizer) {
        guard image != nil else {return}
        var point = reco.locationInView(reco.view)
        point = CGPointMake(point.x / imageView.width, point.y / imageView.height)
        imageView.image = createModifyImage(self.image!, point: point)
    }
    
    func imageTap(reco: UITapGestureRecognizer) {
        guard image != nil else {return}
        var point = reco.locationInView(reco.view)
        point = CGPointMake(point.x / imageView.width, point.y / imageView.height)
        startFloat2(point, progress: Double(processor.value))
    }
    
    func itemClick(item: UIBarButtonItem) {
        let vc = UIImagePickerController()
        vc.sourceType  = .PhotoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func startClick(item: UIBarButtonItem) {
        
    }
    
    /**
     point 0~1
     */
    func createModifyImage(image:UIImage, point: CGPoint) -> UIImage {
        
        let a = NSDate().timeIntervalSince1970
        
        
        let centerVector = CIVector(CGPoint: CGPointMake(point.x * image.size.width, (point.y * -1 + 1) * image.size.height));
        
        let filter = CIFilter(name: "CIBumpDistortion")
        
        let inputImg = CIImage(image: image)
        filter?.setValue(inputImg, forKey: "inputImage")
        filter?.setValue(centerVector, forKey: "inputCenter")
        filter?.setValue(0.8, forKey: "inputScale")
        filter?.setValue(100, forKey: "inputRadius")
        
        
        let cgimg = cictx.createCGImage(filter!.outputImage!, fromRect: inputImg!.extent)
        
        let b = NSDate().timeIntervalSince1970
        print(b-a)
        
        return UIImage(CGImage: cgimg)
    }
    
    func startFloat(point: CGPoint, progress: Double) {
        
        let inputImg = CIImage(image: image!)
        let vector = CIVector(CGPoint: CGPointMake(point.x * image!.size.width, (point.y * -1 + 1) * image!.size.height));
        let width = CGFloat(progress) * image!.size.width + 10
        
        var outputFilter: CIFilter? = nil
        
        let filter = CIFilter(name: "CIBumpDistortion")
        filter?.setValue(inputImg, forKey: "inputImage")
        filter?.setValue(vector, forKey: "inputCenter")
        filter?.setValue(0.5, forKey: "inputScale")
        filter?.setValue(width, forKey: "inputRadius")
        
        let filter1 = CIFilter(name: "CIBumpDistortion")
        filter1?.setValue(vector, forKey: "inputCenter")
        filter1?.setValue(filter?.outputImage!, forKey: "inputImage")
        filter1?.setValue(-0.5, forKey: "inputScale")
        filter1?.setValue(width, forKey: "inputRadius")
        outputFilter = filter1
        
        
        let cgimg = cictx.createCGImage(outputFilter!.outputImage!, fromRect: inputImg!.extent)
        
        imageView.image = UIImage(CGImage: cgimg)
    }
    
    func startFloat2(point: CGPoint, progress: Double) {
        
        let w: Double = 10
        let r = CGFloat(progress) * image!.size.width / 2 // 波纹半径
        let centerVector = CIVector(CGPoint: CGPointMake(point.x * image!.size.width, (point.y * -1 + 1) * image!.size.height));
        
        let singleSita = 2.0 * asin(w / (2.0 * Double(r)))
        
        let n: Int = Int((2.0 * M_PI) / singleSita)
        
        var lastFilter: CIFilter? = nil
        for i in 0..<n {
            let filter = CIFilter(name: "CIBumpDistortion")

            var inputImg: CIImage? = lastFilter?.outputImage
            if inputImg == nil {inputImg = CIImage(image: image!)}
            
            filter?.setValue(inputImg, forKey: "inputImage")
            filter?.setValue(0.3, forKey: "inputScale")
            filter?.setValue(w * 2, forKey: "inputRadius")
            
            let x = centerVector.X + r * CGFloat(cos(singleSita * Double(i)))
            let y = centerVector.X + r * CGFloat(sin(singleSita * Double(i)))
            
            let p = CIVector(CGPoint: CGPointMake(x, y))
            filter?.setValue(p, forKey: "inputCenter")
            
            lastFilter = filter
        }
        let cgimg = cictx.createCGImage(lastFilter!.outputImage!, fromRect: CIImage(image: image!)!.extent)
        imageView.image = UIImage(CGImage: cgimg)
    }
    
    func startFloat3(point: CGPoint, progress: Double) {
        let r = CGFloat(progress) * image!.size.width / 2 // 波纹半径
        let centerVector = CIVector(CGPoint: CGPointMake(point.x * image!.size.width, (point.y * -1 + 1) * image!.size.height));
    }
    
}

extension WaterFloatAnimationViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNames.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("111", forIndexPath: indexPath) as? CoreImageCell
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let ce = cell as! CoreImageCell
        
        ce.imageView?.backgroundColor = jr_randomColor()
        ce.label?.text = filterNames[indexPath.row]
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}

extension WaterFloatAnimationViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(info)
        let img = info[UIImagePickerControllerEditedImage] as! UIImage
        image = img
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print(editingInfo)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


class CoreImageCell : UICollectionViewCell {
    
    var imageView: UIImageView?
    var label: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        imageView = UIImageView()
        self.contentView.addSubview(imageView!)
        
        label = UILabel()
        label?.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(label!)
        label?.backgroundColor = jr_randomColor()
        
        
        
        imageView?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.right.top.equalTo(imageView!.superview!)
            make.height.equalTo(imageView!.snp_width)
        })
        
        label?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.right.bottom.equalTo(label!.superview!)
            make.top.equalTo(imageView!.snp_bottom)
        })
        
        
    }
}