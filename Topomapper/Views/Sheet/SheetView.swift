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
    
    @Query var routes: [Route]
    
    @State private var searchText = ""
    
    @State private var showingAddRouteSheet = false
    
    
    // MARK: - Body
    
    var body: some View {
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
                        HStack {
                            Text(route.name)
                            
                            Spacer()
                            
                            Text("\(route.points.count) points")
                        }
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
        .ignoresSafeArea()
        .sheet(isPresented: $showingAddRouteSheet) {
            AddRouteSheet()
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
}
