//
//  RouteDetailSheetView.swift
//  Topomapper
//
//  Created by Derek Chai on 26/06/2024.
//

import SwiftUI
import Charts

struct RouteDetailView: View {
    
    
    // MARK: - Exposed Properties
    
    var route: Route
    
    
    // MARK: - Internal Variables
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(AppState.self) private var appState
    
    @State private var loadingElevationProfile = true
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    header
                    
                    statistics
                    
                    Text("Elevation Profile")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    if loadingElevationProfile {
                        elevationProfileLoading
                    } else {
                        ElevationProfileChart(
                            route: route
                        )
                    }
                    
                    // MARK: Itinerary
                    Text("Itinerary")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                }
            }  // ScrollView
            .padding()
            .toolbarVisibility(.hidden, for: .navigationBar)
            .onAppear {
                updateSelectedRoute(to: route)
                
                loadingElevationProfile = false
            }
        }  // NavigationStack
    }  // body
    
    
    // MARK: - Components
    
    private var header: some View {
        HStack(alignment: .center) {
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
    }
    
    private var statistics: some View {
        HStack {
            Statistic(
                label: "Length",
                systemImageName: "point.topleft.down.to.point.bottomright.curvepath.fill",
                value: route.length.metres.formatted(.routeLength)
            )
            
            Divider()
            
            Statistic(
                label: "Elev. Gain",
                systemImageName: "arrow.up.forward",
                value: route.elevationGain.metres.formatted(.elevationChange)
            )
            
            Divider()
            
            Statistic(
                label: "Elev. Loss",
                systemImageName: "arrow.down.forward",
                value: route.elevationLoss.metres.formatted(.elevationChange)
            )
            
        }  // HStack
        .padding(.bottom)
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
    
    
    // MARK: - Actions
    
    private func updateSelectedRoute(to route: Route?) {
        appState.selectedRoute = nil // Slightly hacky way to center camera on feature
        appState.selectedRoute = route
    }
}


// MARK: - Preview

#Preview {
    RouteDetailView(
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
