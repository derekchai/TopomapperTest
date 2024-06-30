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
    
    /// The average grade from the point at `index₁` to the point at `index₂`
    /// in the Route's points array.
    /// - Returns: Average grade as a ratio (rise / run).
    func averageGrade(from index₁: Int, to index₂: Int) -> Double {
        let Δdistance = distanceTravelled(from: index₁, to: index₂)
        let Δelevation = points[index₂].elevation - points[index₁].elevation
        
        return Δelevation / Δdistance
    }
    
    func gradeBoundaries(lowerThreshold: Double = 0.2, upperThreshold: Double? = nil) -> [GradeBoundary] {
        var boundaries: [GradeBoundary] = []
        
        var start: Double?
        var end: Double?
        
        for i in 0..<self.points.count - 1 {
            guard (lowerThreshold...(upperThreshold ?? 999999)) ~= averageGrade(from: i, to: i + 1) else {
                if start != nil {
                    end = distanceTravelled(to: i)
                    
                    let boundary = GradeBoundary(startDistance: start!, endDistance: end!)
                    
                    boundaries.append(boundary)
                    
                    start = nil
                    end = nil
                    
                    continue
                }
                
                continue
            }
            
            if start == nil {
                start = distanceTravelled(to: i)
            }
        }
        
        return boundaries
    }
    
    /// Returns an array of (elevation, distance) pairs.
    ///
    /// This is an asynchronous function as this function can take a significant
    /// duration to execute depending on how many points make up the Route.
    /// - Parameter simplified: If true, returns a simplified, shorter array which
    /// does not use every single point.
    func elevationOverDistance(simplified: Bool = true) async -> [(elevation: Double, distance: Double)] {
        var elevations: [Double] = []
        
        var distances: [Double] = []
        
        var strideAmount = Int(self.points.count / 50)
        
        if strideAmount <= 0 { strideAmount = 1 }
        
        for i in stride(from: 0, to: self.points.count, by: simplified ? strideAmount : 1) {
            distances.append(distanceTravelled(to: i))
            
            elevations.append(self.points[i].elevation)
        }
        
        return Array(zip(elevations, distances))
    }
    
    /// Returns the total vertical elevation gain over the route.
    var elevationGain: Double {
        var totalElevationGain: Double = 0
        
        for i in 0..<points.count - 1 {
            let elevation1 = points[i].elevation
            let elevation2 = points[i + 1].elevation
            
            guard points[i + 1].elevation > points[i].elevation else { continue }
            
            totalElevationGain += elevation2 - elevation1
        }
        
        return totalElevationGain
    }
    
    /// Returns the total vertical elevation loss over the route.
    var elevationLoss: Double {
        var totalElevationLoss: Double = 0
        
        for i in 0..<points.count - 1 {
            let elevation1 = points[i].elevation
            let elevation2 = points[i + 1].elevation
            
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
    
    var mkPolyline: MKPolyline {
        MKPolyline(
            coordinates: points.map {
                CLLocationCoordinate2D(from: $0)
            },
            count: points.count
        )
    }
    
    struct GradeBoundary: Identifiable {
        var id: UUID

        let startDistance: Double
        let endDistance: Double
        
        init(id: UUID = UUID(), startDistance: Double, endDistance: Double) {
            self.id = id
            self.startDistance = startDistance
            self.endDistance = endDistance
        }
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
