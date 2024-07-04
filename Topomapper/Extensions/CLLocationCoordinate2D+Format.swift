//
//  CLLocationCoordinate2D+Format.swift
//  Topomapper
//
//  Created by Derek Chai on 04/07/2024.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    func formattedString(decimalPlaces: Int = 5) -> String {
        let latitude = abs(self.latitude)
        let longitude = abs(self.longitude)
        
        let latitudeDirection = self.latitude >= 0 ? "N" : "S"
        let longitudeDirection = self.longitude >= 0 ? "E" : "W"
        
        return String(
            format: "%.\(decimalPlaces)f° %@, %.\(decimalPlaces)f° %@",
            latitude,
            latitudeDirection,
            longitude,
            longitudeDirection
        )
    }
}
