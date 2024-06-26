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
    
    
    // MARK: - Computed Properties and Functions
    
    var length: Double {
        var totalDistance: Double = 0
        
        for i in 0..<points.count - 1 {
            totalDistance += points[i].haversineDistance(from: points[i + 1])
        }
        
        return totalDistance
    }
    
    func distanceTravelled(from index₁: Int = 0, to index₂: Int) -> Double {
        var totalDistance: Double = 0
        
        for i in index₁..<index₂ {
            totalDistance += points[i].haversineDistance(from: points[i + 1])
        }
        
        return totalDistance
    }
    
    /// Returns an array of (elevation, distance) pairs.
    /// - Parameter simplified: If true, returns a simplified, shorter array which
    /// does not use every single point.
    func getElevationOverDistance(simplified: Bool = true) async -> [(elevation: Double, distance: Double)] {
        guard elevationGain != nil else { return [] }
        
        var elevations: [Double] = []
        
        var distances: [Double] = []
        
        var strideAmount = Int(self.points.count / 300)
        
        if strideAmount <= 0 { strideAmount = 1 }
        
        for i in stride(from: 0, to: self.points.count, by: simplified ? strideAmount : 1) {
            distances.append(distanceTravelled(to: i))
            
            elevations.append(self.points[i].elevation!)
        }
        
        return Array(zip(elevations, distances))
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

extension CLLocationCoordinate2D {
    init(from locationCoordinate3D: LocationCoordinate3D) {
        self.init(
            latitude: locationCoordinate3D.latitude,
            longitude: locationCoordinate3D
                .longitude)
    }
}
