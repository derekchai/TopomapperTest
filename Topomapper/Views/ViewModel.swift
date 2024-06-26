//
//  ViewController.swift
//  Topomapper
//
//  Created by Derek Chai on 26/06/2024.
//

import Foundation
import SwiftUI

@Observable
class ViewModel {
    var selectedRoute: Route? = nil
    
    var selectedDetent: PresentationDetent = .small
}
