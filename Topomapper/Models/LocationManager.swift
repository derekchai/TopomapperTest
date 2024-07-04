//
//  LocationManager.swift
//  Topomapper
//
//  Created by Derek Chai on 04/07/2024.
//

import Foundation
import CoreLocation
import OSLog

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let log = Logger()
    
    private let locationManager = CLLocationManager()
    private var updatingLocation = false
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            log.info("Location authorized when in use.")
        case .notDetermined:
            log.info("Requesting location when in use authorization.")
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            log.error("Location authorization denied or restricted.")
            break
        default:
            break
        }
    }
    
    func startUpdatingLocation() {
        guard !updatingLocation else {
            log.notice("Attempted to start updating location but location is already being updated.")
            return
        }
        
        guard locationManager.authorizationStatus == .authorizedWhenInUse else {
            requestAuthorization()
            startUpdatingLocation()
            return
        }
        
        log.info("Starting updating location.")
        
        locationManager.startUpdatingLocation()
        updatingLocation = true
    }
    
    func stopUpdatingLocation() {
        guard updatingLocation else {
            log.notice("Attempted to stop updating location but location is not being updated.")
            return
        }
        
        log.info("Stopping updating location.")
        
        locationManager.stopUpdatingLocation()
        updatingLocation = false
    }
}

extension LocationManager {
    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestAuthorization()
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastCLLocation = locations.last else { return }
        
        log.debug("Last location: \(lastCLLocation.coordinate.latitude), \(lastCLLocation.coordinate.longitude)")
        
        guard updatingLocation else { return }
    }
}
