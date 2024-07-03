//
//  GradePercentageFormatStyle.swift
//  Topomapper
//
//  Created by Derek Chai on 03/07/2024.
//

import Foundation

struct GradePercentageFormatStyle: FormatStyle {
    func format(_ value: Measurement<UnitAngle>) -> String {
        value.formatted(gradePercentageFormatStyle)
    }
}

extension FormatStyle where Self == GradePercentageFormatStyle {
    /// A style for formatting an angle as a percentage grade.
    static var gradePercentage: Self { Self() }
}

private let gradePercentageFormatStyle = Measurement<UnitAngle>.FormatStyle(
    width: .narrow,
    usage: .asProvided,
    numberFormatStyle: .number.precision(.fractionLength(0...0))
)
