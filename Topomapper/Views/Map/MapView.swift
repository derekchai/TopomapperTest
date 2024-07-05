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
    
    let mkMapView = MKMapView()

    
    // MARK: - Initializers
    
    init(
        delegate: MKMapViewDelegate,
        appState: AppState
    ) {
        self.delegate = delegate
        
        self.appState = appState
        
        super.init(frame: .zero)
        
        mkMapView.delegate = delegate
        
        addSubview(mkMapView)
        
        mkMapView.frame = frame
        mkMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mkMapView.showsCompass = true
        mkMapView.showsScale = true
        mkMapView.showsUserLocation = true
        mkMapView.showsUserTrackingButton = true
        
        mkMapView.overrideUserInterfaceStyle = .light
        
        mkMapView.cameraZoomRange = MKMapView
            .CameraZoomRange(minCenterCoordinateDistance: 3000)
        
        let mapTapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleMapTap)
        )
        
        mkMapView.addGestureRecognizer(mapTapGestureRecognizer)
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
        mkMapView.addOverlay(overlay, level: .aboveRoads)
    }
    
    /// Adds a `MKPolyline` to the view.
    /// - Parameter polyline: The `MKPolyline` to  be added.
    func addPolyline(_ polyline: MKPolyline) {
        mkMapView.addOverlay(polyline)
    }
    
    /// Zooms in on the given `MKPolyline`.
    /// - Parameters:
    ///   - polyline: The `MKPolyline` to zoom in on.
    ///   - edgePadding: The edge padding for the zoom.
    ///   - animated: If the zoom should be animated.
    func zoomInOnPolyline(
        _ polyline: MKPolyline,
        edgeInsets: UIEdgeInsets? = UIEdgeInsets(
            top: 20,
            left: 20,
            bottom: 20,
            right: 20
        ),
        animated: Bool = true
    ) {
        let boundingMapRect = polyline.boundingMapRect
        
        guard let edgeInsets else {
            mkMapView.setVisibleMapRect(boundingMapRect, animated: animated)
            return
        }
        
        mkMapView
            .setVisibleMapRect(
                boundingMapRect,
                edgePadding: edgeInsets,
                animated: animated
            )
    }
    
    /// Removes all existing `MKPolyline` overlays from the view.
    func removeAllExistingPolylines() {
        for overlay in mkMapView.overlays where overlay is MKPolyline {
            mkMapView.removeOverlay(overlay)
        }
    }
    
    /// Removes all existing annotations of the given type (which conforms to
    /// the `MKAnnotation` protocol) from the view.
    /// - Parameter type: The type of `MKAnnotation` to be removed.
    func removeAllExistingAnnotations<T: MKAnnotation>(ofType type: T.Type? = nil) {
        for annotation in mkMapView.annotations where annotation is T {
            mkMapView.removeAnnotation(annotation)
        }
    }
    
    /// Adds the given `MKAnnotation` to the view.
    func addAnnotation(_ annotation: MKAnnotation) {
        mkMapView.addAnnotation(annotation)
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
        
        for overlay in mapView.overlays where overlay is MKPolyline {
            let polyline = overlay as! MKPolyline
            
            closestPointToTap = polyline.closestPointInPolyline(to: tappedMapPoint)
        }
        
        guard let closestPointToTap else { return }
        
        let distanceAway = closestPointToTap.distance(to: tappedMapPoint)
        
        if distanceAway <= maximumMetersFromPoint {
            appState.setSelectedMapPoint(to: closestPointToTap)
        }
    }
}
