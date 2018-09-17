//
//  ViewController.swift
//  DivvyBikes
//
//  Created by Michael  Murphy on 9/13/18.
//  Copyright © 2018 Michael  Murphy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {

    var locations = ["Hello"]
    var locationCoordinates: [MKPlacemark] = []
    
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.delegate = self
        getJsonData()
        setupMapView()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        cell.textLabel?.text = String(locations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    
    @IBAction func segmentedControlClicked(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tableView.isHidden = false
            mapView.isHidden = true
        case 1:
            tableView.isHidden = true
            mapView.isHidden = false
        default:
            tableView.isHidden = false
            mapView.isHidden = true
        }
    }
    
    func setupMapView() {
        self.mapView.isZoomEnabled = true
        self.mapView.showsUserLocation = true
        
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
                    let stationLatitude = arrayElement.object(forKey: "latitude") as! Double
                    let stationLongitude = arrayElement.object(forKey: "longitude") as! Double
                
                    DispatchQueue.main.async {
                        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: stationLatitude, longitude: stationLongitude))
                        self.locationCoordinates.append(placemark)

                        for placemark in self.locationCoordinates {
                            self.mapView.addAnnotation(placemark)
                            self.mapView.reloadInputViews()
                        }
                    }
                    
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

