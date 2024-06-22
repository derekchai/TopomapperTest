//
//  TopomapperTests.swift
//  TopomapperTests
//
//  Created by Derek Chai on 20/06/2024.
//

import Testing
import SwiftUI
@testable import Topomapper

struct TopomapperTests {

    @Test func testGPXParser() async throws {
        if let fileURL = Bundle.main.url(forResource: "example", withExtension: "gpx") {
            let parser = GPXParser()
            let coordinates = try parser.parseGPX(fileURL: fileURL)
            
            for coordinate in coordinates {
                print(
                    "Coordinate: \(coordinate.latitude), \(coordinate.longitude); elevation: \(String(describing: coordinate.elevation)) m"
                )
            }
            
            #expect(!coordinates.isEmpty)
        }
    }
}
