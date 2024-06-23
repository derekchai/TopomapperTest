//
//  SearchBox.swift
//  Topomapper
//
//  Created by Derek Chai on 21/06/2024.
//

import SwiftUI

/// A control that displays an editable search field interface.
struct SearchField: View {
    
    
    // MARK: - Exposed Properties
    
    /// The text to display and edit.
    @Binding var searchText: String
    
    /// Adds an action to perform when the "Cancel" button of this view is 
    /// pressed.
    var onCancel: () -> Void = {}
    
    /// Adds an action to perform when the clear button of this view is pressed.
    var onClear: () -> Void = {}
    
    /// Adds an action to perform when this view is focused on.
    var onFocus: () -> Void = {}
    
    /// Adds an action to perform when this view is unfocused from.
    var onUnfocus: () -> Void = {}
    
    
    // MARK: - Internal Variables
    
    /// Whether the text field is being focused on.
    @FocusState private var isFocusedOnTextField: Bool
    
    /// A mirror of `isFocusedOnTextField`, used solely for animation purposes.
    @State private var isSearching = false
    
    /// Whether the "Clear" button should be shown.
    @State private var isShowingClearButton = false
    
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                
                TextField("Search saved routes", text: $searchText)
                    .autocorrectionDisabled()
                    .focused($isFocusedOnTextField)
                
                if isShowingClearButton {
                    Button(
                        "",
                        systemImage: "xmark.circle.fill",
                        action: clearSearch
                    )
                    .foregroundStyle(.secondary)
                    .animation(.easeInOut, value: isShowingClearButton)
                    .padding(.trailing, -8)
                }
            }
            .textFieldSearchBoxStyle()
            .animation(.bouncy, value: isSearching)
            
            if isSearching {
                Button("Cancel", action: cancelSearch)
            }
        }
        .onChange(of: isFocusedOnTextField) { oldState, newState in
            if newState == true {
                onFocus()
            }
            
            withAnimation { isSearching = newState }
        }
        .onChange(of: searchText) { oldText, newText in
            withAnimation { isShowingClearButton = !newText.isEmpty }
        }
    }
    
    
    // MARK: - Actions
    
    private func cancelSearch() {
        isSearching.toggle()
        isFocusedOnTextField.toggle()
        clearSearch()
        onCancel()
    }
    
    private func clearSearch() {
        searchText = ""
        onClear()
    }
}


// MARK: - Custom View Modifiers

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


// MARK: - Preview

#Preview {
    @Previewable @State var searchText = ""
    
    SearchField(searchText: $searchText)
}
