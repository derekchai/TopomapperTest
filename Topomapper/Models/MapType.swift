//
//  File.swift
//  Topomapper
//
//  Created by Derek Chai on 26/06/2024.
//

import Foundation

enum MapType: String, CaseIterable, Identifiable {
    case standard = "Standard"
    case topo50 = "Topo50"
    
    var id: Self { self }
}
