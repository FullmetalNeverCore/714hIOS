
//
//  Gallery.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 12/02/2024.
//

import Foundation
import SwiftUI
import Kingfisher


struct NextScreen: View {
    var ipAddress: String
    var logo: String
    
    @State private var showSettings: Bool = false
    @State private var showEngine: Bool = false
    @State private var showServer: Bool = false
    @State private var done = false
    @ObservedObject var ipAddr = IPModel.shared
    
    @State private var charData: [[String: Any]]?
    
    @State private var filterState: Bool = false
    
    @State private var filter: String  = ""
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.black,.red]), startPoint: .top, endPoint: .bottom)
                    .blur(radius: 40)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
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
                    
                    Text("v1.5")
                        .font(.headline)
                        .padding()
                    Text("Host Address:\(ipAddr.ipAddress)")
                        .font(.headline)
                        .padding()
                    HStack {
                        Button(action: {
           
                            self.showEngine = true
                            HapticFeedbackSelection.medium.trigger()
                        }){
                            Text("Update Engine")
                                .foregroundColor(.white)
                        }
                        Button(action: {
                             HapticFeedbackSelection.medium.trigger()

                             // Clear Kingfisher cache
                             ImageCache.default.clearCache {
                                 sendNotification(title: "Mikoshi->Host", subtitle: "", body:"Cache cleared!", id: "Mikoshi")
                             }
                        }){
                            Text("Clear Cache")
                                .foregroundColor(.white)
                        }
                        Button(action: {
   
                            self.showServer = true
                            HapticFeedbackSelection.medium.trigger()
                        }){
                            Text("Server Info")
                                .foregroundColor(.white)
                        }
                        TextField("Search engramm...", text: $filter)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                
                    }
                    List {
                        if let charData = charData {
                            ForEach(charData.indices, id: \.self) { index in
                                ForEach(charData[index].keys.sorted(), id: \.self) { key in
                                    if let value = charData[index][key] as? String,
                                       let imageURL = URL(string: value) {
                                        
                                        if filter.isEmpty || key.contains(filter) {
                                            createCharacterNavigationLink(imageURL: imageURL, key: key, ipAddress: ipAddress)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.black, .red]), startPoint: .top, endPoint: .bottom)
                            .blur(radius: 10)
                    )
                    .ignoresSafeArea()
                    .sheet(isPresented: $showEngine) {
                        NavigationView {
                            EngineView(ipAddress: ipAddress, logo: logo)
                                .navigationBarTitle("IP Address Entry")
                        }
                    }
                    .sheet(isPresented: $showServer) {
                        NavigationView {
                            ServerInfoScreen(ipAddress: ipAddress,logo: logo)
                        }
                    }
                    .onAppear {
                        DataEx().getJSON(ip: ipAddress, endp: "char_list") { result in
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
    
}
