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
    @State private var elevationDistanceArray: [(elevation: Double, distance: Double)]? = nil
    
    private var gradeBoundaries: [Route.GradeBoundary]
    
    /// Matches the `rawSelectedDistance` to the nearest actual distance in the
    /// Route.
    private var selectedDistance: Double? {
        guard let elevationDistanceArray else { return nil }
        
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
    
    private let xAxisUnit: UnitLength = .kilometers
    private let yAxisUnit: UnitLength = .meters
    
    // MARK: - Initializer
    
    init(route: Route) {
        self.route = route
        
        gradeBoundaries = route.gradeBoundaries(lowerThreshold: 0.1)
    }
    
    
    // MARK: - Body
    
    var body: some View {
        // elevationDistanceArray has loaded.
        if elevationDistanceArray != nil {
            Chart {
                elevationProfile
                
                gradeBoundariesOverlay
                
                if selectedDistance != nil {
                    selectionRuleMark
                }
            }
            .frame(height: elevationProfileChartHeight)
            .chartXAxisLabel(xAxisUnit.symbol)
            .chartYAxisLabel(yAxisUnit.symbol)
            .chartXScale(
                domain: 0...route.length.meters.converted(to: xAxisUnit).value
            )
            .chartXSelection(value: $rawSelectedDistance)
            
            // elevationDistanceArray is loading.
        } else {
            elevationProfileLoading
                .onAppear {
                    Task {
                        elevationDistanceArray = await route
                            .elevationOverDistance(
                                elevationUnit: yAxisUnit,
                                distanceUnit: xAxisUnit
                            )
                    }
                }
        }
    }
    
    
    // MARK: - Components
    
    private var elevationProfile: some ChartContent {
        LinePlot(
            elevationDistanceArray!,
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
    }
    
    private var gradeBoundariesOverlay: some ChartContent {
        ForEach(gradeBoundaries) { boundary in
            RectangleMark(
                xStart:
                        .value(
                            "",
                            boundary.startDistance.meters
                                .converted(to: xAxisUnit).value
                        ),
                xEnd:
                        .value(
                            "",
                            boundary.endDistance.meters
                                .converted(to: xAxisUnit).value
                        )
            )
            .foregroundStyle(.red)
            .opacity(0.2)
        }
    }
    
    private var selectionRuleMark: some ChartContent {
        RuleMark(x: .value("Selected", selectedDistance!))
            .foregroundStyle(.gray.opacity(0.3))
            .offset(yStart: -10)
            .zIndex(-1)
    }
    
    private var elevationProfileLoading: some View {
        HStack(alignment: .center) {
            Spacer()
            
            ProgressView {
                Text("Loading elevation profile...")
            }
            
            Spacer()
        }
        .frame(height: 300)
    }
}


// MARK: - Preview

//#Preview {
//    ElevationProfileChart()
//}
