//
//  MapViewControllerCoordinator+DelegateMethods.swift
//  Topomapper
//
//  Created by Derek Chai on 27/06/2024.
//

import Foundation
import UIKit
import MapKit
import SwiftUI

extension MapViewController.Coordinator {
    
    
    // MARK: - rendererFor overlay: MKOverlay
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case let tileOverlay as MKTileOverlay:
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        case let polyline as MKPolyline:
            let renderer = MKPolylineRenderer(polyline: polyline)
            
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            renderer.lineCap = .round
            renderer.lineJoin = .round
            
            return renderer
        default:
            fatalError("Unexpected MKOverlay type")
        }
    }
    
    
    // MARK: - viewFor annotation: any MKAnnotation
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard annotation is StartEndAnnotation else { return nil }
        
        let identifier = "marker"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier
            )
            
            annotationView?.animatesWhenAdded = true
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(
                type: .detailDisclosure
            )
            annotationView?.markerTintColor = annotation.title == "Start" ? .green : .red
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    
    // MARK: - handleMapTap
    
    @objc func handleMapTap(from sender: UITapGestureRecognizer) {
        guard sender.state == .recognized else { return }
        
        guard let mapView = sender.view as? MKMapView else { return }
        
        let tappedPoint: CGPoint = sender.location(in: mapView)
        let tappedCoordinate: CLLocationCoordinate2D = mapView.convert(
            tappedPoint,
            toCoordinateFrom: mapView
        )
        let tappedMapPoint: MKMapPoint = MKMapPoint(tappedCoordinate)
        
        let maximumMetersFromPoint: Double = distance(
            from: tappedPoint,
            byPixels: 22,
            in: mapView
        )
        
        var closestPointToTap: MKMapPoint?
        
        for overlay in mapView.overlays {
            guard overlay is MKPolyline else { continue }
            
            let polyline = overlay as! MKPolyline
            
            closestPointToTap = polyline.closestPointInPolyline(to: tappedMapPoint)
        }
        
        guard let closestPointToTap else { return }
        
        let distanceAway = closestPointToTap.distance(to: tappedMapPoint)
        
        if distanceAway <= maximumMetersFromPoint {
            print(
                "Closest point tapped: \(String(describing: closestPointToTap)) (\(distanceAway) m away)."
            )
        }
    }
    
    /// Returns the distance in meters from the given point to the point on the
    /// given `MKMapView` which is a certain number of pixels away.
    /// - Parameters:
    ///   - point₁: The point from which the distance is calculated.
    ///   - pixel: The number of pixels away from `point₁` the distance (meters)
    ///   should be calculated for.
    ///   - mapView: The `MKMapView` with the `point`.
    /// - Returns: Distance in meters.
    private func distance(from point₁: CGPoint, byPixels pixels: Int, in mapView: MKMapView) -> Double {
        let point₂ = CGPoint(x: point₁.x + CGFloat(pixels), y: point₁.y)
        
        let coordinate₁: CLLocationCoordinate2D = mapView.convert(
            point₁,
            toCoordinateFrom: mapView
        )
        
        let coordinate₂: CLLocationCoordinate2D = mapView.convert(
            point₂,
            toCoordinateFrom: mapView
        )
        
        return MKMapPoint(coordinate₁).distance(to: MKMapPoint(coordinate₂))
    }
}
