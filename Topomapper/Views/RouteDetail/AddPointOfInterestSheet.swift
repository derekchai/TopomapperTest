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
                    Button("Add") {}
                        .disabled(pointOfInterestName.isEmpty)
                }
            }
        }
    }
}


// MARK: - Symbols Enum

extension AddPointOfInterestSheet {
    enum PointOfInterestSymbol: String, CaseIterable, Identifiable {
        case star = "star"
        case pin = "mappin"
        case tent = "tent"
        case warning = "exclamationmark.triangle"
        case food = "fork.knife"
        case camera = "camera"
        
        var id: Self { self }
    }
}


// MARK: - Preview

#Preview {
    AddPointOfInterestSheet()
        .environment(AppState())
}
