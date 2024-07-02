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
class AppState {
    var delegate: AppStateDelegate?
    
    /// The Route currently selected by the user.
    var selectedRoute: Route? = nil {
        didSet {
            delegate?.selectedRouteDidChange(to: selectedRoute)
        }
    }
    
    /// The presentation detent the app's main sheet is currently presenting in.
    var selectedDetent: PresentationDetent = .small {
        didSet {
            delegate?.selectedDetentDidChange(to: selectedDetent)
        }
    }
    
    var selectedMapPoint: MKMapPoint? = nil {
        didSet {
            delegate?.selectedMapPointDidChange(to: selectedMapPoint)
        }
    }
}

protocol AppStateDelegate {
    func selectedMapPointDidChange(to newMapPoint: MKMapPoint?)
    
    func selectedRouteDidChange(to newRoute: Route?)
    
    func selectedDetentDidChange(to newDetent: PresentationDetent?)
}
