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
    
    var elevationOverDistance: [(elevation: Double, distance: Double)]
    
    var route: Route
    
    
    // MARK: - Internal Variables
    
    private let elevationProfileChartHeight: CGFloat = 300
    
    @State private var rawSelectedDistance: Double?
    
    private var selectedDistance: Double? {
        guard !elevationOverDistance.isEmpty else { return nil }
        
        guard let rawSelectedDistance else { return nil }
        
        let distances = elevationOverDistance.map { $0.distance }
        
        for i in 0..<distances.count {
            guard distances[i] < rawSelectedDistance else {
                    return distances[i]
            }
        }
        
        return distances.last!
    }

    
    // MARK: - Body

    var body: some View {
        Chart {
            // Elevation profile.
            LinePlot(
                elevationOverDistance,
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
            ForEach(
                route
                    .gradeBoundaries(
                        lowerThreshold: 0.1
                    )
            ) { boundary in
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
        .chartXAxisLabel("\(elevationOverDistance.count) points (simplified)")
        .chartYAxisLabel("m")
        .chartXScale(domain: 0...route.length)
        .chartXSelection(value: $rawSelectedDistance)
        .onChange(of: rawSelectedDistance) { oldValue, newValue in
            print("\(rawSelectedDistance ?? -1) matched to \(selectedDistance ?? -1)")
        }
//        .onAppear {
//            Task {
//                print("Getting elevationOverDistance")
//                elevationOverDistance = await appState.selectedRouteElevationOverDistance
//                print("Got!")
//            }
//        }
        
    }
}


// MARK: - Preview

//#Preview {
//    ElevationProfileChart()
//}
