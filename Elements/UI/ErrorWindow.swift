//
//  ErrorWindow.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 12/05/2024.
//

import Foundation
import SwiftUI



struct ErrorWindow: View {
    var ipAddress:String
    @State private var Errormsg:String = "Test"
    @State private var InAPPError:String = ""
    
    var body:some View{
        VStack{
            Spacer()
            Text(InAPPError)
            Text("Error Window")
            
            ScrollView {
                if !Errormsg.isEmpty{
                    TextEditor(text: $Errormsg)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    else {
                        TextEditor(text: .constant("Currently there is no any error messages."))
                                .padding()
                                .background(Color.black.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                
            }
        }
        .onAppear {
            DataEx().getJSON(ip: ipAddress, endp: "api/errormsg") { result in
                switch result {
                case .success(let errmsg):
                    DispatchQueue.main.async {
                        if let errorMessage = errmsg["err"] as? String {
                            Errormsg = errorMessage
                            print(errorMessage)
                        } else {
                            Errormsg  = "Error message not found or is not a string"
                        }
                    }
                case .failure(let error):
                    InAPPError = error.localizedDescription
                    print("Error fetching ErrorLog: \(error)")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

}
