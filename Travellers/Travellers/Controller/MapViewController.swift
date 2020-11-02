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
    
    var user: User?
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goButton: UIButton!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 3000
    var previousLocation: CLLocation?
    
    let geoCoder = CLGeocoder()
    var directionsArray: [MKDirections] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
    
    // create location manager
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    // center the view on the user location
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // check if location services is enable and authorized
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            alerts(title: "Oops", message: "We need your location services enable to use the map")
        }
    }
    
    // checking authorization
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUser()
        case .denied:
            // alert
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            alerts(title: "Error", message: "no permission")
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }

    //tracking userLocation
    func startTrackingUser() {
        createCamera()
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    // center location
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    // create Camera
    func createCamera() {
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        
        let mapCamera = MKMapCamera()
        mapCamera.pitch = 65
        mapCamera.altitude = 500
        mapCamera.heading = 0
        
        mapView.camera = mapCamera
    }
    
    // get direction function
    func getDirections() {
        guard let location = locationManager.location?.coordinate else {
            alerts(title: "Oops", message: "We need access to your location")
            return
        }
        
        let request = createDirectionsRequest(from: location)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        
        directions.calculate { [unowned self] (response, error) in
            if error != nil {
                self.alerts(title: "Oops", message: "Unable to get the direction")
            }
            guard let response = response else { return }
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    // create direction request from startingpoint to destination
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinationCoordinate = getCenterLocation(for: mapView).coordinate
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .any
        
        return request
    }
    
    // reset map
    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel()
        guard let index = directionsArray.firstIndex(of: $0) else { return }
        directionsArray.remove(at: index)}
    }
    
    // getDirections
    @IBAction func didTapNavigationButton(_ sender: UIButton) {
        getDirections()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    // check if authorization changed
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapViewController: MKMapViewDelegate {
    // check region changed
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.cancelGeocode()
        
        // get last location and avoid retain cycle
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            // looking for self object
            guard let self = self else { return }
            
            if let _ = error {
                // handling error that isn't an error
                print(error?.localizedDescription as Any)
                return
            }
            
            guard let placemark = placemarks?.first else {
                self.alerts(title: "Oops", message: "No previous location finded")
                return
            }
            
            // num/street/locality
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let state = placemark.subLocality ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName) \(state)"
            }
        }
    }
    
    // render map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .orange
        
        return renderer
    }
}

extension MapViewController {
    // alerts
    func alerts(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
