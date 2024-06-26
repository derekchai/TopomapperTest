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
    
    @Bindable var viewModel: ViewModel
    
    
    // MARK: - Internal Variables
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var searchText = ""
    
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
                MapViewController(viewModel: viewModel)
                    .ignoresSafeArea()
            }
        }
        .sheet(isPresented: .constant(true)) {
            SheetView(
                selectedDetent: $viewModel.selectedDetent,
                selectedMapType: $selectedMapType
            )
            .presentationBackground(.ultraThickMaterial)
            .presentationDetents(
                presentationDetents,
                selection: $viewModel.selectedDetent
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
    ContentView(viewModel: ViewModel())
        .modelContainer(for: Route.self, inMemory: true)
        .environment(ViewModel())
}
