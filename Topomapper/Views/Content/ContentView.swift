//
//  ContentView.swift
//  Topomapper
//
//  Created by Derek Chai on 20/06/2024.
//

import SwiftUI
import SwiftData
import MapKit

struct ContentView: View {
    
    
    // MARK: - Internal Variables
    
    @Environment(\.modelContext) private var modelContext
    
    @Environment(ViewModel.self) private var viewModel
    
    @State private var searchText = ""
    
    @State private var selectedDetent: PresentationDetent = .small
    
    @State private var mapCameraPostion: MapCameraPosition = .automatic
    
    @State private var selectedMapType: MapType = .standard
    
    private let presentationDetents: Set<PresentationDetent> = [
        .small,
        .medium,
        .large
    ]
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            if selectedMapType == .standard {
                Map(position: $mapCameraPostion) {
                    if let selectedRoute = viewModel.selectedRoute {
                        selectedRoute.polyline
                            .stroke(.blue, style: routePathStrokeStyle)
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
            } else {
                MapViewController()
                    .ignoresSafeArea()
            }
        }
        .sheet(isPresented: .constant(true)) {
            SheetView(
                selectedDetent: $selectedDetent,
                selectedMapType: $selectedMapType
            )
            .presentationBackground(.ultraThickMaterial)
            .presentationDetents(
                presentationDetents,
                selection: $selectedDetent
            )
            .interactiveDismissDisabled()
            .presentationBackgroundInteraction(.enabled(upThrough: .large))
            .presentationContentInteraction(.automatic)
        }
        .onChange(of: viewModel.selectedRoute) {
            mapCameraPostion = .automatic
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
        .modelContainer(for: Route.self, inMemory: true)
        .environment(ViewModel())
}
