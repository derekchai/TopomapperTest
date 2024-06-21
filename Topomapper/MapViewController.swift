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
    /// OpenStreetMap XYZ tile server URL template.
    private static let openStreetMapURLTemplate = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
    
    /// Land Information New Zealand (LINZ) Topo50 tile server URL template.
    private static let topo50MapURLTemplate = "https://tiles-cdn.koordinates.com/services;key=\(Key.topo50APIKey)/tiles/v4/layer=52343/EPSG:3857/{z}/{x}/{y}.png"
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewController
        
        init(parent: MapViewController) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let mapView = MKMapView()
        
        mapView.delegate = context.coordinator
        mapView.frame = viewController.view.frame
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mapView.showsCompass = true
        mapView.showsScale = true
        
        let overlay = MKTileOverlay(
            urlTemplate: MapViewController.topo50MapURLTemplate
        )
        overlay.canReplaceMapContent = false
        mapView.addOverlay(overlay, level: .aboveLabels)
        
        viewController.view.addSubview(mapView)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

extension MapViewController.Coordinator {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        }
        return MKOverlayRenderer()
    }
}
