//
//  CLLocationCoordinate2D+FromLocationCoordinate3D.swift
//  Topomapper
//
//  Created by Derek Chai on 01/07/2024.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    init(from locationCoordinate3D: RoutePoint) {
        self.init(
            latitude: locationCoordinate3D.latitude,
            longitude: locationCoordinate3D
                .longitude)
    }
}
