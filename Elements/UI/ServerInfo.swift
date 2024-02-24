//
//  ServerInfo.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 13/02/2024.
//

import Foundation
import SwiftUI
import Kingfisher

struct ServerInfoScreen:View{
    var ipAddress: String
    var logo: String
    
    @State private var neofetch : String = ""
    
    
    
    
    var body: some View{
        NavigationView{
            
            ZStack {
                VStack {
                    
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
                .background(
                    LinearGradient(gradient: Gradient(colors: [.black, .black, Color(hex: 0xB30026)]), startPoint: .top, endPoint: .bottom)
                        .blur(radius: 80)
                        .ignoresSafeArea()
                )
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
        .navigationTitle("Server")
    }
    
}
