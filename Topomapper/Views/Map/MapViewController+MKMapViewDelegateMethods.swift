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
            
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
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
        guard annotation is StartEndAnnotation || annotation is SelectedMapPointAnnotation else {
            return nil
        }
        
        let identifier = "marker"
        
        var annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier
        ) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier
            )
            
            annotationView?.animatesWhenAdded = true
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(
                type: .detailDisclosure
            )
            annotationView?.markerTintColor = annotation.title == "Start" ? .green : .red
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}
