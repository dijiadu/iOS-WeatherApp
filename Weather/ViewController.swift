//
//  ViewController.swift
//  Weather
//
//  Created by Diji Adu on 30/07/2015.
//  Copyright (c) 2015 Diji Adu. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: Properties
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    // Class vars
    
    let locationManager = CLLocationManager()
    let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=%.2f&lon=%.2f&units=metric"
    //http://api.openweathermap.org/data/2.5/weather?q=London,uk&units=metric
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    override func viewDidAppear(animated: Bool) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Location Manager
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locationManager.stopUpdatingLocation()
        getWeatherData(locationManager.location!.coordinate)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog("Location ERROR: %@", error.localizedDescription)
    }
    
    // MARK: Weather
    
    func getWeatherData(coordinates: CLLocationCoordinate2D) {
        let locationUrlString = String(format: urlString, coordinates.latitude, coordinates.longitude)
        let url = NSURL(string: locationUrlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler:{(data, response, error)->Void in
            dispatch_async(dispatch_get_main_queue(), {
                if error == nil {
                    self.setLabels(data)
                } else {
                    NSLog("Request ERROR: %@", error.localizedDescription)
                }
            })
        })
        
        task.resume()
    }
    
    func setLabels(weatherData: NSData) {
        var jsonError: NSError?
        
        if let json = NSJSONSerialization.JSONObjectWithData(weatherData, options: nil, error: &jsonError) as? NSDictionary {
            if let name = json["name"] as? String {
                cityLabel.text = name
            }
            
            if let main = json["main"] as? NSDictionary {
                if let temp = main["temp"] as? Double {
                    tempLabel.text = String(format: "%.0f℃", temp)
                }
            }
            
            if let weather = json["weather"] as? NSArray {
                if let weatherDict = weather[0] as? NSDictionary {
                    if let main = weatherDict["main"] as? String {
                        weatherLabel.text = main
                    }
                    
                    if let icon = weatherDict["icon"] as? String {
                        weatherImage.image = UIImage(named: icon)
                    }
                }
            }
        } else {
            NSLog("Parse ERROR: %@", jsonError!.localizedDescription)
        }
    }
}

