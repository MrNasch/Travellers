//
//  MapViewController.swift
//  Travellers
//
//  Created by Nasch on 05/08/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    fileprivate let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
}
