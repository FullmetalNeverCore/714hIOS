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
    var logo = "https://i.imgur.com/zsk0v7O.png"
    @State private var isNextScreenActive: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var locIP: String = "Loading..."

    var body: some View {
        NavigationView {
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
                    print("Button Pressed!")
                    NetworkStuff().checkIP(ip: ipAddress) { success in
                        if success {
                            isNextScreenActive = true
                            print("Request was successful!")
                        } else {
                            alertMessage = "No route to server"
                            print("Request failed.")
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





struct NextScreen: View {
    var ipAddress: String
    var logo: String
    @State private var showSettings: Bool = false
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
                    VStack {
                        Button(action: {
                            print("Button Pressed!")
                            self.showSettings = true
                        }){
                            Text("Update NNVals")
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
                                                // Handle image click action here
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


struct UNNScreen:View{
    var ipAddress: String
    var logo: String
    
    @State private var updateInput1 = ""
    @State private var updateInput2 = ""
    @State private var updateInput3 = ""
    
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
                DataEx().sendnn(ip: ipAddress, d1: Float(updateInput1) ?? 0.9, d2: Float(updateInput2) ?? 0.75, d3: Float(updateInput3) ?? 0.35)
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.trailing)
        }
    }
    
}

struct CharacterScreen: View {
    var link: URL
    var name: String
    var ipAddress: String
    @State private var chatInput = ""
    @State private var updateInput1 = ""
    @State private var updateInput2 = ""
    @State private var updateInput3 = ""
    @State private var textContent = "Offline content"
    @Environment(\.presentationMode) var presentationMode
    @State private var timer: Timer.TimerPublisher?
    @State private var cancellable: AnyCancellable?
    @State private var msgData: [[String: Any]]?

    
    var body: some View {
        
        ZStack {
            // Background Image
            AsyncImage(url: link) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(Color.black.opacity(0.3))
                case .failure:
                    Text("Failed to load background image")
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
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
                        .foregroundColor(.blue)
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Adjust the height as needed
                        .disabled(true)
                }
                HStack {
                    TextField("Type your message...", text: $chatInput)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    Button("Send") {
                        print("Message sent: \(chatInput)")
                        DataEx().jsoCreate(ip:ipAddress,x: String(chatInput), y: "Mistral", z: "null", xn: "chat", xy: "type", xz: "null", endpoint: "chat_exchange")
                    }
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.trailing)
                }
                .padding(.bottom)
                
                // Updates Section
                .padding(.bottom)
            }
        }
        .onAppear(){
            DataEx().jsoCreate(ip:ipAddress,x: "N", y: "toor", z: name, xn: "username", xy: "password", xz: "char", endpoint: "verify_credentials")
        }
        .navigationBarHidden(true) 
        .navigationBarBackButtonHidden(true)
    }
    func startTimer() {
        timer = Timer.publish(every: 5, on: .main, in: .common)
        cancellable = timer?.autoconnect().sink { _ in
            DataEx().getChars(ip: ipAddress, endp: "msg_buffer") { result in
                switch result {
                case .success(let fdata):
                    // Print all keys and values in the dictionary for debugging
                    for (key, value) in fdata {
                        print("Key: \(key), Value: \(value)")
                    }
                    
                    
                    if let brValue = fdata["text"] as? [String] {
                        // Check if the array is not empty
                        if !brValue.isEmpty {
                            // Get the last element of the array
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


#Preview {
    ContentView()
}
