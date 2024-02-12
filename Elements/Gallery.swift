//
//  Gallery.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 12/02/2024.
//

import Foundation
import SwiftUI


struct NextScreen: View {
    var ipAddress: String
    var logo: String
    
    @State private var showSettings: Bool = false
    @State private var showEngine: Bool = false
    
    @State private var charData: [[String: Any]]?
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                if let logoURL = URL(string: logo) {
                    AsyncImage(url: logoURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                        case .failure:
                            Text("Failed to load image")
                        case .empty:
                            ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 100, height: 100)
                } else {
                    Text("Invalid image URL")
                }
                

                Text("Host Address:\(ipAddress)")
                    .font(.headline)
                    .padding()
                    HStack {
                        Button(action: {
                            print("Button Pressed!")
                            self.showSettings = true
                        }){
                            Text("Update NNVals")
                        }
                        Button(action: {
                            print("Button Pressed!")
                            self.showEngine = true
                        }){
                            Text("Update Engine")
                        }
                        Button(action: {
                            print("Button Pressed!")
                            self.showEngine = true
                        }){
                            Text("Server Info")
                        }
                    }
                List {
                    if let charData = charData {
                        ForEach(charData.indices, id: \.self) { index in
                            ForEach(charData[index].keys.sorted(), id: \.self) { key in
                                if let value = charData[index][key] as? String,
                                   let imageURL = URL(string: value) {
                                    
                                    NavigationLink(destination: CharacterScreen(link: imageURL,name:key,ipAddress: ipAddress)) {
                                        VStack {
                                            Button(action: {
                                            
                                                print("Image clicked: \(key)")
                                            }) {
                                                AsyncImage(url: imageURL) { phase in
                                                    switch phase {
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 500, height: 500)
                                                    case .failure:
                                                        Text("Failed to load image")
                                                    case .empty:
                                                        ProgressView()
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                                .frame(width: 500, height: 500)
                                            }

                                            Text("\(key):")
                                                .bold()
                                        }
                                    }
                                } else {
                                    Text("Invalid image URL")
                                }
                            }
                        }
                    }
                }
                .sheet(isPresented: $showSettings) {
                    UNNScreen(ipAddress: ipAddress,logo: logo)
                }
                .sheet(isPresented: $showEngine) {
                    EngineView(logo:logo)
                }
                .onAppear {
                    DataEx().getChars(ip: ipAddress, endp: "char_list") { result in
                        switch result {
                        case .success(let fdata):
                            DispatchQueue.main.async {
                                self.charData = [fdata]
                            }
                        case .failure(let error):
                            print("Error fetching charData: \(error)")
                        }
                    }
                }
                .navigationBarBackButtonHidden(true)
            }
        }
    }
    
}

