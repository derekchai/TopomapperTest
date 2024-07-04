//
//  AddRouteSheet.swift
//  Topomapper
//
//  Created by Derek Chai on 24/06/2024.
//

import SwiftUI

struct AddRouteSheet: View {
    
    
    // MARK: - Internal Variables
    
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var routeName: String = ""
    @State private var routePoints: [RoutePoint] = []
    
    /// The filename (including extension) of the user-selected GPX file.
    @State private var gpxFilename: String?
    
    @State private var showingImportDialog = false
    
    @State private var showingUnableToParseGPXAlert = false
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Route name", text: $routeName)
                
                HStack {
                    Text("GPX file")
                    
                    Spacer()
                    
                    Button(
                        gpxFilename != nil ? gpxFilename! : "Import from Files",
                        action: showImportingDialog
                    )
                }
            }
            .navigationTitle("New Route")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: { dismiss() })
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: saveRoute)
                        .disabled(routeName.isEmpty || routePoints.isEmpty)
                }
            }
        }  // NavigationStack
        .fileImporter(
            isPresented: $showingImportDialog,
            allowedContentTypes: [.xml],
            onCompletion: parseGPXFile
        )
        .alert(
            "This file could not be loaded",
            isPresented: $showingUnableToParseGPXAlert
        ) {
            Button("Ok") {
                showingUnableToParseGPXAlert = false
            }
        }
    }  // body
    
    
    // MARK: - Actions
    
    private func showImportingDialog() {
        showingImportDialog = true
    }
    
    /// Parses the GPX file at the given URL.
    private func parseGPXFile(_ result: Result<URL, any Error>) {
        switch result {
        case .success(let url):
            let gotAccess = url.startAccessingSecurityScopedResource()
            
            if !gotAccess { return }
            
            let parser = GPXParser()
            
            do {
                routePoints = try parser.parsedGPXFile(at: url)
                
                gpxFilename = url.lastPathComponent
            } catch {
                showingUnableToParseGPXAlert = true
            }
            
            url.stopAccessingSecurityScopedResource()
            
        case .failure:
            showingUnableToParseGPXAlert = true
        }
    }
    
    private func saveRoute() {
        let route = Route(
            name: routeName,
            points: routePoints,
            pointsOfInterest: []
        )
        
        modelContext.insert(route)
        
        print(String(describing: route))
        
        dismiss()
    }
}


// MARK: - Preview

#Preview {
    AddRouteSheet()
}
