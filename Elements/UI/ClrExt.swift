//
//  ClrExt.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 23/02/2024.
//

import Foundation
import SwiftUI



extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}
