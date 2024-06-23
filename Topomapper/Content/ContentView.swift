//
//  ContentView.swift
//  Topomapper
//
//  Created by Derek Chai on 20/06/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            MapViewController()
                .ignoresSafeArea()
                .sheet(isPresented: .constant(true)) {
                    NavigationStack {
                        SheetView()
                            .toolbar(.automatic)
                    }
                    .presentationDetents([.fraction(0.1), .medium, .large])
                    .interactiveDismissDisabled()
                    .presentationBackgroundInteraction(.enabled(upThrough: .large))
                    .presentationContentInteraction(.scrolls)
                }
        }
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
