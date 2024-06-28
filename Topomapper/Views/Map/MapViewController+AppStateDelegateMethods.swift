//
//  MapViewController+AppStateDelegateMethods.swift
//  Topomapper
//
//  Created by Derek Chai on 28/06/2024.
//

import Foundation
import MapKit

extension MapViewController: AppStateDelegate {
    func selectedMapPointDidChange(to newMapPoint: MKMapPoint?) {
        updateSelectedMapPointAnnotation()
    }

    func selectedRouteDidChange(to newRoute: Route?) {
        updateRoutePath()
        updateStartEndAnnotations()
    }
}
