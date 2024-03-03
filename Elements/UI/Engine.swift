//
//  Engine.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 12/02/2024.
//

import Foundation
import SwiftUI

struct EngineView: View {
    var ipAddress: String
    var logo : String

    @State private var selectedOption: RadioButtonSelection?
    
    // Enum to represent the selection state of the radio buttons
    enum RadioButtonSelection: String, CaseIterable {
        case option1 = "Mistral"
        case option2 = "gpt-3.5-turbo"
        case option3 = "gpt3"
    }
    
    @State private var updateInput1 = ""
    @State private var updateInput2 = ""
    @State private var updateInput3 = ""

    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    
                    EngineRadioButton(label: .option1, isSelected: $selectedOption)
                    EngineRadioButton(label: .option2, isSelected: $selectedOption)
                    EngineRadioButton(label: .option3, isSelected: $selectedOption)
                    
                    
                    Button("Submit") {
                        
                        if let selectedOption = selectedOption {
                            print("Selected option: \(selectedOption.rawValue)")
                            HapticFeedbackSelection.heavy.trigger()
                            sendNotification(title: "Mikoshi->Host", subtitle: "", body:"Engine has been updated", id: "Mikoshi")
                            changeEngine(engine: String(selectedOption.rawValue))
                            
                        } else {
                            print("Please select an option before submitting.")
                        }
                    }
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    TextField("1.0", text: $updateInput1)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.trailing)
                    
                    TextField("1.0", text: $updateInput2)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.trailing)
                    
                    TextField("1.0", text: $updateInput3)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.trailing)
                    
                    Button("Update") {
                        print("Update 3: \(updateInput1) \(updateInput2) \(updateInput3)")
                        HapticFeedbackSelection.heavy.trigger()
                        sendNotification(title: "Mikoshi->Host", subtitle: "", body:"NN values has been updated!", id: "Mikoshi")
                        DataEx().sendnn(ip: ipAddress, d1: Float(updateInput1) ?? 0.9, d2: Float(updateInput2) ?? 0.75, d3: Float(updateInput3) ?? 0.35)
                    }
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.trailing)
                    
                    //                Button(action: {
                    //                    print("\(eng)")
                    //                }){
                    //                    Text("Test")
                    //                }
                    // Radio buttons

                }
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [.black, .black, Color(hex: 0xB30026)]), startPoint: .top, endPoint: .bottom)
                        .blur(radius: 80)
                        .ignoresSafeArea()
                )
                
                
            }
        }
        .navigationTitle("Engine")
    }
}

struct EngineRadioButton: View {
    let label: EngineView.RadioButtonSelection
    @Binding var isSelected: EngineView.RadioButtonSelection?

    var body: some View {
        HStack {
            Text(label.rawValue)
                .foregroundColor(.white)
            Spacer()
            Image(systemName: isSelected == label ? "largecircle.fill.circle" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
                .onTapGesture {
                    isSelected = label
                }
        }
        .padding()
    }
}

//DEPRECATED
//struct UNNScreen:View{
//    var ipAddress: String
//    var logo: String
//    
//    @State private var updateInput1 = ""
//    @State private var updateInput2 = ""
//    @State private var updateInput3 = ""
//    
//    
//    var body: some View{
//        ZStack {
//            LinearGradient(gradient: Gradient(colors: [.black, .black,.red]), startPoint: .top, endPoint: .bottom)
//                .blur(radius: 80)
//                .ignoresSafeArea()
//            VStack {
//                TextField("1.0", text: $updateInput1)
//                    .padding()
//                    .background(Color.black.opacity(0.8))
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//                
//                
//                    .padding()
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .padding(.trailing)
//                
//                TextField("1.0", text: $updateInput2)
//                    .padding()
//                    .background(Color.black.opacity(0.8))
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//                
//                
//                    .padding()
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .padding(.trailing)
//                
//                TextField("1.0", text: $updateInput3)
//                    .padding()
//                    .background(Color.black.opacity(0.8))
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//                
//                
//                    .padding()
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .padding(.trailing)
//                
//                Button("Update") {
//                    print("Update 3: \(updateInput1) \(updateInput2) \(updateInput3)")
//                    DataEx().sendnn(ip: ipAddress, d1: Float(updateInput1) ?? 0.9, d2: Float(updateInput2) ?? 0.75, d3: Float(updateInput3) ?? 0.35)
//                }
//                .padding()
//                .background(Color.black)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//                .padding(.trailing)
//            }
//        }
//        
//    }
//    
//}


