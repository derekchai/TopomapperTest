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
    
    var selectedMapPoint: MKMapPoint? {
        appState.selectedMapPoint
    }
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Map {
                        if let selectedMapPoint {
                            Marker(
                                pointOfInterestName,
                                systemImage: selectedSymbol.rawValue,
                                coordinate: selectedMapPoint.coordinate
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
        let selectedMapPoint = appState.selectedMapPoint else {
            return
        }
        
        let pointOfInterest = PointOfInterest(
            latitude: selectedMapPoint.coordinate.latitude,
            longitdue: selectedMapPoint.coordinate.longitude,
            title: pointOfInterestName,
            glyphSystemName: selectedSymbol.rawValue
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
        
        var id: Self { self }
    }
}


// MARK: - Preview

#Preview {
    AddPointOfInterestSheet()
        .environment(AppState())
}
