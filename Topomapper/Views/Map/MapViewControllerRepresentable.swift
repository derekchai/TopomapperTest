//
//  MapVCR.swift
//  Topomapper
//
//  Created by Derek Chai on 28/06/2024.
//

import Foundation
import SwiftUI

struct MapViewControllerRepresentable: UIViewControllerRepresentable {
    let appState: AppState
    
    func makeUIViewController(context: Context) -> MapViewController {
        MapViewController(appState: appState)
    }

    func updateUIViewController(
        _ uiViewController: MapViewController,
        context: Context
    ) {
        
    }
}
