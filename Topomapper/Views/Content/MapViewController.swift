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
        
        updateRoutePath(on: mapView)
        
        addTopo50MapOverlay(on: mapView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(context.coordinator.handleMapTap)
        )
        
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        viewController.view.addSubview(mapView)
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let mapView = uiViewController.view.subviews.first as! MKMapView
        updateRoutePath(on: mapView)
    }
    
    
    // MARK: - Internal Functions
    
    /// Adds a `UITapGestureRecognizer` onto `mapView`.
    private func addMapTapGestureRecognizer(on mapView: MKMapView) {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(MapViewController.Coordinator.handleMapTap)
        )
        
        mapView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func addTopo50MapOverlay(on mapView: MKMapView) {
        let overlay = MKTileOverlay(
            urlTemplate: MapViewController.topo50MapURLTemplate
        )
        overlay.canReplaceMapContent = false
        mapView.addOverlay(overlay, level: .aboveRoads)
    }
    
    /// Removes any existing `MKPolyline` overlays and draws an `MKPolyline`
    /// overlay of the currently selected Route's path.
    private func updateRoutePath(on mapView: MKMapView) {
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
            
            let screenSize = UIScreen.main.bounds
            
            var bottomPadding: CGFloat
            
            switch viewModel.selectedDetent {
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

