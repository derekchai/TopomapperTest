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
    
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(route.name)
                    .font(.headline)
                
                Text(
                    "\(route.distance.metres.formatted(routeDistanceFormatStyle))"
                )
                .font(.subheadline)
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
                .labelStyle(.trailingIcon)
            }
        }
    }
}


// MARK: - Preview

//#Preview {
//    RouteListItem()
//}
