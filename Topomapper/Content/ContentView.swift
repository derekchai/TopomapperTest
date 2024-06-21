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

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
