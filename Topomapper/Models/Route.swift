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
    let pointsOfInterest: [RoutePoint]
    
    
    // MARK: - Initializers
    
    init(name: String, points: [RoutePoint], pointsOfInterest: [RoutePoint]) {
        self.name = name
        self.points = points
        self.pointsOfInterest = pointsOfInterest
    }
}
