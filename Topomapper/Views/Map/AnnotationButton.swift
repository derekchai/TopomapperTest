//
//  AnnotationButton.swift
//  Topomapper
//
//  Created by Derek Chai on 05/07/2024.
//

import SwiftUI

struct AnnotationButton: View {
    var body: some View {
        Menu("", systemImage: "ellipsis.circle") {
            Button("Add point of interest", systemImage: "star") {
                
            }
            
            Button("Add stop", systemImage: "tent") {
                
            }
        }
    }
}

#Preview {
    AnnotationButton()
}
