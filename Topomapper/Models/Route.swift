//
//  Route.swift
//  Topomapper
//
//  Created by Derek Chai on 24/06/2024.
//

import Foundation
import SwiftData

@Model
final class Route {
    let name: String
    let points: [LocationCoordinate3D]
    
    init(name: String, points: [LocationCoordinate3D]) {
        self.name = name
        self.points = points
    }
}
