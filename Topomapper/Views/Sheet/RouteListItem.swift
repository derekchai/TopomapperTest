//
//  RouteListItem.swift
//  Topomapper
//
//  Created by Derek Chai on 25/06/2024.
//

import SwiftUI

struct RouteListItem: View {
    
    
    // MARK: - Exposed Properties
    
    var route: Route
    
    var onItemTapGesture: () -> Void = {}
    
    
    // MARK: - Body
    
    var body: some View {
        Button {
            onItemTapGesture()
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(route.name)
                        .font(.headline)
                    
                    Text(
                        "\(route.distance.metres.formatted(routeDistanceFormatStyle))"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if let elevationGain = route.elevationGain, let elevationLoss = route.elevationLoss {
                    VStack {
                        Label(
                            "\(elevationGain.metres.formatted(elevationChangeFormatStyle))",
                            systemImage: "arrow.up.right"
                        )
                        
                        Label(
                            "\(elevationLoss.metres.formatted(elevationChangeFormatStyle))",
                            systemImage: "arrow.down.right"
                        )
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .labelStyle(.trailingIcon)
                }
            }
        } // Button label
        .foregroundStyle(.primary)
    }
}


// MARK: - Preview

//#Preview {
//    RouteListItem()
//}
