//
//  MainMap.swift
//  Topomapper
//
//  Created by Derek Chai on 20/06/2024.
//

import Foundation
import SwiftUI
import MapKit

struct MapViewControllerRepresentable: UIViewControllerRepresentable {
    
    
    // MARK: - Exposed Properties
    
    var appState: AppState
    
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewControllerRepresentable
        
        var appState: AppState
        
        init(parent: MapViewControllerRepresentable, appState: AppState) {
            self.parent = parent
            self.appState = appState
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, appState: appState)
    }

    
    // MARK: - UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let mapView = MKMapView()
        
        mapView.delegate = context.coordinator
        mapView.frame = viewController.view.frame
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mapView.showsCompass = true
        mapView.showsScale = true
        
        mapView.overrideUserInterfaceStyle = .light
        
        addTopo50MapOverlay(to: mapView)
        
        updateRoutePath(in: mapView)
        
        updateStartEndAnnotations(in: mapView)
        updateSelectedPointAnnotation(in: mapView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(context.coordinator.ahandleMapTap)
        )
        
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        viewController.view.addSubview(mapView)
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let mapView = uiViewController.view.subviews.first as! MKMapView
        
        updateRoutePath(in: mapView)
        
        updateStartEndAnnotations(in: mapView)
        updateSelectedPointAnnotation(in: mapView)
    }
    
    
    // MARK: - Internal Functions
    
    /// Adds a `UITapGestureRecognizer` onto `mapView`.
    private func addMapTapGestureRecognizer(to mapView: MKMapView) {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(MapViewControllerRepresentable.Coordinator.ahandleMapTap)
        )
        
        mapView.addGestureRecognizer(tapGestureRecognizer)
    }
}

