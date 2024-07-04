//
//  Array<RoutePoint>+NearestPoint.swift
//  Topomapper
//
//  Created by Derek Chai on 04/07/2024.
//

import Foundation

extension Array where Element == RoutePoint {
    /// Uses a modified binary search to find the `RoutePoint` in this array whose
    /// `distanceFromStart` property is closest to the `distanceFromStart` given.
    func nearestPoint(to distanceFromStart: Double) -> RoutePoint? {
        guard !self.isEmpty else { return nil }
        
        if distanceFromStart < self.first!.distanceFromStart {
            return self.first!
        }
        
        if distanceFromStart > self.last!.distanceFromStart {
            return self.last!
        }
        
        var low: Int = 0
        var high: Int = self.count - 1
        
        while low <= high {
            let mid: Int = (low + high) / 2
            let midPoint = self[mid]
            
            if midPoint.distanceFromStart == distanceFromStart {
                return midPoint
            } else if midPoint.distanceFromStart < distanceFromStart {
                low = mid + 1
            } else {
                high = mid - 1
            }
        }
        
        let lowerBoundPoint = self[Swift.max(low - 1, 0)]
        let upperBoundPoint = self[Swift.min(low, self.count - 1)]
        
        if abs(lowerBoundPoint.distanceFromStart - distanceFromStart) < abs(
            upperBoundPoint
                .distanceFromStart - distanceFromStart) {
            return lowerBoundPoint
        } else {
            return upperBoundPoint
        }
    }
}
