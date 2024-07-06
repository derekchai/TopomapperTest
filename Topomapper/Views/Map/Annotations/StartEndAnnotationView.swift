//
//  StartEndAnnotationView.swift
//  Topomapper
//
//  Created by Derek Chai on 06/07/2024.
//

import UIKit
import MapKit

class StartEndAnnotationView: MKAnnotationView {
    override var annotation: (any MKAnnotation)? {
        willSet {
            guard let annotation = annotation as? StartEndAnnotation else { return }
            
            canShowCallout = false
            
            let imageName = annotation.title == "Start" ? "a.circle.fill": "b.circle.fill"
            
            let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
            
            let mainColorsConfiguration = UIImage.SymbolConfiguration(
                paletteColors: [.white, .systemBlue]
            )
            
            var mainImage = UIImage(systemName: imageName, withConfiguration: symbolConfiguration)
            mainImage = mainImage?
                .applyingSymbolConfiguration(mainColorsConfiguration)
            
            mainImage = mainImage?.withRenderingMode(.alwaysOriginal)
            
            let outlineConfiguration = UIImage.SymbolConfiguration(weight: .bold)
            var outlineImage = UIImage(systemName: imageName, withConfiguration: outlineConfiguration)
            outlineImage = outlineImage?.withRenderingMode(.alwaysTemplate)
            
            let outlineImageView = UIImageView(image: outlineImage)
            outlineImageView.tintColor = .polylineOutline
            
            let mainImageView = UIImageView(image: mainImage)
            
            // Centering mainImageView atop outlineImageView.
            outlineImageView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
            mainImageView.frame = CGRect(x: 2, y: 2, width: 18, height: 18)
            
            let containerView = UIView()
            containerView.addSubview(outlineImageView)
            containerView.addSubview(mainImageView)
            containerView.frame = outlineImageView.frame
            
            self.addSubview(containerView)
            self.bounds = containerView.bounds
        }
    }
}
