//
//  SheetView.swift
//  Topomapper
//
//  Created by Derek Chai on 21/06/2024.
//

import SwiftUI

struct SheetView: View {
    
    
    // MARK: - Exposed Properties
    
    @Binding var selectedDetent: PresentationDetent
    
    
    // MARK: - Internal Variables
    
    @State private var searchText = ""
    
    /// Whether the file picker dialog should be shown.
    @State private var importing = false
    
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                SearchField(
                    searchText: $searchText,
                    onCancel: setDetentToLarge,
                    onFocus: setDetentToLarge
                )
                .padding(.bottom)
                
                HStack {
                    Text("My Routes")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Button("Import GPX", action: showImportingDialog)
                }
                
                ForEach(0...30, id: \.self) { number in
                    Text("Item \(number)")
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea()
        .fileImporter(
            isPresented: $importing,
            allowedContentTypes: [.xml],
            onCompletion: parseGPXFile
        )
    }
    
    
    // MARK: - Actions
    
    private func setDetentToLarge() {
        selectedDetent = .large
    }
    
    private func showImportingDialog() {
        importing = true
    }
    
    /// Parses the GPX file at the given URL.
    private func parseGPXFile(_ result: Result<URL, any Error>) {
        switch result {
        case .success(let url):
            let gotAccess = url.startAccessingSecurityScopedResource()
            
            if !gotAccess { return }
            
            let parser = GPXParser()
            
            do {
                let points = try parser.parsedGPXFile(at: url)
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
