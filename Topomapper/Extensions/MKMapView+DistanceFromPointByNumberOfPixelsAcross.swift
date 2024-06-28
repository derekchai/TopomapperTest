//
//  MKMapView+DistanceFromPointByNumberOfPixelsAcross.swift
//  Topomapper
//
//  Created by Derek Chai on 28/06/2024.
//

import Foundation
import MapKit

extension MKMapView {
    /// Returns the distance in meters from the given point to the point which
    /// is `pixels` pixels *horizontally* across from the given point, on this
    /// `MKMapView`.
    ///
    /// This distance is not the same as if the distance was calculated using
    /// the point `pixels` pixels *vertically* across, due to map projection,
    /// angle, etc. This difference is greater at lower zoom levels.
    /// - Parameters:
    ///   - point₁: The point from which the distance is calculated.
    ///   - pixels: The number of pixels away horizontally from `point₁` the
    ///   distance should be calculated for.
    /// - Returns: Distance in meters.
    func distance(from point₁: CGPoint, byPixelsHorizontallyAcross pixels: Int) -> Double {
        let point₂ = CGPoint(x: point₁.x + CGFloat(pixels), y: point₁.y)
        
        let coordinate₁: CLLocationCoordinate2D = self.convert(
            point₁,
            toCoordinateFrom: self
        )
        
        let coordinate₂: CLLocationCoordinate2D = self.convert(
            point₂,
            toCoordinateFrom: self
        )
        
        return MKMapPoint(coordinate₁).distance(to: MKMapPoint(coordinate₂))
    }
}
