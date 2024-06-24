//
//  GPXPoint.swift
//  Topomapper
//
//  Created by Derek Chai on 21/06/2024.
//

import Foundation

/// A coordinate in 3-dimensional space, with a latitude, longitude, and
/// elevation (above sea level).
struct LocationCoordinate3D {
    let latitude: Double
    let longitude: Double
    let elevation: Double?
}
