//
//  SheetView.swift
//  Topomapper
//
//  Created by Derek Chai on 21/06/2024.
//

import SwiftUI

struct SheetView: View {
    @State private var searchText = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            SearchField(searchText: $searchText)
                .padding(.bottom)
            
            Text("My Routes")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .ignoresSafeArea()
        .presentationBackground(.ultraThickMaterial)
        .padding()
    }
}

#Preview {
    SheetView()
}
