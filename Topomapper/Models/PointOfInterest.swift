//
//  PointOfInterest.swift
//  Topomapper
//
//  Created by Derek Chai on 05/07/2024.
//

import Foundation
import UIKit

/// A point of interest on a map.
struct PointOfInterest: Codable {
    let latitude: Double
    let longitdue: Double
    
    /// The title of the point of interest.
    let title: String
    
    /// The system name of the glyph displayed within the point of interest's
    /// marker map annotation.
    let glyphSystemName: String
}
