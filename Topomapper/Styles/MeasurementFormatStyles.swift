//
//  MeasurementFormatStyles.swift
//  Topomapper
//
//  Created by Derek Chai on 25/06/2024.
//

import Foundation

/// Style to use for a length representing a route's length.
let routeDistanceFormatStyle = Measurement<UnitLength>.FormatStyle(
    width: .abbreviated,
    usage: .road,
    numberFormatStyle: .number.precision(.fractionLength(1...1))
)

/// Style to use for a length representing an elevation gain/loss value.
let elevationChangeFormatStyle = Measurement<UnitLength>.FormatStyle(
    width: .abbreviated,
    usage: .asProvided,
    numberFormatStyle: .number.precision(.fractionLength(0...0))
)
