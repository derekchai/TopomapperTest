//
//  RoutePoint+CoordinateKey.swift
//  Topomapper
//
//  Created by Derek Chai on 06/07/2024.
//

import Foundation

extension RoutePoint {
    var coordinateKey: String {
        String(format: "%.6f, %.6f",
               self.latitude,
               self.longitude
        )
    }
}
