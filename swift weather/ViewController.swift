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

    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var tempera: UILabel!
  
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
            println(location.coordinate.latitude)  //纬度
            println(location.coordinate.longitude)  //经度
        
            self.updateWeatherInfo(location.coordinate.latitude, longitude:location.coordinate.longitude)
            
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
        self.city.text = jsonResult["name"] as? String
        
        
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
       
        var weatherId = ((jsonResult["weather"] as! NSArray)[0] as! NSDictionary)["id"] as! Int
        
        println(weatherId)
        
        self.updateWeatherID(weatherId)
    }
    
    func updateWeatherID(weatherId:Int)
    {
        switch weatherId
        {
        case 200...232: //Thunderstorm
            break
        case 300...321: //Drizzle
            break
        case 500...531: //Rain
            break
        case 600...622: //Snow
            break
        case 701...781: //Atmosphere
            break
        case 800...804: //Clouds
            break
        case 900...906: //Extreme
            break
        case 950...962: //Additional
            break
        default:
            break
        }
    }
    
}

