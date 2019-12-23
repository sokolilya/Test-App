//
//  WheatherModel.swift
//  Test Task
//
//  Created by Ilya Sokolov on 19.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class Weather : NSObject, NSCoding, Codable {
    func encode(with coder: NSCoder) {
        coder.encode(timezone, forKey: "WeatherTimezone")
        coder.encode(currently, forKey: "WeatherCurrently")
    }
    
    required convenience init(coder: NSCoder) {
        let currently = coder.decodeObject(forKey: "WeatherCurrently") as! Currently
        let timezone = coder.decodeObject(forKey: "WeatherTimezone") as! String
        
        self.init(timezone: timezone, currently: currently)
    }
    
    init(timezone: String, currently: Currently) {
        self.currently = currently
        self.timezone = timezone
    }
    
    let timezone : String
    let currently : Currently
}

class Currently: NSObject, NSCoding, Codable {
    func encode(with coder: NSCoder) {
        coder.encode(summary, forKey: "WeatherSummary")
        coder.encode(temperature, forKey: "WeatherTemperature")
        coder.encode(apparentTemperature, forKey: "WeatherApparentTemperature")
        coder.encode(windSpeed, forKey: "WeatherWindSpeed")
        coder.encode(precipType, forKey: "WeatherPrecipType")
    }
    
    required convenience init(coder: NSCoder) {
        let summary = coder.decodeObject(forKey: "WeatherSummary") as! String
        let temperature = coder.decodeFloat(forKey: "WeatherTemperature")
        let apparentTemperature = coder.decodeFloat(forKey: "WeatherApparentTemperature")
        let windSpeed = coder.decodeFloat(forKey: "WeatherWindSpeed")
        let precipType = coder.decodeObject(forKey: "WeatherPrecipType") as? String
        
        self.init(summary: summary, temperature: temperature, apparentTemperature: apparentTemperature, windSpeed: windSpeed, precipType: precipType)
    }
    
    init(summary: String, temperature: Float, apparentTemperature: Float, windSpeed: Float, precipType: String?) {
        self.summary = summary
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.windSpeed = windSpeed
        self.precipType = precipType
    }
    
    let summary : String
    let temperature : Float
    let apparentTemperature : Float
    let windSpeed : Float
    let precipType : String?
}

class WeatherData : NSObject, NSCoding {
    
    func encode(with coder: NSCoder) {
        coder.encode(date, forKey: "WeatherDate")
        coder.encode(weather, forKey: "Weather")
    }
    
    required convenience init(coder: NSCoder) {
        let date = coder.decodeObject(forKey: "WeatherDate") as! String
        let weather = coder.decodeObject(forKey: "Weather") as! Weather
        
        self.init(date: date, weather: weather)
    }
    
    init(date: String, weather: Weather) {
        self.date = date
        self.weather = weather
    }
    
    let date : String
    let weather : Weather
}
