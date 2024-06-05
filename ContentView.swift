//
//  main.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 05/02/2024.
//

import SwiftUI
import Combine

class IPModel: ObservableObject {
    static let shared = IPModel()
    @Published var ipAddress: String = "192.168.8.152"
}

struct ContentView: View {
    @ObservedObject private var ipAddr = IPModel.shared
    
    private var generator = UIImpactFeedbackGenerator(style: .medium)
    
    var logo = "https://i.imgur.com/zsk0v7O.png"
    @State private var isNextScreenActive: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var locIP: String = "Loading..."
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.black, .black, Color(hex: 0xB30026)]), startPoint: .top, endPoint: .bottom)
                    .blur(radius: 80)
                    .ignoresSafeArea()
                VStack {
                    Text("Device's local IP: \(self.locIP)")
                        .onAppear {
                            NetworkStuff().getLocalIPAddress { success in
                                self.locIP = success ?? "Not available"
                            }
                        }
                    TextField("Enter server's local ip: ", text: $ipAddr.ipAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button(action: {
                        authenticateAndSubmit()
                    }) {
                        Text("Submit")
                            .padding()
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    .sheet(isPresented: $isNextScreenActive) {
                        NextScreen(ipAddress: ipAddr.ipAddress, logo: logo)
                    }
                }
                .padding()
                .navigationTitle("IP Address Entry")
            }
        }
    }
    
    private func authenticateAndSubmit() {
        faceauth { isAuthenticated in
            if isAuthenticated {
                NetworkStuff().checkIP(ip: ipAddr.ipAddress) { success in
                    if success {
                        isNextScreenActive = true
                        HapticFeedbackSelection.heavy.trigger()
                    } else {
                        alertMessage = "No route to server"
                        HapticFeedbackSelection.light.trigger()
                        showAlert = true
                    }
                }
            } else {
                alertMessage = "Face ID Authentication Failed"
                showAlert = true
            }
        }
    }
}
#Preview {
    ContentView()
}
