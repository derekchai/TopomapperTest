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
            let coordinates = try parser.parsedGPXFile(at: fileURL)
            
            for coordinate in coordinates {
                print(
                    "Coordinate: \(coordinate.latitude), \(coordinate.longitude); elevation: \(String(describing: coordinate.elevation)) m"
                )
            }
            
            #expect(!coordinates.isEmpty)
        }
    }
    
    @Test func testDownloader() throws {
        let downloader = Downloader()
        
        do {
            try downloader
                .downloadAndSaveToFilesystem(
                    from: URL(
                        string: "https://tile.openstreetmap.org/0/0/0.png"
                    )!,
                    to: URL(string: "A")!, filename: "acb.png"
                )
        } catch {
            print(error)
        }
    }
}
