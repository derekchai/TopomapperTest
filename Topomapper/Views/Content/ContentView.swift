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
    
    @State private var selectedDetent: PresentationDetent = .small
    
    private let presentationDetents: Set<PresentationDetent> = [
        .small,
        .medium,
        .large
    ]
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            MapViewController()
                .ignoresSafeArea()
                .sheet(isPresented: .constant(true)) {
                    SheetView(selectedDetent: $selectedDetent)
                        .presentationBackground(.ultraThickMaterial)
                        .presentationDetents(
                            presentationDetents,
                            selection: $selectedDetent
                        )
                        .interactiveDismissDisabled()
                        .presentationBackgroundInteraction(.enabled(upThrough: .large))
                        .presentationContentInteraction(.automatic)
                }
        }
    }
}


// MARK: - Custom Presentation Detents

extension PresentationDetent {
    static let small: PresentationDetent = PresentationDetent.fraction(0.1)
}


// MARK: - Preview

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
