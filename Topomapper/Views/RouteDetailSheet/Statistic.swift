//
//  Statistic.swift
//  Topomapper
//
//  Created by Derek Chai on 26/06/2024.
//

import SwiftUI

struct Statistic: View {
    
    
    // MARK: - Exposed Properties
    
    var label: String
    
    var systemImageName: String
    
    var value: String
    
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .textCase(.uppercase)
                .foregroundStyle(.secondary)
            
            HStack {
                Image(systemName: systemImageName)
                    .foregroundStyle(.secondary)
                
                Text(value)
            }
        }
    }
}


// MARK: - Preview

#Preview {
    Statistic(label: "Length", systemImageName: "point.topleft.down.to.point.bottomright.curvepath.fill", value: "74 km")
}
