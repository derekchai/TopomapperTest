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
    /// where distance is the distance of that point from the start, in metres.
    @State private var elevationDistanceArray: [(elevation: Double, distance: Double)]? = nil
    
    private var gradeBoundaries: [Route.GradeBoundary]
    
    /// Matches the `rawSelectedDistance` to the nearest actual distance in the
    /// Route.
    
    
    // MARK: - Internal Constants
    
    private let elevationProfileChartHeight: CGFloat = 300
    
    private let xAxisUnit: UnitLength = .meters
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
                
//                gradeBoundariesOverlay
                
                if selectedRoutePoint != nil {
                    selectionRuleMark
                        .annotation(
                            position: .top,
                            spacing: 0,
                            overflowResolution: .init(
                                x: .fit(to: .chart),
                                y: .disabled
                            )
                        ) {
                            selectedDistancePopover
                        }
                }
            }
            .padding(.top, 30)
            .frame(height: elevationProfileChartHeight)
            .chartXAxisLabel(xAxisUnit.symbol)
            .chartYAxisLabel(yAxisUnit.symbol)
            .chartXScale(
                domain: 0...route.length.inUnit(UnitLength.meters).converted(to: xAxisUnit).value
            )
            .chartXSelection(value: $rawSelectedDistance)
            .onChange(of: rawSelectedDistance) { oldDistance, newDistance in
                guard let newDistance else { return }
                
                selectedRoutePoint = route.points.nearestPoint(to: newDistance)
            }
            
            // elevationDistanceArray is loading.
        } else {
            elevationProfileLoading
                .task {
                    elevationDistanceArray = await route
                        .elevationOverDistanceArray(
                            elevationUnit: yAxisUnit,
                            distanceUnit: xAxisUnit
                        )
                }
        }
    }
    
    
    // MARK: - Components
    
    private var elevationProfile: some ChartContent {
        LinePlot(
            route.points,
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
    
    private var selectionRuleMark: some ChartContent {
        RuleMark(
            x:
                    .value(
                        "Selected",
                        selectedRoutePoint!.distanceFromStart
                            .inUnit(UnitLength.meters)
                            .converted(to: xAxisUnit).value
                    )
        )
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
    
    private var selectedDistancePopover: some View {
        return HStack {
            Statistic(
                label: "From start",
                systemImageName: "arrow.forward.to.line",
                value: selectedRoutePoint!.distanceFromStart
                    .inUnit(UnitLength.meters)
                    .converted(to: xAxisUnit)
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
