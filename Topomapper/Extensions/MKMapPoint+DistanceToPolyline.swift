//
//  MKMapPoint+DistanceToPolyline.swift
//  Topomapper
//
//  Created by Derek Chai on 27/06/2024.
//

import Foundation
import MapKit

extension MKMapPoint {
    /// Returns the distance (in meters) this point is from the given polyline.
    /// - Parameter polyline: The polyline to calculate the distance this point
    /// is from.
    /// - Returns: Distance in meters.
    func distance(to polyline: MKPolyline) -> Double {
        var distance: Double = Double.greatestFiniteMagnitude
        
        for i in 0..<polyline.pointCount - 1 {
            let point₁ = polyline.points()[i]
            let point₂ = polyline.points()[i + 1]
            
            let Δx = point₂.x - point₁.x
            let Δy = point₂.y - point₁.y
            
            guard Δx != 0 && Δy != 0 else { continue }
            
            /// This is the distance along the line defined by `point₁` to `point₂`
            /// that a line perpendicular to this line and passing through this
            /// point (`self`) intersects with the original line, normalized.
            ///
            /// If `scalarProjection` equals 0, the projection falls exactly at
            /// `point₁`.
            ///
            /// If `noramlizedParameter` equals 1, the projection falls exactly at
            /// `point₂`.
            ///
            /// If `scalarProjection` is between 0 and 1 (exclusive), the
            /// projection falls somewhere between `point₁` and `point₂`.
            ///
            /// If `scalarProjection` is outside 0 and 1 (inclusive), the
            /// projection falls outside the line segment, on the line that extends
            /// infinitely from the line segment in both directions.
            let scalarProjection = (
                (self.x - point₁.x) * Δx + (self.y - point₁.y) * Δy
            )/(
                pow(Δx, 2) + pow(Δy, 2)
            )
            
            var closestPoint: MKMapPoint
            
            if scalarProjection < 0 {  // Outside line segment, on point₁ side
                closestPoint = point₁
            } else if scalarProjection > 1 {  // Outside line segment, on point₂ side
                closestPoint = point₂
            } else {  // On line segment
                closestPoint = MKMapPoint(
                    x: point₁.x + scalarProjection * Δx,
                    y: point₁.y + scalarProjection * Δy
                )
            }
            
            distance = min(distance, closestPoint.distance(to: self))
        }
        
        return distance
    }
}
