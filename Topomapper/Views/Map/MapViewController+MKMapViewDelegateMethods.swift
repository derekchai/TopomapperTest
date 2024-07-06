//
//  MapViewController+MKMapViewDelegateMethods.swift
//  Topomapper
//
//  Created by Derek Chai on 28/06/2024.
//

import Foundation
import MapKit
import UIKit
import SwiftUI

extension MapViewController: MKMapViewDelegate {
    
    
    // MARK: - rendererFor overlay: MKOverlay
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case let tileOverlay as MKTileOverlay:
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        case let polyline as MKPolyline:
            let renderer = MKPolylineRenderer(polyline: polyline)
            
            let isMainPolyline = polyline.title == "main"
            
            renderer.strokeColor = isMainPolyline ? .systemBlue : .polylineOutline
            renderer.lineWidth = isMainPolyline ? 3 : 6
            renderer.lineCap = .round
            renderer.lineJoin = .round
            
            return renderer
        default:
            fatalError("Unexpected MKOverlay type")
        }
    }
    
    
    // MARK: - viewFor annotation: any MKAnnotation
    
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: any MKAnnotation
    ) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "marker"
        
        var annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier
        ) as? MKMarkerAnnotationView
        
        annotationView = MKMarkerAnnotationView(
            annotation: annotation,
            reuseIdentifier: identifier
        )
        
        guard let annotationView else { return nil }
        
        annotationView.isEnabled = true
        annotationView.animatesWhenAdded = true
        
        if annotation is SelectedMapPointAnnotation {
            annotationView.titleVisibility = .hidden
            let annotationButton = AnnotationButton()
            let hostingController = UIHostingController(
                rootView: annotationButton
            )
            
            hostingController.view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            hostingController.view.backgroundColor = .clear
            
            annotationView.canShowCallout = true
            annotationView.markerTintColor = .systemBlue
            annotationView.rightCalloutAccessoryView = hostingController.view
            
        } else if let annotation = annotation as? StartEndAnnotation {
            annotationView.titleVisibility = .hidden
            annotationView.canShowCallout = false
            annotationView.markerTintColor = .systemBlue
            annotationView.glyphText = annotation.title == "Start" ? "A" : "B"
            
        } else if let annotation = annotation as? PointOfInterestAnnotation {
            annotationView.canShowCallout = false
            annotationView.glyphImage = UIImage(systemName: annotation.glyphSystemName ?? "mappin")
            
        } else {
            return nil
        }
        
        return annotationView
    }
}
