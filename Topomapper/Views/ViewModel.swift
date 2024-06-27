//
//  ViewController.swift
//  Topomapper
//
//  Created by Derek Chai on 26/06/2024.
//

import Foundation
import SwiftUI
import MapKit

@Observable
class ViewModel {
    /// The Route currently selected by the user.
    var selectedRoute: Route? = nil
    
    /// The presentation detent the app's main sheet is currently presenting in.
    var selectedDetent: PresentationDetent = .small
    
    var selectedPoint: MKMapPoint? = nil
}
