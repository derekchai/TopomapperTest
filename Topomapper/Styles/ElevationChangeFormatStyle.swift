//
//  ElevationChangeFormatStyle.swift
//  Topomapper
//
//  Created by Derek Chai on 26/06/2024.
//

import Foundation

struct ElevationChangeFormatStyle: FormatStyle {
    typealias FormatInput = Measurement<UnitLength>
    typealias FormatOutput = String
    
    func format(_ value: Measurement<UnitLength>) -> String {
        value.formatted(elevationChangeFormatStyle)
    }
}

extension FormatStyle where Self == ElevationChangeFormatStyle {
    /// A style for formatting cumulative elevation gain/loss for a Route.
    static var elevationChange: Self { Self() }
}

/// Style to use for a length representing an elevation gain/loss value.
private let elevationChangeFormatStyle = Measurement<UnitLength>.FormatStyle(
    width: .abbreviated,
    usage: .asProvided,
    numberFormatStyle: .number.precision(.fractionLength(0...0))
)
