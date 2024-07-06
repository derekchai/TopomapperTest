//
//  CLLocationCoordinate2D+FromLocationCoordinate3D.swift
//  Topomapper
//
//  Created by Derek Chai on 01/07/2024.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    init(from routePoint: RoutePoint) {
        self.init(
            latitude: routePoint.latitude,
            longitude: routePoint
                .longitude)
    }
    
    init(from pointOfInterest: PointOfInterest) {
        self.init(
            latitude: pointOfInterest.latitude,
            longitude: pointOfInterest.longitude
        )
    }
}
