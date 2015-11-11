//
//  MapViewController.swift
//  OpenWeather
//
//  Created by Mariano Molina on 10/11/15.
//  Copyright © 2015 Funka.la. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var labelCity: UILabel!
    
    var cityCoords: CLLocationCoordinate2D?
    var cityTitle: String?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        labelCity.text = cityTitle
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: cityCoords!, span: span)
        mapa.setRegion(region, animated: true)
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
