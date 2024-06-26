//
//  MeasurementFormatStyles.swift
//  Topomapper
//
//  Created by Derek Chai on 25/06/2024.
//

import Foundation

struct RouteDistanceFormatStyle: FormatStyle {
    typealias FormatInput = Measurement<UnitLength>
    typealias FormatOutput = String
    
    func format(_ value: Measurement<UnitLength>) -> String {
        value.formatted(routeDistanceFormatStyle)
    }
}

extension FormatStyle where Self == RouteDistanceFormatStyle {
    /// A style for formatting the length of a route.
    static var routeLength: Self { Self() }
}

/// Style to use for a length representing a route's length.
private let routeDistanceFormatStyle = Measurement<UnitLength>.FormatStyle(
    width: .abbreviated,
    usage: .road,
    numberFormatStyle: .number.precision(.fractionLength(1...1))
)
