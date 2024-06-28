//
//  MapViewController+Annotations.swift
//  Topomapper
//
//  Created by Derek Chai on 27/06/2024.
//

import Foundation
import MapKit

extension MapViewController {
    
    /// Updates the provied `MKMapView`'s `StartEndAnnotation`s to the latest
    /// information in `AppState`.
    func updateStartEndAnnotations(in mapView: MKMapView) {
        removeExistingAnnotations(
            ofType: StartEndAnnotation.self,
            from: mapView
        )
        
        if let selectedRoute = appState.selectedRoute {
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
    }
    
    func updateSelectedPointAnnotation(in mapView: MKMapView) {
        guard let selectedPoint: MKMapPoint = appState.selectedPoint else {
            return
        }
        
        removeExistingAnnotations(
            ofType: SelectedPointAnnotation.self,
            from: mapView
        )
        
        let selectedPointAnnotation = SelectedPointAnnotation(
            coordinate: selectedPoint.coordinate,
            title: nil,
            subtitle: nil
        )
        
        mapView.addAnnotation(selectedPointAnnotation)
    }
    
    /// Removes all existing annotations of the given type from the given
    /// `MKMapView`.
    /// - Parameters:
    ///   - ofType: A type which conforms to `MKAnnotation`.
    ///   - mapView: The `MKMapView` to remove the annotations from.
    private func removeExistingAnnotations<T: MKAnnotation>(
        ofType: T.Type,
        from mapView: MKMapView
    ) {
        for annotation in mapView.annotations {
            guard annotation is T else { continue }
            
            mapView.removeAnnotation(annotation)
        }
    }
}
