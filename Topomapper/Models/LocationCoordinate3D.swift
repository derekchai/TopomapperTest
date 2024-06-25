//
//  GPXPoint.swift
//  Topomapper
//
//  Created by Derek Chai on 21/06/2024.
//

import Foundation

/// A coordinate in 3-dimensional space, with a latitude, longitude, and
/// optional elevation (above sea level).
struct LocationCoordinate3D: Codable {
    let latitude: Double
    let longitude: Double
    
    let elevation: Double?
    
    /// Calculates the great-circle distance between two coordinates on a
    /// *spherical approximation* of the Earth.
    ///
    /// This is less accurate than other methods such as the Vincenty formula,
    /// which represents the Earth as an oblate spheroid and is thus more
    /// accurate. The haversine formula gives an uncertainty of up to 0.5%.
    /// - Returns: Distance in metres between the two coordinates.
    func haversineDistance(from point: LocationCoordinate3D) -> Double {
        let earthRadius: Double = 6_371_000 // metres
        
        let lat1: Double = self.latitude * (.pi / 180)
        let lon1: Double = self.longitude * (.pi / 180)
        
        let lat2: Double = point.latitude * (.pi / 180)
        let lon2: Double = point.longitude * (.pi / 180)
    
        let distance = 2 * earthRadius * (sqrt((1 - cos(lat2 - lat1) + cos(lat1) * cos(lat2) * (1 - cos(lon2 - lon1))) / 2))
        
        return distance
    }
}
