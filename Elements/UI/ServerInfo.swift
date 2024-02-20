//
//  ServerInfo.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 13/02/2024.
//

import Foundation
import SwiftUI

struct ServerInfoScreen:View{
    var ipAddress: String
    var logo: String
    
    @State private var neofetch : String = ""
    
    
    
    
    var body: some View{
        
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
            
            ScrollView {
                TextEditor(text: $neofetch)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .disabled(true)
                    .font(Font.system(size: 10)) 

            }
            
        }
        .onAppear()
        {
            DataEx().neofetch(ip:ipAddress) { result in
                switch result {
                case .success(let responseString):
                    self.neofetch = responseString
                case .failure(let error):
             
                    self.neofetch = "Error: \(error.localizedDescription)"
                }
            }
        }
        
    }
}
