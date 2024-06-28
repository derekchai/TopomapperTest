//
//  MapView.swift
//  Topomapper
//
//  Created by Derek Chai on 28/06/2024.
//

import UIKit
import MapKit

class MapView: UIView {
    
    
    // MARK: - Exposed Properties
    
    let delegate: MKMapViewDelegate
    
    let appState: AppState
    
    
    // MARK: - Internal Constants
    
    private let mapView = MKMapView()


    
    // MARK: - Initializers
    
    init(
        delegate: MKMapViewDelegate,
        appState: AppState
    ) {
        self.delegate = delegate
        
        self.appState = appState
        
        super.init(frame: .zero)
        
        mapView.delegate = delegate
        
        addSubview(mapView)
        
        mapView.frame = frame
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mapView.showsCompass = true
        mapView.showsScale = true
        
        mapView.overrideUserInterfaceStyle = .light
        
        mapView.cameraZoomRange = MKMapView
            .CameraZoomRange(minCenterCoordinateDistance: 3000)
        
        let mapTapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleMapTap)
        )
        
        mapView.addGestureRecognizer(mapTapGestureRecognizer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Exposed Functions
    
    /// Adds a `MKTileOverlay` from the LINZ Topo50 tile server to the view.
    func addTopo50Overlay() {
        let overlay = MKTileOverlay(
            urlTemplate: TileServerURLTemplate.topo50
        )
        overlay.canReplaceMapContent = false
        mapView.addOverlay(overlay, level: .aboveRoads)
    }
    
    /// Adds a `MKPolyline` to the view.
    /// - Parameter polyline: The `MKPolyline` to  be added.
    func addPolyline(_ polyline: MKPolyline) {
        mapView.addOverlay(polyline)
    }
    
    /// Zooms in on the given `MKPolyline`.
    /// - Parameters:
    ///   - polyline: The `MKPolyline` to zoom in on.
    ///   - edgePadding: The edge padding for the zoom.
    ///   - animated: If the zoom should be animated.
    func zoomInOnPolyline(
        _ polyline: MKPolyline,
        edgePadding: UIEdgeInsets? = nil,
        animated: Bool = true
    ) {
        let boundingMapRect = polyline.boundingMapRect
        
        guard let edgePadding else {
            mapView.setVisibleMapRect(boundingMapRect, animated: animated)
            return
        }
        
        mapView
            .setVisibleMapRect(
                boundingMapRect,
                edgePadding: edgePadding,
                animated: animated
            )
    }
    
    /// Removes all existing `MKPolyline` overlays from the view.
    func removeAllExistingPolylines() {
        for overlay in mapView.overlays where overlay is MKPolyline {
            mapView.removeOverlay(overlay)
        }
    }
    
    /// Removes all existing annotations of the given type (which conforms to
    /// the `MKAnnotation` protocol) from the view.
    /// - Parameter type: The type of `MKAnnotation` to be removed.
    func removeAllExistingAnnotations<T: MKAnnotation>(ofType type: T.Type? = nil) {
        for annotation in mapView.annotations where annotation is T {
            mapView.removeAnnotation(annotation)
        }
    }
    
    /// Adds the given `MKAnnotation` to the view.
    func addAnnotation(_ annotation: MKAnnotation) {
        mapView.addAnnotation(annotation)
    }
    
    
    // MARK: - Private Functions
    
    @objc private func handleMapTap(_ sender: UITapGestureRecognizer) {
        guard sender.state == .recognized else { return }
        
        guard let mapView = sender.view as? MKMapView else { return }
        
        let tappedPoint: CGPoint = sender.location(in: mapView)
        let tappedCoordinate: CLLocationCoordinate2D = mapView.convert(
            tappedPoint,
            toCoordinateFrom: mapView
        )
        let tappedMapPoint: MKMapPoint = MKMapPoint(tappedCoordinate)
        
        let maximumMetersFromPoint: Double = mapView.distance(
            from: tappedPoint,
            byPixelsHorizontallyAcross: 22
        )
        
        var closestPointToTap: MKMapPoint?
        
        for overlay in mapView.overlays {
            guard overlay is MKPolyline else { continue }
            
            let polyline = overlay as! MKPolyline
            
            closestPointToTap = polyline.closestPointInPolyline(to: tappedMapPoint)
        }
        
        guard let closestPointToTap else { return }
        
        let distanceAway = closestPointToTap.distance(to: tappedMapPoint)
        
        if distanceAway <= maximumMetersFromPoint {
            print(
                "Closest point tapped: \(String(describing: closestPointToTap)) (\(distanceAway) m away)."
            )
            appState.selectedMapPoint = closestPointToTap
        }
    }
    
}
