//
//  StartEndAnnotation.swift
//  Topomapper
//
//  Created by Derek Chai on 27/06/2024.
//

import Foundation
import MapKit

class StartEndAnnotation: NSObject, MKAnnotation {
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
