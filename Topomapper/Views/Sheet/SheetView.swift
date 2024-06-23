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
                
                Text("My Routes")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                ForEach(0...30, id: \.self) { number in
                    Text("Item \(number)")
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
    
    
    // MARK: - Actions
    
    private func setDetentToLarge() {
        selectedDetent = .large
    }
}


// MARK: - Preview

#Preview {
    SheetView(selectedDetent: .constant(.medium))
}
