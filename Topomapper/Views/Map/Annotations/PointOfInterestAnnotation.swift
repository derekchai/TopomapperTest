//
//  PointOfInterestAnnotation.swift
//  Topomapper
//
//  Created by Derek Chai on 05/07/2024.
//

import UIKit
import MapKit

/// An `MKAnnotation` representing a point of interest.
class PointOfInterestAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(
        coordinate: CLLocationCoordinate2D,
        title: String?,
        subtitle: String?
    ) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
