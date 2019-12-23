//
//  DataBaseTableViewController.swift
//  Test Task
//
//  Created by Ilya Sokolov on 22.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class DataBaseTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DataBaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DataBaseCell") as! DataBaseTableViewCell
        
        cell.cityLabel.text = weatherDataArray.reversed()[indexPath.row].weather.timezone
        cell.dateLabel.text = "Date: " + weatherDataArray.reversed()[indexPath.row].date
        cell.degreesLabel.text = "Degrees: " + String(Int(weatherDataArray.reversed()[indexPath.row].weather.currently.temperature))
        cell.feelsLikeLabel.text = "Feels Like: " + String(Int(weatherDataArray.reversed()[indexPath.row].weather.currently.apparentTemperature))
        cell.summaryLabel.text = "Summary: " + weatherDataArray.reversed()[indexPath.row].weather.currently.summary
        cell.windSpeedLabel.text = "Wind Speed: " + String(Int(weatherDataArray.reversed()[indexPath.row].weather.currently.windSpeed))
        cell.precipTypeLabel.text = "Precip Type: " + (weatherDataArray.reversed()[indexPath.row].weather.currently.precipType ?? "no precipitation")
        
        return cell
    }
    
}
