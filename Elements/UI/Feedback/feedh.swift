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

func sendNotification(title: String, subtitle: String, body: String,id:String) {
    let noti = UNMutableNotificationContent()
    noti.title = title
    noti.subtitle = subtitle
    noti.body = body

    let identifier = id
    print(identifier)

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

    let request = UNNotificationRequest(identifier: identifier, content: noti, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { (error) in
        if let error = error {
            print("Error scheduling notification: \(error.localizedDescription)")
        }
    }
    print("noti sent")
}
