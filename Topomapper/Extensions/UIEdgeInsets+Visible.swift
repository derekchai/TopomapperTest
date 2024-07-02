//
//  UIEdgeInsets+Zoom.swift
//  Topomapper
//
//  Created by Derek Chai on 02/07/2024.
//

import Foundation
import UIKit
import SwiftUI

extension UIEdgeInsets {
    static func notBlockedBySheet(
        screenHeight: CGFloat,
        detent: PresentationDetent,
        otherInsets: CGFloat = 20
    ) -> UIEdgeInsets {
        var insets = UIEdgeInsets(
            top: otherInsets,
            left: otherInsets,
            bottom: otherInsets,
            right: otherInsets
        )
        
        switch detent {
        case .small:
            insets.bottom = 0.1 * screenHeight + otherInsets
        case .medium:
            insets.bottom = 0.5 * screenHeight + otherInsets
        case .large:
            insets.bottom = 1.0 * screenHeight
        default:
            insets.bottom = 0.5 * screenHeight + otherInsets
        }
        
        return insets
    }
}
