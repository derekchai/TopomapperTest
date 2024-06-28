//
//  MapViewController+Overlays.swift
//  Topomapper
//
//  Created by Derek Chai on 27/06/2024.
//

import Foundation
import MapKit

extension MapViewController {
    func addTopo50MapOverlay(to mapView: MKMapView) {
        let overlay = MKTileOverlay(
            urlTemplate: TileServerURLTemplate.topo50
        )
        overlay.canReplaceMapContent = false
        mapView.addOverlay(overlay, level: .aboveRoads)
    }
    
    /// Removes any existing `MKPolyline` overlays and draws an `MKPolyline`
    /// overlay of the currently selected Route's path.
    func updateRoutePath(in mapView: MKMapView) {
        if let selectedRoute = appState.selectedRoute {
            let mainPolyline = MKPolyline(
                coordinates: selectedRoute.points
                    .map { CLLocationCoordinate2D.init(from: $0) },
                count: selectedRoute.points.count
            )
            
            // Remove existing MKPolyline overlays.
            for overlay in mapView.overlays {
                if overlay is MKPolyline {
                    mapView.removeOverlay(overlay)
                }
            }
            
            mapView.addOverlay(mainPolyline, level: .aboveRoads)
            
            let boundingMapRect = mainPolyline.boundingMapRect
            
            let screenSize = UIScreen.main.bounds
            
            var bottomPadding: CGFloat
            
            switch appState.selectedDetent {
            case .small:
                bottomPadding = 0.1 * screenSize.height + 50
            case .medium:
                bottomPadding = 0.5 * screenSize.height + 50
            default:
                bottomPadding = 50
            }
            
            let edgePadding = UIEdgeInsets(
                top: 50,
                left: 50,
                bottom: bottomPadding,
                right: 50
            )
            
            // Zoom in on polyline.
            mapView.setVisibleMapRect(
                boundingMapRect,
                edgePadding: edgePadding,
                animated: true
            )
        }
    }
}
