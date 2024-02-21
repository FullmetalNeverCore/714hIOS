//
//  Character.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 12/02/2024.
//

import Foundation
import SwiftUI
import Combine
import Kingfisher

struct CharacterScreen: View {
    var link: URL
    var name: String
    var ipAddress: String
    
    @State private var showBrain : Bool = false
    @State private var chatInput = ""
    @State private var events:String = ""
    @State private var dcopy : String = ""
    @State private var textContent = "Offline content"
    
    @Environment(\.presentationMode) var presentationMode
    @State private var timer: Timer.TimerPublisher?
    @State private var cancellable: AnyCancellable?
    @State private var msgData: [[String: Any]]?

    
    var body: some View {
        
        ZStack {
            // Background Image
            KFImage(link)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .navigationTitle("\(name)")
            .onAppear {
                startTimer()
            }
            .onDisappear {
                cancellable?.cancel()
            }
            
            // Chat Box
            VStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.title)
                }
                Spacer()
                ScrollView {
                    TextEditor(text: $textContent)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .disabled(true)

                }
                VStack{
                    TextField("Type your message...", text: $chatInput)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                HStack {
                    
                    Button("Send") {
//                        print("Message sent: \(chatInput)")
                        HapticFeedbackSelection.heavy.trigger()
                        DataEx().jsoCreate(ip:ipAddress,x: String(chatInput), y: "Mistral", z: "null", xn: "chat", xy: "type", xz: "null", endpoint: "chat_exchange")
                    }
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.trailing)
                    Button(action: {
//                        print("Button Pressed!")
                        self.showBrain = true
                        HapticFeedbackSelection.medium.trigger()
                    }){
                        Text("Overwrite")
                    }
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.red)
                    .cornerRadius(10)
                    .padding(.trailing)
                }
                .padding(.bottom)
            }
        }
        .onAppear(){
            DataEx().jsoCreate(ip:ipAddress,x: "N", y: "toor", z: name, xn: "username", xy: "password", xz: "char", endpoint: "verify_credentials")
        }
        .sheet(isPresented: $showBrain) {
            CharacterMemory(name:name,ipAddress:ipAddress,event:$events)
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    func startTimer() {
        timer = Timer.publish(every: 2, on: .main, in: .common)
        cancellable = timer?.autoconnect().sink { _ in
            DataEx().getJSON(ip: ipAddress, endp: "msg_buffer") { result in
                switch result {
                case .success(let fdata):
                    // Print all keys and values in the dictionary for debugging
//                    for (key, value) in fdata {
//                        print("Key: \(key), Value: \(value)")
//                    }
                    // Check if the array is not empty
                    // Get the last element of the array
                    if let brValue = fdata["br"] {
                        if let event = brValue as? String {
                
                            events = event
                        } else if let eventArray = brValue as? [String] {
                          
                            if !eventArray.isEmpty {
                                events = "\(eventArray)"
                            } else {
                                events = "Event!"
                            }
                        } else {
                     
                            print("Error: The value associated with 'br' is of type \(type(of: brValue)), expected String or [String].")
                        }
                    } else {
                
                        print("Error: Key 'br' not found in the dictionary.")
                    }

                    if let brValue = fdata["text"] as? [String] {
                    
                        if !brValue.isEmpty {
                            
                            let lastElement = brValue.last!
                            textContent = "\(name): \(lastElement)"
                        } else {
                            print("The array is empty.")
                        }
                    } else {
                        print("Error: Key 'text' not found in the dictionary or not an array of strings.")
                    }
                case .failure(let error):
                    print("Error fetching charData: \(error)")
                }
            }
        }
    }

}

struct CharacterMemory: View {
    var name: String
    var ipAddress: String
    @Binding var event: String
    
    @State private var ev:String = ""
    
    var body:some View{
        VStack{
            Spacer()
            Text("\(name)'s memory")
            ScrollView {
                TextEditor(text: $ev)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            Button(action: {
//                print("Overwriting...")
                //to be continued
                HapticFeedbackSelection.heavy.trigger()
                DataEx().jsoCreate(ip:ipAddress,x: "brain", y: String(ev), z: "null", xn: "type", xy: "data", xz: "null", endpoint: "upload_stuff")
                    
            }) {
                Text("Submit")
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)
            }
        }
        .onAppear(){
            self.ev = event
        }
    }

}
