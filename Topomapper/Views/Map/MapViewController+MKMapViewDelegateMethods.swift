//
//  MapViewController+MKMapViewDelegateMethods.swift
//  Topomapper
//
//  Created by Derek Chai on 28/06/2024.
//

import Foundation
import MapKit

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
        let identifier = "marker"
        
        var annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier
        ) as? MKMarkerAnnotationView
        
        annotationView = MKMarkerAnnotationView(
            annotation: annotation,
            reuseIdentifier: identifier
        )
        
        guard let annotationView else { return nil }
        
        annotationView.animatesWhenAdded = true
        annotationView.canShowCallout = false
        annotationView.titleVisibility = .hidden
        
        switch annotation {
        case is StartEndAnnotation:
            annotationView.markerTintColor = .systemBlue
            annotationView.glyphText = annotation.title == "Start" ? "A" : "B"
        case is SelectedMapPointAnnotation:
            annotationView.markerTintColor = .systemBlue
        default:
            return nil
        }
        
        return annotationView
    }
}
