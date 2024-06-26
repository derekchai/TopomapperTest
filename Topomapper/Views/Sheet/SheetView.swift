//
//  SheetView.swift
//  Topomapper
//
//  Created by Derek Chai on 21/06/2024.
//

import SwiftUI
import SwiftData

struct SheetView: View {
    
    
    // MARK: - Exposed Properties
    
    @Binding var selectedDetent: PresentationDetent
    
    
    // MARK: - Internal Variables
    
    @Environment(\.modelContext) private var modelContext
    
    @Environment(ViewModel.self) private var viewModel
    
    @Query var routes: [Route]
    
    @State private var searchText = ""
    
    @State private var showingAddRouteSheet = false
    
    @State private var showingRouteDetailSheet = false
    
    private let presentationDetents: Set<PresentationDetent> = [
        .small,
        .medium,
        .large
    ]
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchField(
                    searchText: $searchText,
                    onCancel: setDetentToLarge,
                    onFocus: setDetentToLarge
                )
                .padding([.leading, .top, .trailing])
                
                List {
                    Section {
                        ForEach(routes) { route in
                                RouteListItem(
                                    route: route,
                                    onItemTapGesture: {
                                        updateSelectedRoute(to: route)
                                        showingRouteDetailSheet = true
                                    }
                                )
                        }
                        .onDelete(perform: removeRoutes)
                        
                    } header: {
                        HStack {
                            Text("My Routes")
                                .font(.headline)
                            
                            Spacer()
                            
                            Button(
                                "New Route",
                                action: showAddRouteSheet
                            )
                        }
                        .textCase(nil)
                    }
                } // List
                .scrollContentBackground(.hidden)
                
            } // VStack
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showingAddRouteSheet) {
            AddRouteSheet()
        }
        .sheet(isPresented: $showingRouteDetailSheet) {
            if let selectedRoute = viewModel.selectedRoute {
                RouteDetailSheetView(route: selectedRoute)
                    .padding()
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
    
    
    // MARK: - Actions
    
    private func setDetentToLarge() {
        selectedDetent = .large
    }
    
    private func showAddRouteSheet() {
        showingAddRouteSheet = true
    }
    
    private func removeRoutes(at indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(routes[index])
        }
    }
    
    private func updateSelectedRoute(to route: Route?) {
        viewModel.selectedRoute = nil // Slightly hacky way to center camera on feature
        viewModel.selectedRoute = route
    }
    
    
    //    private func copyFileToResourcesFolder(_ result: Result<URL, any Error>) {
    //        do {
    //            let url = try result.get()
    //
    //            if url.startAccessingSecurityScopedResource() {
    //                let fileManager = FileManager()
    //
    //                let paths = FileManager.default.urls(
    //                    for: .documentDirectory,
    //                    in: .userDomainMask
    //                )
    //
    //                let documentsDirectory: URL = paths[0]
    //
    //                let destinationURL = documentsDirectory.appendingPathComponent(
    //                    "\(UUID().uuidString).gpx"
    //                )
    //
    //                print(destinationURL)
    //
    //                do {
    //                    try fileManager.copyItem(at: url, to: documentsDirectory)
    //                    print("Destination URL: \(destinationURL)")
    //                } catch {
    //                    print("HERE: \(error.localizedDescription)")
    //                }
    //            }
    //
    //            url.stopAccessingSecurityScopedResource()
    //        } catch {
    //            print(error.localizedDescription)
    //        }
    //    }
}


// MARK: - Preview

#Preview {
    SheetView(selectedDetent: .constant(.medium))
        .environment(ViewModel())
}
