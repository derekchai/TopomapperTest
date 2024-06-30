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
    
    let distances: [Double]
    let elevations: [Double]
    
    
    // MARK: - Initializers
    
    init(name: String, points: [LocationCoordinate3D]) {
        self.name = name
        
        self.points = points
        
        var distancesTemporary: [Double] = [0]
        
        var elevationsTemporary: [Double] = []
        
        var totalDistance: Double = 0
        
        for i in 0..<points.count - 1 {
            totalDistance += points[i].haversineDistance(from: points[i + 1])
            
            distancesTemporary.append(totalDistance)
            
            elevationsTemporary.append(points[i].elevation)
        }
        
        elevationsTemporary.append(points.last!.elevation)
        
        self.distances = distancesTemporary
        
        self.elevations = elevationsTemporary
        
        print(
            "Points count: \(points.count); distances count: \(distances.count); elevations count: \(elevations.count)"
        )
    }
}
