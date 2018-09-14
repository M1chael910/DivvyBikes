//
//  ViewController.swift
//  DivvyBikes
//
//  Created by Michael  Murphy on 9/13/18.
//  Copyright © 2018 Michael  Murphy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var locations = ["Hello"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJsonData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        cell.textLabel?.text = String(locations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    
    
    
    func getJsonData() {
        let url = URL(string: "https://feeds.divvybikes.com/stations/stations.json")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary {
                let listOfStations = jsonData.object(forKey: "stationBeanList") as! NSArray
                self.locations.removeAll()
                for station in listOfStations {
                    let arrayElement = station as! NSDictionary
                    let stationName = arrayElement.object(forKey: "stationName") as! NSString
                    self.locations.append(stationName as String)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
        
    }
    
}

