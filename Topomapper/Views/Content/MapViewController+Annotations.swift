//
//  MapViewController+Annotations.swift
//  Topomapper
//
//  Created by Derek Chai on 27/06/2024.
//

import Foundation
import MapKit

extension MapViewController {
    func updateAnnotations(in mapView: MKMapView) {
        
        // Remove existing StartEndAnnotations.
        for annotation in mapView.annotations {
            guard annotation is StartEndAnnotation else { continue }
            
            mapView.removeAnnotation(annotation)
        }
        
        if let selectedRoute = viewModel.selectedRoute {
            if let firstPoint = selectedRoute.points.first {
                let startAnnotation = StartEndAnnotation(
                    coordinate: firstPoint.coordinate,
                    title: "Start",
                    subtitle: nil
                )
                
                mapView.addAnnotation(startAnnotation)
            }
            
            if let lastPoint = selectedRoute.points.last {
                let endAnnotation = StartEndAnnotation(
                    coordinate: lastPoint.coordinate,
                    title: "End",
                    subtitle: nil
                )
                
                mapView.addAnnotation(endAnnotation)
            }
        }
        
        if let selectedPoint = viewModel.selectedPoint {
            let selectedPointAnnotation = StartEndAnnotation(
                coordinate: selectedPoint.coordinate,
                title: nil,
                subtitle: nil
            )
            
            mapView.addAnnotation(selectedPointAnnotation)
        }
    }
}
