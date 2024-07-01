//
//  Double+Measurement.swift
//  Topomapper
//
//  Created by Derek Chai on 25/06/2024.
//

import Foundation

extension Double {
    @available(*, deprecated, message: "Use inUnit(_:) instead.")
    var meters: Measurement<UnitLength> {
        Measurement(value: self, unit: .meters)
    }
    
    func inUnit<U: Dimension>(_ unit: U) -> Measurement<U> {
        Measurement(value: self, unit: unit)
    }
}
