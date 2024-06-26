//
//  Route.swift
//  Topomapper
//
//  Created by Derek Chai on 24/06/2024.
//

import Foundation
import SwiftData
import MapKit
import SwiftUI

@Model
final class Route {
    
    
    // MARK: - Properties
    
    let name: String
    let points: [LocationCoordinate3D]
    
    
    // MARK: - Initializers
    
    init(name: String, points: [LocationCoordinate3D]) {
        self.name = name
        self.points = points
    }
    
    
    // MARK: - Computed Properties
    
    var length: Double {
        var totalDistance: Double = 0
        
        for i in 0..<points.count - 1 {
            totalDistance += points[i].haversineDistance(from: points[i + 1])
        }
        
        return totalDistance
    }
    
    /// Returns the total vertical elevation gain over the route.
    var elevationGain: Double? {
        var totalElevationGain: Double = 0
        
        for i in 0..<points.count - 1 {
            guard let elevation1 = points[i].elevation, let elevation2 = points[i + 1].elevation else {
                return nil
            }
            
            guard elevation2 > elevation1 else { continue }
            
            totalElevationGain += elevation2 - elevation1
        }
        
        return totalElevationGain
    }
    
    /// Returns the total vertical elevation loss over the route.
    var elevationLoss: Double? {
        var totalElevationLoss: Double = 0
        
        for i in 0..<points.count - 1 {
            guard let elevation1 = points[i].elevation, let elevation2 = points[i + 1].elevation else {
                return nil
            }
            
            guard elevation2 < elevation1 else { continue }
            
            totalElevationLoss += abs(elevation2 - elevation1)
        }
        
        return totalElevationLoss
    }
    
    /// Returns a `MapPolyline` from the points of this route. 
    var polyline: MapPolyline {
        MapPolyline(
            coordinates: points.map { $0.coordinate },
            contourStyle: .geodesic
        )
    }
}
