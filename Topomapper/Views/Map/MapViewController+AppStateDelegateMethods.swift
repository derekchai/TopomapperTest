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
    func selectedMapPointDidChange(to newMapPoint: MKMapPoint?) {
        updateSelectedMapPointAnnotation()
    }

    func selectedRouteDidChange(to newRoute: Route?) {
        updateRoutePath()
        updateStartEndAnnotations()
        updatePointOfInterestAnnotations()
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
