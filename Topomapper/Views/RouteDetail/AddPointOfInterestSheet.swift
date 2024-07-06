//
//  AddPointOfInterestSheet.swift
//  Topomapper
//
//  Created by Derek Chai on 05/07/2024.
//

import SwiftUI
import MapKit

struct AddPointOfInterestSheet: View {
    
    
    // MARK: - Private Variables
    
    @Environment(AppState.self) private var appState
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var pointOfInterestName = ""
    
    @State private var selectedSymbol: PointOfInterestSymbol = .star
    
    var selectedRoutePoint: RoutePoint? {
        appState.selectedRoutePoint
    }
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Map {
                        if let selectedRoutePoint {
                            Marker(
                                pointOfInterestName,
                                systemImage: selectedSymbol.rawValue,
                                coordinate: CLLocationCoordinate2D(
                                    from: selectedRoutePoint
                                )
                            )
                        }
                    }
                    .frame(height: 350)
                    .listRowInsets(EdgeInsets())
                }
                
                Section {
                    TextField(
                        "Point of interest name",
                        text: $pointOfInterestName,
                        prompt: Text("Point of interest name")
                    )
                    
                    Picker("Marker icon", selection: $selectedSymbol) {
                        ForEach(PointOfInterestSymbol.allCases) { symbol in
                            Image(systemName: symbol.rawValue)
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            .navigationTitle("New Point of Interest")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: { dismiss() })
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", action: addPointOfInterest)
                        .disabled(pointOfInterestName.isEmpty)
                }
            }
        }
    }
}


// MARK: - Actions

extension AddPointOfInterestSheet {
    private func addPointOfInterest() {
        guard let selectedRoute = appState.selectedRoute, 
        let selectedRoutePoint = appState.selectedRoutePoint else {
            return
        }
        
        let pointOfInterest = PointOfInterest(
            latitude: selectedRoutePoint.latitude,
            longitdue: selectedRoutePoint.longitude,
            title: pointOfInterestName,
            glyphSystemName: selectedSymbol.rawValue,
            elevation: selectedRoutePoint.elevation,
            distanceFromStart: selectedRoutePoint.distanceFromStart
        )
        
        selectedRoute.pointsOfInterest.append(pointOfInterest)
        
        dismiss()
    }
}


// MARK: - Symbols Enumeration

extension AddPointOfInterestSheet {
    enum PointOfInterestSymbol: String, CaseIterable, Identifiable {
        case star = "star.fill"
        case pin = "mappin"
        case tent = "tent.fill"
        case warning = "exclamationmark.triangle.fill"
        case food = "fork.knife"
        case camera = "camera.fill"
        case mountain = "mountain.2.fill"
        case merge = "arrow.triangle.merge"
        case branch = "arrow.triangle.branch"
        case signpost = "signpost.right.and.left.fill"
        case house = "house.fill"
        
        var id: Self { self }
    }
}


// MARK: - Preview

#Preview {
    AddPointOfInterestSheet()
        .environment(AppState())
}
