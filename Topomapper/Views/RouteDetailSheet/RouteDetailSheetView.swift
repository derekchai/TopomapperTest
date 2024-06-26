//
//  RouteDetailSheetView.swift
//  Topomapper
//
//  Created by Derek Chai on 26/06/2024.
//

import SwiftUI

struct RouteDetailSheetView: View {
    
    
    // MARK: - Exposed Properties
    
    var route: Route
    
    
    // MARK: - Internal Variables
    
    @Environment(\.dismiss) private var dismiss
    
    
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
                
                Spacer()
            }
        }
        .navigationTitle(route.name)
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
