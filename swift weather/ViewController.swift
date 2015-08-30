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

    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var tempera: UILabel!
  
    let locationManager:CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let background = UIImage(named: "background")
        self.view.backgroundColor = UIColor(patternImage: background!)
        
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
            println(location.coordinate.latitude)  //纬度
            println(location.coordinate.longitude)  //经度
        
            self.updateWeatherInfo(location.coordinate.latitude, longitude:location.coordinate.longitude)
            
//            self.updateWeatherInfo(39.39, longitude:116.38)
            
            locationManager.stopUpdatingLocation() //关闭坐标更新，不然会一直回调此函数？
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFinishDeferredUpdatesWithError error: NSError!){
        
        println(error)
    }
    
    func updateWeatherInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    {
        let manager = AFHTTPRequestOperationManager()
        let url = "http://api.openweathermap.org/data/2.5/weather"
        let params = ["lat":latitude, "lon":longitude, "cnt":0]
        
        manager.GET(url, parameters: params, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject) -> Void in
                println("JSON: " + responseObject.description)

                self.updateUIInfo(responseObject as! NSDictionary)
            }, failure: {(operation:AFHTTPRequestOperation, error:NSError) -> Void in
                println("get error!")
        })
        
    }
    
    func updateUIInfo(jsonResult:NSDictionary!)
    {
        //update the city
        var city = jsonResult["name"] as? String
        var country = jsonResult["sys"]?["country"] as? String
        self.city.text = "\(city!) in \(country!)"
        
        //update the temperature
        if let temperature = jsonResult["main"]?["temp"] as? Double
        {
            var tempResult:Double
            tempResult = round(temperature - 273.15)
            self.tempera.text = "\(tempResult)℃"
        }
        else
        {
            self.tempera.text = "Get temperature fail!"
        }
       
        //update the weather icon
        var icon = ((jsonResult["weather"] as! NSArray)[0] as! NSDictionary)["icon"] as! String
        self.icon.image = UIImage(named: icon)
        
        //update the description
        var des = ((jsonResult["weather"] as! NSArray)[0] as! NSDictionary)["description"] as? String
        var main_des = ((jsonResult["weather"] as! NSArray)[0] as! NSDictionary)["main"] as? String
        self.des.text = "\(des!)|\(main_des!)"
        
        //update the current time
        var UnixDate = jsonResult["dt"] as? NSTimeInterval
        var dateFormat = NSDateFormatter()
        
        var date = NSDate(timeIntervalSince1970: UnixDate!)
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var dateString = dateFormat.stringFromDate(date)
 
        self.currentTime.text = "\(dateString)"
    }
}

