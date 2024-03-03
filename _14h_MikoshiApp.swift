//
//  MikoshiApp.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 05/02/2024.
//

import SwiftUI

@main
struct _14h_MikoshiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
            .onAppear{
                Task {
                    if !Task.isCancelled {
                        await reqNotiperm()
                    }
                }
                }
        }
        
        
    }
    @MainActor
    func reqNotiperm() async {
        do{
            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        }
        catch{
            print("Err")
        }
    }
}
