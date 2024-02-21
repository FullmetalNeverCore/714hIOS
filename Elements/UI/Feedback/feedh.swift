//
//  feedh.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 21/02/2024.
//

import Foundation
import SwiftUI

enum HapticFeedbackSelection {
        //Feedback levels
        case medium
        case light
        case heavy
    

        func trigger() {
            let generator: UIImpactFeedbackGenerator
            switch self {
            case .medium:
                generator = UIImpactFeedbackGenerator(style: .medium)
            case .light:
                generator = UIImpactFeedbackGenerator(style: .light)
            case .heavy:
                generator = UIImpactFeedbackGenerator(style: .heavy)
            }
            generator.impactOccurred()
        }
}
