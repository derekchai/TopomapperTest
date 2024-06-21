//
//  SearchBox.swift
//  Topomapper
//
//  Created by Derek Chai on 21/06/2024.
//

import SwiftUI

struct SearchField: View {
    @Binding var searchText: String
    
    /// A property wrapper which stores whether or not the text field is currently being focused on.
    @FocusState private var isFocusedOnTextField: Bool
    
    /// A state variable which mirrors `isFocusedOnTextField`, used for animation.
    @State private var isSearching = false
    
    @State private var isShowingClearButton = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                
                TextField("Search saved routes", text: $searchText)
                    .autocorrectionDisabled()
                    .focused($isFocusedOnTextField)
                
                if isShowingClearButton {
                    Button("", systemImage: "xmark.circle.fill") {
                        searchText = ""
                    }
                    .foregroundStyle(.secondary)
                    .animation(.easeInOut(duration: 0.2), value: isShowingClearButton)
                    .padding(.trailing, -8)
                }
            }
            .textFieldSearchBoxStyle()
            .animation(.bouncy, value: isSearching)
            
            
            if isSearching {
                Button("Cancel") {
                    isSearching.toggle()
                    isFocusedOnTextField.toggle()
                }
            }
        }
        .onChange(of: isFocusedOnTextField) { oldValue, newValue in
            withAnimation {
                isSearching = newValue
            }
        }
        .onChange(of: searchText.isEmpty) { oldValue, newValue in
            withAnimation {
                isShowingClearButton = !newValue
            }
        }
    }
}

extension View {
    func textFieldSearchBoxStyle() -> some View {
        self
            .modifier(TextFieldSearchBoxStyle())
    }
}

/// A style for a search box-style text field.
struct TextFieldSearchBoxStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    @Previewable @State var searchText = ""
    
    SearchField(searchText: $searchText)
}
