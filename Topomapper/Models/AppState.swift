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
    
    var path = NavigationPath()
    
    /// The Route currently selected by the user.
    private(set) var selectedRoute: Route? = nil {
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
    
    private(set) var selectedRoutePoint: RoutePoint? = nil {
        didSet {
            delegate?.selectedRoutePointDidChange(to: selectedRoutePoint)
        }
    }
    
    /// Whether the AddPointOfInterestSheet is being presented.
    var isPresentingAddPointOfInterestSheet = false
}

extension AppState {
    func setSelectedRoute(to route: Route?) {
        self.selectedRoute = route
    }
    
    func setSelectedRoutePoint(to routePoint: RoutePoint?) {
        self.selectedRoutePoint = routePoint
    }
}

protocol AppStateDelegate {
    func selectedRoutePointDidChange(to newRoutePoint: RoutePoint?)
    
    func selectedRouteDidChange(to newRoute: Route?)
    
    func selectedDetentDidChange(to newDetent: PresentationDetent?)
}
