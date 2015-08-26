//
//  ViewController.swift
//  swift weather
//
//  Created by jason on 15/8/25.
//  Copyright (c) 2015年 JasonAi. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager:CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if(ios8())
        {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingLocation()  //开启坐标更新
    }
    
    func ios8() -> Bool{
        var version = (UIDevice.currentDevice().systemVersion as NSString).floatValue
        return version > 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        var location:CLLocation = locations[locations.count-1] as! CLLocation
        
        if location.horizontalAccuracy > 0
        {
            println(location.coordinate.latitude)
            println(location.coordinate.longitude)
        
            locationManager.stopUpdatingLocation() //关闭坐标更新，不然会一直回调此函数？
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFinishDeferredUpdatesWithError error: NSError!){
        
        println(error)
    }
}

