//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Diji Adu on 30/07/2015.
//  Copyright (c) 2015 Diji Adu. All rights reserved.
//

import UIKit
import XCTest
import Weather
import CoreLocation

class WeatherTests: XCTestCase {
    
    var vc: ViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        vc = storyboard.instantiateViewControllerWithIdentifier("WeatherVC") as! ViewController
        vc.loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewDidLoad() {
        // assert that the ViewController.view is not nil
        XCTAssertNotNil(vc.view, "View Did Not load")
    }
    
    func testSetLabels() {
        let json = "{\"coord\":{\"lon\":138.93,\"lat\":34.97},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02n\"}],\"base\":\"stations\",\"main\":{\"temp\":26.52,\"pressure\":1009,\"humidity\":96,\"temp_min\":26.11,\"temp_max\":27.22},\"wind\":{\"speed\":1.96,\"deg\":226.004},\"rain\":{},\"clouds\":{\"all\":12},\"dt\":1438284810,\"sys\":{\"type\":3,\"id\":10294,\"message\":0.0197,\"country\":\"JP\",\"sunrise\":1438199534,\"sunset\":1438249723},\"id\":1851632,\"name\":\"Shuzenji\",\"cod\":200}"
        
        if let data = json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            vc.setLabels(data)
        }
        
        XCTAssertTrue(vc.cityLabel.text == "Shuzenji", "cityLabel is not set to 'Shuzenji', but to \(vc.cityLabel.text)")
        XCTAssertTrue(vc.weatherLabel.text == "Clouds", "weatherLabel is not set to 'clouds', but to \(vc.weatherLabel.text)")
        XCTAssertTrue(vc.tempLabel.text == "27℃", "tempLabel is not set to '27℃', but to \(vc.tempLabel.text)")
    }
    
    func testPerformanceOfGetWeather() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
            let coordinates = CLLocationCoordinate2D(latitude: 35, longitude: 139)
            self.vc.getWeatherData(coordinates)
        }
    }
    
}
