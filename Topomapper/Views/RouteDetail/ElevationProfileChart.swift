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
    
    @State private var selectedRoutePoint: RoutePoint?
    
    /// An array of `(elevation, distance)` pairs for each point in the Route
    /// where distance is the distance of that point from the start, in the local unit.
    @State private var chartData: [RoutePoint]? = nil
    
    private var gradeBoundaries: [Route.GradeBoundary]
    
    private var maximumYValue: Double {
        guard let chartData else { return 0 }
        
        return chartData.max(by: { $0.elevation < $1.elevation })!.elevation
    }
    
    
    // MARK: - Internal Constants
    
    private let elevationProfileChartHeight: CGFloat = 240
    
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
        if chartData != nil {
            Chart {
                elevationProfile
                
                gradeBoundariesOverlay
                
                pointsOfInterestOverlay
                
                if selectedRoutePoint != nil {
                    selectionRuleMark
                        .annotation(
                            position: .top,
                            spacing: 15,
                            overflowResolution: .init(
                                x: .fit(to: .chart),
                                y: .disabled
                            )
                        ) { selectedDistancePopover }
                }
            }
            .padding(.top, 45)
            .frame(height: elevationProfileChartHeight)
            .chartXAxisLabel(xAxisUnit.symbol)
            .chartYAxisLabel(yAxisUnit.symbol)
            .chartXScale(
                domain: 0...route.length.inUnit(UnitLength.meters).converted(to: xAxisUnit).value
            )
            .chartXSelection(value: $rawSelectedDistance)
            .onChange(of: rawSelectedDistance) { oldDistance, newDistance in
                guard let newDistance else { return }
                
                selectedRoutePoint = chartData!.nearestPoint(to: newDistance)
            }
            
            if let chartData {
                Text(
                    "Simplified to \(chartData.count) points from \(route.points.count)."
                )
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            // elevationDistanceArray is loading.
        } else {
            elevationProfileLoading
                .task {
                    chartData = await route
                        .elevationProfileData(
                            elevationUnit: yAxisUnit,
                            distanceUnit: xAxisUnit
                        )
                    
                    selectedRoutePoint = chartData?.first
                }
        }
    }
    
    
    // MARK: - Components
    
    private var elevationProfile: some ChartContent {
        LinePlot(
            chartData!,
            x: .value("Distance", \.distanceFromStart),
            y: .value("Elevation", \.elevation)
        )
        .lineStyle(
            StrokeStyle(
                lineWidth: 2,
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
                            boundary.startDistance.inUnit(UnitLength.meters)
                                .converted(to: xAxisUnit).value
                        ),
                xEnd:
                        .value(
                            "",
                            boundary.endDistance.inUnit(UnitLength.meters)
                                .converted(to: xAxisUnit).value
                        )
            )
            .foregroundStyle(.red)
            .opacity(0.2)
        }
    }
    
    private var pointsOfInterestOverlay: some ChartContent {
        ForEach(route.pointsOfInterest) { point in
            RuleMark(
                x:
                        .value(
                            "Distance from start",
                            point.distanceFromStart
                                .inUnit(UnitLength.meters)
                                .converted(to: xAxisUnit).value
                        )
            )
            .foregroundStyle(.gray.opacity(0.3))
            .offset(yStart: -5)
            .zIndex(-1)
            .annotation(position: .top) {
                Image(systemName: point.glyphSystemName)
                    .foregroundStyle(Color.gray.opacity(0.5))
                    .font(.system(size: 11))
            }
        }
    }
    
    private var selectionRuleMark: some ChartContent {
        RuleMark(
            x: .value("Selected", selectedRoutePoint!.distanceFromStart)
        )
            .foregroundStyle(.gray.opacity(0.6))
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
    
    private var selectedDistancePopover: some View {
        return HStack {
            Statistic(
                label: "From start",
                systemImageName: "arrow.forward.to.line",
                value: selectedRoutePoint!.distanceFromStart
                    .inUnit(xAxisUnit)
                    .formatted(.routeLength)
            )
            
            Divider()

            Statistic(
                label: "Altitude",
                systemImageName: "arrowtriangle.up",
                value: selectedRoutePoint!.elevation
                    .inUnit(yAxisUnit)
                    .formatted(.elevationChange)
            )

            Divider()
            
            Statistic(
                label: "Grade",
                systemImageName: "angle",
                value: selectedRoutePoint!.grade
                    .inUnit(UnitAngle.gradeRatio)
                    .converted(to: UnitAngle.gradePercentage)
                    .formatted(.gradePercentage)
            )
        }
    }
}


// MARK: - Preview

//#Preview {
//    ElevationProfileChart()
//}
