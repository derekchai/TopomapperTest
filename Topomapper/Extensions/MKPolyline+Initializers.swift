//
//  MKPolyline+Initializers.swift
//  Topomapper
//
//  Created by Derek Chai on 02/07/2024.
//

import Foundation
import MapKit

extension MKPolyline {
    convenience init(from route: Route) {
        self.init(
            coordinates: route.points.map { CLLocationCoordinate2D(from: $0)},
            count: route.points.count
        )
    }
}
