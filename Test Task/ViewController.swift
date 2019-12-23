//
//  ViewController.swift
//  Test Task
//
//  Created by Ilya Sokolov on 19.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import CoreLocation

var weatherDataArray : [WeatherData] = []
var ready = true

class ViewController: UIViewController {
    
    let URL_BEGIN = "https://api.darksky.net/forecast/"
    let URL_END = "?exclude=hourly,daily,flags&units=auto"
    let KEY = "8635a097a32da503c993addfbac59ce3"
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
        backgroundImageView.image = #imageLiteral(resourceName: "background")
        
        loadWeather()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startUpdatingLocation), name: NSNotification.Name("UpdateLocation"), object: nil)
    }
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var apparentTemperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dataBaseButtonOutlet: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBAction func updateWeatherButtonAction(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("UpdateLocation"), object: nil)
    }
    
    func getWeatherData(coordinates: String) {
        guard let url = URL(string: URL_BEGIN + KEY + coordinates + URL_END) else { return }
        print(url)
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            guard let dataResponse = data,
                    error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return
            }
            
            OperationQueue.main.addOperation {
                self.parseJSON(with: dataResponse)
            }
        }
        task.resume()
    }
    
    func parseJSON(with data: Data) {
        let decoder = JSONDecoder()
        
        do {
            let weather = try decoder.decode(Weather.self, from: data)
            setupWeather(weather: weather)
            saveWeatherData(weather: weather)
            
        } catch {
            print(error)
        }
    }
    
    @objc func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func setupWeather(weather: Weather) {
        
        let city = weather.timezone.components(separatedBy: "/")
        let cityWords = city[1].components(separatedBy: "_")
        var cityCorrected = ""
        
        cityWords.forEach { (word) in
            cityCorrected += " " + word + " "
        }
        
        cityLabel.text = cityCorrected
        temperatureLabel.text = String(Int(weather.currently.temperature)) + "°"
        apparentTemperatureLabel.text = "Feels like: " + String(Int(weather.currently.apparentTemperature)) + "°"
        summaryLabel.text = weather.currently.summary
        
        ready = true
    }
    
    func saveWeatherData(weather: Weather) {
        let currentDate = getDate()
        
        weatherDataArray.append(WeatherData(date: currentDate, weather: weather))
        
        let encodedWeatherData : Data = NSKeyedArchiver.archivedData(withRootObject: weatherDataArray)
        UserDefaults.standard.set(encodedWeatherData, forKey: "SavedWeatherData")
    }
    
    func getDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hh = calendar.component(.hour, from: date)
        let mm = calendar.component(.minute, from: date)
        
        if mm < 10 {
            let currentDate = "\(day).\(month).\(year) \(hh):0\(mm)"
            return currentDate
        } else {
            let currentDate = "\(day).\(month).\(year) \(hh):\(mm)"
            return currentDate
        }
    }
    
    func loadWeather() {
        if let decodedWeatherData = UserDefaults.standard.data(forKey: "SavedWeatherData") {
            weatherDataArray = NSKeyedUnarchiver.unarchiveObject(with: decodedWeatherData) as! [WeatherData]
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            if ready {
                ready = false
                getWeatherData(coordinates: "/" + latitude + "," + longitude)
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

