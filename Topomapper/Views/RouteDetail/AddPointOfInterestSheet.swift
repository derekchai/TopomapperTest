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
    
    var selectedMapPoint: MKMapPoint? {
        appState.selectedMapPoint
    }
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Form {
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
                
                TextField(
                    "Point of interest name",
                    text: $pointOfInterestName,
                    prompt: Text("Point of interest name")
                )
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


// MARK: - Preview

#Preview {
    AddPointOfInterestSheet()
        .environment(AppState())
}
