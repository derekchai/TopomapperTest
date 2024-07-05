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
        @Bindable var appState = appState
        
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
                    
                    ForEach(route.pointsOfInterest) { point in
                        Text(point.title)
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
        .sheet(isPresented: $appState.isPresentingAddPointOfInterestSheet) {
            AddPointOfInterestSheet()
        }
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
                value: route.length.inUnit(UnitLength.meters).formatted(.routeLength)
            )
            
            Divider()
            
            Statistic(
                label: "Elev. Gain",
                systemImageName: "arrow.up.forward",
                value: route.elevationGain.inUnit(UnitLength.meters).formatted(.elevationChange)
            )
            
            Divider()
            
            Statistic(
                label: "Elev. Loss",
                systemImageName: "arrow.down.forward",
                value: route.elevationLoss.inUnit(UnitLength.meters).formatted(.elevationChange)
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
        appState.setSelectedRoute(to: route)
    }
}


// MARK: - Preview

#Preview {
    RouteDetailView(
        route: Route(
            name: "My Route",
            points: [
                RoutePoint(
                    latitude: 0,
                    longitude: 0,
                    elevation: 0,
                    distanceFromStart: 0,
                    grade: 0
                ),
                RoutePoint(
                    latitude: 1,
                    longitude: 0,
                    elevation: 10,
                    distanceFromStart: 20,
                    grade: 1
                ),
            ], pointsOfInterest: []
        )
    )
}
