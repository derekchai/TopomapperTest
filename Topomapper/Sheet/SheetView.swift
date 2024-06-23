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
        ScrollView {
            VStack(alignment: .leading) {
                SearchField(searchText: $searchText)
                    .padding(.bottom)
                
                Text("My Routes")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                ForEach(0...30, id: \.self) { number in
                    Text("Item \(number)")
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea()
        .presentationBackground(.ultraThickMaterial)
        .padding()
    }
}

#Preview {
    SheetView()
}
