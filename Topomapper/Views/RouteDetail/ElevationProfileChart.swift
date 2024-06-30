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

    
    // MARK: - Body

    var body: some View {
        Chart {
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
        }
        .frame(height: elevationProfileChartHeight)
        .chartXAxisLabel("m")
        .chartYAxisLabel("m")
        .chartXScale(domain: 0...route.length)
    }
}


// MARK: - Preview

//#Preview {
//    ElevationProfileChart()
//}
