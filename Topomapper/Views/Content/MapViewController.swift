//
//  MainMap.swift
//  Topomapper
//
//  Created by Derek Chai on 20/06/2024.
//

import Foundation
import SwiftUI
import MapKit

struct MapViewController: UIViewControllerRepresentable {
    
    
    // MARK: - Exposed Properties
    
    var viewModel: ViewModel
    
    
    // MARK: - Internal Constants
    
    /// OpenStreetMap XYZ tile server URL template.
    private static let openStreetMapURLTemplate = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
    
    /// Land Information New Zealand (LINZ) Topo50 tile server URL template.
    private static let topo50MapURLTemplate = "https://tiles-cdn.koordinates.com/services;key=\(Key.topo50APIKey)/tiles/v4/layer=52343/EPSG:3857/{z}/{x}/{y}.png"
    
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewController
        
        init(parent: MapViewController) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    
    // MARK: - UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let mapView = MKMapView()
        
        mapView.delegate = context.coordinator
        mapView.frame = viewController.view.frame
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mapView.showsCompass = true
        mapView.showsScale = true
        
        mapView.overrideUserInterfaceStyle = .light
        
        updateRoutePath(mapView: mapView)
        
        let overlay = MKTileOverlay(
            urlTemplate: MapViewController.topo50MapURLTemplate
        )
        overlay.canReplaceMapContent = false
        mapView.addOverlay(overlay, level: .aboveRoads)
        
        
        viewController.view.addSubview(mapView)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        updateRoutePath(mapView: uiViewController.view.subviews.first as! MKMapView)
    }
    
    
    // MARK: - Internal Functions
    
    /// Removes any existing `MKPolyline` overlays and draws an `MKPolyline`
    /// overlay of the currently selected Route's path.
    private func updateRoutePath(mapView: MKMapView) {
        if let selectedRoute = viewModel.selectedRoute {
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
            
            let edgePadding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            
            // Zoom in on polyline.
            mapView.setVisibleMapRect(
                boundingMapRect,
                edgePadding: edgePadding,
                animated: true
            )
        }
    }
}


// MARK: - Delegate Methods

extension MapViewController.Coordinator {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case let tileOverlay as MKTileOverlay:
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        case let polyline as MKPolyline:
            let renderer = MKPolylineRenderer(polyline: polyline)
            
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            renderer.lineCap = .round
            renderer.lineJoin = .round
            
            return renderer
        default:
            fatalError("Unexpected MKOverlay type")
        }
    }
}
