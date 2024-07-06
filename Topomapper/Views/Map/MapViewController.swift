//
//  MapViewController.swift
//  Topomapper
//
//  Created by Derek Chai on 28/06/2024.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
    // MARK: - Exposed Properties
    
    var appState: AppState
    
    
    // MARK: - Private Properties
    
    let locationManager = CLLocationManager()
    
    
    // MARK: - Initializers
    
    init(appState: AppState) {
        self.appState = appState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appState.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
    }
    
    override func loadView() {
        view = MapView(
            delegate: self,
            appState: appState
        )
        
        addTopo50Overlay()
    }
    
    
    // MARK: - Helper Functions
    
    /// Adds the LINZ Topo50 tile overlay to the map.
    func addTopo50Overlay() {
        guard let mapView = view as? MapView else { return }
        
        mapView.addTopo50Overlay()
    }
    
    /// Updates the route polyline shown on the map to be that of the selected
    /// route.
    func updateRoutePath() {
        guard let mapView = view as? MapView else { return }
        guard let selectedRoute = appState.selectedRoute else {
            mapView.removeAllExistingPolylines()
            return
        }
        
        mapView.removeAllExistingPolylines()
        
        let mainPolyline = MKPolyline(from: selectedRoute)
        mainPolyline.title = "main"
        
        let outlinePolyline = MKPolyline(from: selectedRoute)
        
        mapView.addPolyline(outlinePolyline)
        mapView.addPolyline(mainPolyline)
        
        guard view.window?.windowScene?.screen.bounds != nil else {
            return
        }
        
        zoomInOnPolyline(mainPolyline)
    }
    
    func zoomInOnPolyline(_ polyline: MKPolyline) {
        guard let mapView = view as? MapView else { return }

        guard let screenBounds = view.window?.windowScene?.screen.bounds else {
            return
        }
        
        mapView
            .zoomInOnPolyline(polyline,
                edgeInsets: .notBlockedBySheet(
                    screenHeight: screenBounds.height,
                    detent: appState.selectedDetent
                )
            )
    }
    
    /// Updates the start and end annotations shown on the map to be that of
    /// the selected route.
    func updateStartEndAnnotations() {
        guard let mapView = view as? MapView else { return }
        guard let selectedRoute = appState.selectedRoute else {
            mapView.removeAllExistingAnnotations(ofType: StartEndAnnotation.self)
            return
        }
        guard let firstPoint = selectedRoute.points.first, let lastPoint = selectedRoute.points.last else { return }
        
        let startAnnotation = StartEndAnnotation(
            coordinate: CLLocationCoordinate2D(from: firstPoint),
            title: "Start",
            subtitle: nil
        )
        
        let endAnnotation = StartEndAnnotation(
            coordinate: CLLocationCoordinate2D(from: lastPoint),
            title: "End",
            subtitle: nil
        )
        
        mapView.removeAllExistingAnnotations(ofType: StartEndAnnotation.self)
        
        mapView.addAnnotation(startAnnotation)
        mapView.addAnnotation(endAnnotation)
    }
    
    /// Updates the `SelectedMapPointAnnotation` shown on the map to be that
    /// of the selected map point.
    func updateSelectedMapPointAnnotation() {
        guard let mapView = view as? MapView else { return }
        guard let selectedRoutePoint = appState.selectedRoutePoint else { return }
        
        guard appState.selectedRoute != nil else {
            mapView.removeAllExistingAnnotations(ofType: SelectedMapPointAnnotation.self)
            return
        }
        
        let coordinate = CLLocationCoordinate2D(from: selectedRoutePoint)
        
        let selectedMapPointAnnotation = SelectedMapPointAnnotation(
            coordinate: coordinate,
            title: "Selected point",
            subtitle: coordinate.formattedString()
        )
        
        mapView.removeAllExistingAnnotations(
            ofType: SelectedMapPointAnnotation.self
        )
        
        mapView.addAnnotation(selectedMapPointAnnotation)
        mapView.mkMapView
            .selectAnnotation(selectedMapPointAnnotation, animated: true)
    }
    
    func updatePointOfInterestAnnotations() {
        guard let mapView = view as? MapView else { return }
        guard let selectedRoute = appState.selectedRoute else {
            mapView.removeAllExistingAnnotations(ofType: PointOfInterestAnnotation.self)
            return
        }
        
        mapView.removeAllExistingAnnotations(ofType: PointOfInterestAnnotation.self)
        
        for pointOfInterest in selectedRoute.pointsOfInterest {
            let annotation = PointOfInterestAnnotation(
                coordinate: CLLocationCoordinate2D(
                    latitude: pointOfInterest.latitude,
                    longitude: pointOfInterest.longitude
                ),
                title: pointOfInterest.title,
                subtitle: nil,
                glyphSystemName: pointOfInterest.glyphSystemName
            )
            
            mapView.addAnnotation(annotation)
        }
    }
}
