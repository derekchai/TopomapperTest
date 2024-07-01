//
//  ElevationProfileChart.swift
//  Topomapper
//
//  Created by Derek Chai on 26/06/2024.
//

import SwiftUI
import Charts

struct ElevationProfileChart: View {
    
    
    // MARK: - Exposed Properties
    
    /// The route to draw the elevation profile for.
    var route: Route
    
    
    // MARK: - Internal Variables
    
    @State private var rawSelectedDistance: Double?
    
    /// An array of `(elevation, distance)` pairs for each point in the Route
    /// where distance is the distance of that point from the start, in metres.
    private var elevationDistanceArray: [(elevation: Double, distance: Double)]
    
    private var gradeBoundaries: [Route.GradeBoundary]

    private var selectedDistance: Double? {
        guard !elevationDistanceArray.isEmpty else { return nil }
        
        guard let rawSelectedDistance else { return nil }
        
        let distances = elevationDistanceArray.map { $0.distance }
        
        for i in 0..<distances.count {
            guard distances[i] < rawSelectedDistance else {
                    return distances[i]
            }
        }
        
        return distances.last!
    }
    
    
    // MARK: - Internal Constants
    
    private let elevationProfileChartHeight: CGFloat = 300
    
    
    // MARK: - Initializer
    
    init(route: Route) {
        self.route = route
        
        elevationDistanceArray = route.elevationOverDistance()
        gradeBoundaries = route.gradeBoundaries(lowerThreshold: 0.1)
    }

    
    // MARK: - Body
    var body: some View {
        Chart {
            // Elevation profile.
            LinePlot(
                elevationDistanceArray,
                x: .value("Distance", \.distance),
                y: .value("Elevation", \.elevation)
            )
            .lineStyle(
                StrokeStyle(
                    lineWidth: 3,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .opacity(0.8)
            
            // Significant grade boundaries.
            ForEach(gradeBoundaries) { boundary in
                RectangleMark(
                    xStart: .value("", boundary.startDistance),
                    xEnd: .value("", boundary.endDistance)
                )
                .foregroundStyle(.red)
                .opacity(0.2)
            }
            
            if let selectedDistance {
                RuleMark(x: .value("Selected", selectedDistance))
                    .foregroundStyle(.gray.opacity(0.3))
                    .offset(yStart: -10)
                    .zIndex(-1)
            }
        }
        .frame(height: elevationProfileChartHeight)
        .chartXAxisLabel("\(elevationDistanceArray.count) points (simplified)")
        .chartYAxisLabel("m")
        .chartXScale(domain: 0...route.length)
        .chartXSelection(value: $rawSelectedDistance)
    }
}


// MARK: - Preview

//#Preview {
//    ElevationProfileChart()
//}
