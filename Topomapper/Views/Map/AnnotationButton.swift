//
//  AnnotationButton.swift
//  Topomapper
//
//  Created by Derek Chai on 05/07/2024.
//

import SwiftUI

struct AnnotationButton: View {
    
    
    // MARK: - Private Variables
    
    @Environment(AppState.self) private var appState
    
    
    // MARK: - Body
    
    var body: some View {
        Menu("", systemImage: "ellipsis.circle") {
            Button("Add point of interest", systemImage: "star") {
                appState.isPresentingAddPointOfInterestSheet = true
            }
            
            Button("Add stop", systemImage: "tent") {
                
            }
        }
    }
}


// MARK: - Preview

#Preview {
    AnnotationButton()
}
