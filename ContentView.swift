//
//  main.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 05/02/2024.
//

import SwiftUI
import Combine


struct ContentView: View {
    @AppStorage("ipAddress") private var ipAddress = "192.168.8.152"
    
    private var generator = UIImpactFeedbackGenerator(style: .medium)
    
    var logo = "https://i.imgur.com/zsk0v7O.png"
    @State private var isNextScreenActive: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var locIP: String = "Loading..."

    var body: some View {
        NavigationView {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.black, .black,.red]), startPoint: .top, endPoint: .bottom)
                    .blur(radius: 80)
                    .ignoresSafeArea()
                VStack {
                    Text("Device's local IP: \(self.locIP)")
                        .onAppear {
                            NetworkStuff().getLocalIPAddress { success in
                                self.locIP = success ?? "Not available"
                            }
                            
                        }
                    TextField("Enter server's local ip: ", text: $ipAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button(action: {
                        //                    print("Button Pressed!")
                        NetworkStuff().checkIP(ip: ipAddress) { success in
                            if success {
                                isNextScreenActive = true
                                HapticFeedbackSelection.heavy.trigger()
                                //                            print("Request was successful!")
                            } else {
                                alertMessage = "No route to server"
                                HapticFeedbackSelection.light.trigger()
                                //                            print("Request failed.")
                                showAlert = true
                            }
                        }
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
                        NextScreen(ipAddress: ipAddress, logo: logo)
                    }
                }
                .padding()
                .navigationTitle("IP Address Entry")
            }
        }
    }
}

#Preview {
    ContentView()
}
