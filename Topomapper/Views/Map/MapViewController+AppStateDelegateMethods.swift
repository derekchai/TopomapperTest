//
//  MapViewController+AppStateDelegateMethods.swift
//  Topomapper
//
//  Created by Derek Chai on 28/06/2024.
//

import Foundation
import MapKit
import SwiftUI

extension MapViewController: AppStateDelegate {
    func selectedRoutePointDidChange(to newRoutePoint: RoutePoint?) {
        updateSelectedMapPointAnnotation()
    }

    func selectedRouteDidChange(to newRoute: Route?) {
        updateRoutePath()
        updateStartEndAnnotations()
        updatePointOfInterestAnnotations()
        updateSelectedMapPointAnnotation()
    }
    
    func selectedDetentDidChange(to newDetent: PresentationDetent?) {
        guard let mapView = view as? MapView else { return }
        
        let mainPolyline = mapView.mkMapView.overlays.first {
            $0 is MKPolyline
        } as? MKPolyline
        
        guard let mainPolyline else { return }
        
        zoomInOnPolyline(mainPolyline)
    }
}
