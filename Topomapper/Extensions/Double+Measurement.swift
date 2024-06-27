//
//  Double+Measurement.swift
//  Topomapper
//
//  Created by Derek Chai on 25/06/2024.
//

import Foundation

extension Double {
    var metres: Measurement<UnitLength> {
        Measurement(value: self, unit: .meters)
    }
}
