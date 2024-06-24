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
    
    /// Whether the file picker dialog should be shown.
    @State private var importing = false
    
    
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
                        
                        Button("Import GPX", action: showImportingDialog)
                    }
                    .textCase(nil)
                }
            } // List
            .scrollContentBackground(.hidden)
            
        } // VStack
        .ignoresSafeArea()
        .fileImporter(
            isPresented: $importing,
            allowedContentTypes: [.xml],
            onCompletion: parseGPXFile
        )
        .onAppear {
            print("The modelContext has \(routes.count) routes")
        }
    }
    
    
    // MARK: - Actions
    
    private func setDetentToLarge() {
        selectedDetent = .large
    }
    
    private func showImportingDialog() {
        importing = true
    }
    
    private func removeRoutes(at indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(routes[index])
        }
    }
    
    /// Parses the GPX file at the given URL.
    private func parseGPXFile(_ result: Result<URL, any Error>) {
        switch result {
        case .success(let url):
            let gotAccess = url.startAccessingSecurityScopedResource()
            
            if !gotAccess { return }
            
            print("Got access!")
            
            let parser = GPXParser()
            
            do {
                let points = try parser.parsedGPXFile(at: url)
                
                print("Successfully parsed GPX file!")
                
                let route = Route(
                    name: "Route\(UUID().uuidString)",
                    points: points
                )
                
                print("\(route.name): \(route.points.count) points")
                
                modelContext.insert(route)
                
                print("Inserted new route into modelContext!")
            } catch {
                print("Unable to parse GPX: \(error)")
            }
            
            url.stopAccessingSecurityScopedResource()
            
        case .failure(let error):
            print(error)
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
