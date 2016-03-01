//
//  PuTongDiTuViewController.swift
//  SwiftDemo
//
//  Created by Jren on 15/12/21.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

import UIKit

class PuTongDiTuViewController: UIViewController {
    
    var mapView : BMKMapView!
    var currentCoordinate : CLLocationCoordinate2D!
    var annotation: MyMapAnnotation!
    
    
    func configureMapView() {
        let span = BMKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        if currentCoordinate == nil {
            currentCoordinate = CLLocationCoordinate2D(latitude: 22.5461, longitude: 113.9455)
        }
        let region = BMKCoordinateRegion(center: currentCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func setupCoordinate() {
        let lmgr = CLLocationManager()
        lmgr.delegate = self
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5)), dispatch_get_main_queue()) { () -> Void in
            lmgr.startUpdatingLocation()
        }
    }
    
    deinit {
        print("")
    }

    
}

// MARK: - CLLocationManagerDelegate
extension PuTongDiTuViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingHeading()
        if locations.count > 0 {
            self.currentCoordinate = locations.first?.coordinate
            configureMapView()
        }
    }
}

// MARK: - BMKMapViewDelegate

extension PuTongDiTuViewController : BMKMapViewDelegate {
    
    func mapView(mapView: BMKMapView!, onClickedMapPoi mapPoi: BMKMapPoi!) {
        print("conClickedMapPoi")
    }
    
    func mapview(mapView: BMKMapView!, onDoubleClick coordinate: CLLocationCoordinate2D) {
        self.mapview(mapView, onLongClick: coordinate)
    }
    
    func mapview(mapView: BMKMapView!, onLongClick coordinate: CLLocationCoordinate2D) {
        annotation = MyMapAnnotation(coordinate: coordinate)
        annotation.title = "abc"
        annotation.subtitle = "def"
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        var av = mapView.dequeueReusableAnnotationViewWithIdentifier(NSStringFromClass(BMKPinAnnotationView.self)) as? BMKPinAnnotationView
        
        if av == nil {
            av = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(BMKPinAnnotationView.self))
        }
        av?.draggable = true
        av?.animatesDrop = true
        
        av?.bounds = CGRectMake(0, 0, 100, 100)
        av?.backgroundColor = jr_randomColor()
        
        let cv = UIView(frame: CGRectMake(0, 0, 20, 20))
        cv.backgroundColor = jr_randomColor()
        av?.paopaoView = BMKActionPaopaoView(customView: cv)
//        av?.image = R.image.icon
        av?.clipsToBounds = true
        
        
        return av
    }
    
    func mapView(mapView: BMKMapView!, annotationView view: BMKAnnotationView!, didChangeDragState newState: UInt, fromOldState oldState: UInt) {
        print("\(annotation)")
    }
    
    func mapView(mapView: BMKMapView!, didSelectAnnotationView view: BMKAnnotationView!) {
        print(view)
    }
    
    
    
    
}

// MARK: - 生命周期
extension PuTongDiTuViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = BMKMapView(frame: self.view.frame)
        self.view.addSubview(mapView)
        self.configureMapView()
        self.setupCoordinate()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.viewWillAppear()
        mapView.delegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        mapView.viewWillDisappear()
        mapView.delegate = nil
    }
    

}
