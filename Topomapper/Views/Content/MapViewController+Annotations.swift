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
        guard let selectedRoute = viewModel.selectedRoute else { return }
        
        guard let firstPoint = selectedRoute.points.first else { return }
        
        let startAnnotation = StartEndAnnotation(
            coordinate: firstPoint.coordinate,
            title: "Start",
            subtitle: nil
        )
        
        guard let lastPoint = selectedRoute.points.last else { return }
        
        let endAnnotation = StartEndAnnotation(
            coordinate: lastPoint.coordinate,
            title: "End",
            subtitle: nil
        )
        
        // Remove existing StartEndAnnotations.
        for annotation in mapView.annotations {
            guard annotation is StartEndAnnotation else { continue }
            
            mapView.removeAnnotation(annotation)
        }
        
        mapView.addAnnotation(startAnnotation)
        mapView.addAnnotation(endAnnotation)
    }
}
