//
//  MainMap.swift
//  Topomapper
//
//  Created by Derek Chai on 20/06/2024.
//

import Foundation
import SwiftUI
import MapKit

struct MapViewController: UIViewControllerRepresentable {
    
    
    // MARK: - Exposed Properties
    
    var viewModel: ViewModel
    
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewController
        
        var viewModel: ViewModel
        
        init(parent: MapViewController, viewModel: ViewModel) {
            self.parent = parent
            self.viewModel = viewModel
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, viewModel: viewModel)
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
        
        updateAnnotations(in: mapView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(context.coordinator.handleMapTap)
        )
        
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        viewController.view.addSubview(mapView)
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let mapView = uiViewController.view.subviews.first as! MKMapView
        
        updateRoutePath(in: mapView)
        
        updateAnnotations(in: mapView)
    }
    
    
    // MARK: - Internal Functions
    
    /// Adds a `UITapGestureRecognizer` onto `mapView`.
    private func addMapTapGestureRecognizer(to mapView: MKMapView) {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(MapViewController.Coordinator.handleMapTap)
        )
        
        mapView.addGestureRecognizer(tapGestureRecognizer)
    }
}

