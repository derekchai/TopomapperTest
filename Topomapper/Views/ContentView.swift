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
    
    @Bindable var appState: AppState
    
    
    // MARK: - Internal Variables
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var searchText = ""
    
    @State private var mapCameraPostion: MapCameraPosition = .automatic
    
    @State private var selectedMapType: MapType = .topo50
    
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
                    if let selectedRoute = appState.selectedRoute {
                        selectedRoute.polyline
                            .stroke(.blue, style: routePathStrokeStyle)
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
            } else {
                MapViewControllerRepresentable(appState: appState)
                    .ignoresSafeArea()
            }
        }
        .sheet(isPresented: .constant(true)) {
            SheetView(
                selectedDetent: $appState.selectedDetent,
                selectedMapType: $selectedMapType
            )
            .presentationBackground(.ultraThickMaterial)
            .presentationDetents(
                presentationDetents,
                selection: $appState.selectedDetent
            )
            .interactiveDismissDisabled()
            .presentationBackgroundInteraction(.enabled(upThrough: .large))
            .presentationContentInteraction(.automatic)
        }
        .onChange(of: appState.selectedRoute) {
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
    ContentView(appState: AppState())
        .modelContainer(for: Route.self, inMemory: true)
        .environment(AppState())
}
