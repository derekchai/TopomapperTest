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
    var pointsOfInterest: [PointOfInterest]
    
    
    // MARK: - Initializers
    
    init(
        name: String,
        points: [RoutePoint],
        pointsOfInterest: [PointOfInterest]
    ) {
        self.name = name
        self.points = points
        self.pointsOfInterest = pointsOfInterest
    }
}
