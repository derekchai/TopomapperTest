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
        VStack {
            SearchField(searchText: $searchText)
            
            Spacer()
        }
        .presentationBackground(.ultraThickMaterial)
        .padding()
    }
}

#Preview {
    SheetView()
}
