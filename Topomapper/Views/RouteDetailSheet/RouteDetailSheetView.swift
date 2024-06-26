//
//  RouteDetailSheetView.swift
//  Topomapper
//
//  Created by Derek Chai on 26/06/2024.
//

import SwiftUI
import Charts

struct RouteDetailSheetView: View {
    
    
    // MARK: - Exposed Properties
    
    var route: Route
    
    
    // MARK: - Internal Variables
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var elevationOverDistance: [(elevation: Double, distance: Double)] = []
    
    @State private var loadingElevationProfile = true
    
    private let elevationProfileChartHeight: CGFloat = 300
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // MARK: Header
                HStack(alignment: .top) {
                    Text(route.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button("", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                    .font(.title2)
                    .foregroundStyle(.secondary)
                }
                
                // MARK: Statistics
                HStack {
                    Statistic(
                        label: "Length",
                        systemImageName: "point.topleft.down.to.point.bottomright.curvepath.fill",
                        value: route.length.metres.formatted(.routeLength)
                    )
                    
                    Divider()
                    
                    if let elevationGain = route.elevationGain, let elevationLoss = route.elevationLoss {
                        Statistic(
                            label: "Elev. Gain",
                            systemImageName: "arrow.up.forward",
                            value: elevationGain.metres.formatted(.elevationChange)
                        )
                        
                        Divider()
                        
                        Statistic(
                            label: "Elev. Loss",
                            systemImageName: "arrow.down.forward",
                            value: elevationLoss.metres.formatted(.elevationChange)
                        )
                    }
                } // HStack
                .padding(.bottom)
                
                Text("Elevation Profile")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                // MARK: Loading Elevation Profile Indicator
                if loadingElevationProfile {
                    HStack(alignment: .center) {
                        Spacer()
                        
                        ProgressView {
                            Text("Loading elevation profile...")
                        }
                        
                        Spacer()
                    }
                    .frame(height: elevationProfileChartHeight)
                    
                // MARK: Elevation Profile Chart
                } else {
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
                    }
                    .frame(height: elevationProfileChartHeight)
                    .chartXAxisLabel("m")
                    .chartYAxisLabel("m")
                    .chartXScale(domain: 0...route.length)
                }
                
                Spacer()
            }
        }
        .navigationTitle(route.name)
        .onAppear {
            Task {
                elevationOverDistance = await route
                    .getElevationOverDistance(simplified: true)
                loadingElevationProfile = false
            }
        }
    }
}


// MARK: - Preview

#Preview {
    RouteDetailSheetView(
        route: Route(
            name: "My Route",
            points: [
                LocationCoordinate3D(latitude: 0, longitude: 0, elevation: 0),
                LocationCoordinate3D(latitude: 0, longitude: 1, elevation: 10),
                LocationCoordinate3D(latitude: 0, longitude: 2, elevation: 20),
                LocationCoordinate3D(latitude: 0, longitude: 3, elevation: 30),
                LocationCoordinate3D(latitude: 0, longitude: 4, elevation: 40),
            ]
        )
    )
}
