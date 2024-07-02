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
    let points: [RoutePoint]
    
    let distances: [Double]
    let elevations: [Double]
    
    
    // MARK: - Initializers
    
    init(name: String, points: [RoutePoint]) {
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
    }
}
