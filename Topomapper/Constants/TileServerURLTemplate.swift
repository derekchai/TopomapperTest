//
//  TileServerURLTemplate.swift
//  Topomapper
//
//  Created by Derek Chai on 27/06/2024.
//

import Foundation

enum TileServerURLTemplate {
    /// Land Information New Zealand (LINZ) Topo50 tile server URL template.
    static let topo50 = "https://tiles-cdn.koordinates.com/services;key=\(Key.topo50APIKey)/tiles/v4/layer=52343/EPSG:3857/{z}/{x}/{y}.png"
    
    /// OpenStreetMap tile server URL template.
    static let openStreetMap = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
}
