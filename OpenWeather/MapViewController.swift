//
//  MapViewController.swift
//  OpenWeather
//
//  Created by Mariano Molina on 10/11/15.
//  Copyright © 2015 Funka.la. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    var manager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // update location
        manager.startUpdatingLocation()
        
        if let location = locations.last {
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapa.setRegion(region, animated: true)
        }
        
        
    }
    
    
}
