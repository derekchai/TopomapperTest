//
//  UnitConverterGrade.swift
//  Topomapper
//
//  Created by Derek Chai on 03/07/2024.
//

import Foundation

class UnitConverterGrade: UnitConverter {
    var coefficient: Double = 1
    
    init(coefficient: Double) {
        self.coefficient = coefficient
    }
    
    // Grade (ratio) to degrees.
    override func baseUnitValue(fromValue value: Double) -> Double {
        atan(value / coefficient) / (.pi / 180)
    }
    
    // Degrees to grade (ratio).
    override func value(fromBaseUnitValue baseUnitValue: Double) -> Double {
        tan(baseUnitValue * .pi / 180) * coefficient
    }
}
