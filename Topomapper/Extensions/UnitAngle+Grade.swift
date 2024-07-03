//
//  UnitAngle+Grade.swift
//  Topomapper
//
//  Created by Derek Chai on 03/07/2024.
//

import Foundation

extension UnitAngle {
    /// An angle expressed as a percentage (rise over run).
    static let gradePercentage = UnitAngle(
        symbol: "%",
        
        // Radians to % grade.
        converter: UnitConverterGrade(coefficient: 100)
    )
    
    /// An angle expressed as a ratio (rise over run).
    static let gradeRatio = UnitAngle(
        symbol: "",
        converter: UnitConverterGrade(coefficient: 1)
    )
}
