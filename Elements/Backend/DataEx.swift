//
//  DataEx.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 06/02/2024.
//

import Foundation


class DataEx
{
    func getPing(ip: String, endp: String,completion: @escaping (Result<String, Error>) -> Void) {
        var url = "http://\(ip)/\(endp)"
        print("Sending get request...")
        guard let requestURL = URL(string: url) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "HTTPError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])))
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                completion(.success(responseString))
            } else {
                completion(.failure(NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received or unable to parse data"])))
            }
        }.resume()
    }
    func getJSON(ip:String,endp:String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = URL(string: "http://\(ip)/\(endp)")!

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                do {
                    let decodedData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                    if let decodedData = decodedData {
//                        print(decodedData)
                        completion(.success(decodedData))
                    } else {
                        print("Failed to convert JSON data to dictionary.")
                        let decodingError = NSError(domain: "DecodingError", code: 0, userInfo: nil)
                        completion(.failure(decodingError))
                    }

                } catch {
                    print("Error decoding JSON data: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func jsoCreate(ip: String,x: String, y: String, z: String, xn: String, xy: String, xz: String, endpoint: String) {
        var xyz: [String: String] = [:]
        
        let tempx = [x, y, z]
        let tempy = [xn, xy, xz]
        
        for tx in 0..<tempx.count {
            if tempx[tx] != "null" {
                xyz[tempx[tx]] = tempy[tx]
            }
        }
        
        var json = [String: String]()
        
        for (key, value) in xyz {
//            print(key)
//            print(value)
            json[value] = key
        }
        
        print(json)
        
        chatEX(ip:ip, endpoint: endpoint, json: json)
    }

    func chatEX(ip:String,endpoint: String, json: [String: String]) {
        do {
            let engine = eng
//            print(engine)
//            print(String(format: "Engine: %@", engine))
            
            let urlString = String(format: "http://%@/%@", ip, endpoint)
            guard let url = URL(string: urlString) else {
                sendNotification(title: "Mikoshi->Host", subtitle: "", body:"Invalid URL", id: "Mikoshi")
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json; utf-8", forHTTPHeaderField: "Content-Type")
            
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let httpResponse = response as? HTTPURLResponse {
//                    sendNotification(title: "Mikoshi->Host", subtitle: "", body:"Host accepted the request.", id: "Mikoshi")
                    print("EXCHANGE_STATUS: \(httpResponse.statusCode)")
                }
                
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
            }
            
            task.resume()
            
        } catch {
            print("Error: \(error)")
        }
    }
    func sendnn(ip:String,d1: Float, d2: Float, d3: Float) {
        var xyz = [String: String]()
        xyz["rnd"] = String(d1)
        xyz["fpen"] = String(d2)
        xyz["ppen"] = String(d3)
        
        for x in ["rnd", "fpen", "ppen"] {
           
            DataEx().jsoCreate(ip:ip,x: String(xyz[x] ?? "???"), y: x, z: "null", xn: "val", xy: "type", xz: "null", endpoint: "nn_vals")
        }
    }
    
    func neofetch(ip: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://\(ip)/neofetch") else {
            sendNotification(title: "Mikoshi-Host", subtitle: "", body:"Invalid URL", id: "Mikoshi")
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        let session = URLSession.shared

        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 1, userInfo: nil)))
                return
            }

            if let resultString = String(data: data, encoding: .utf8) {
                completion(.success(resultString))
            } else {

                completion(.failure(NSError(domain: "Unable to convert data to string", code: 2, userInfo: nil)))
            }
        }
        task.resume()
    }
    

    struct MasterIPRequest: Codable {
        let ip: String
    }

    func sendDataToMasterIP(data: String) {
        // Ensure the endpoint URL is correct
        guard let url = URL(string: "http://192.168.8.149:5005/masterip") else {
            print("Invalid URL")
            return
        }
        
        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the data payload
        let payload = MasterIPRequest(ip: data)
        do {
            let jsonData = try JSONEncoder().encode(payload)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode JSON: \(error)")
            return
        }
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response here
            if let error = error {
                print("Error sending data: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server error")
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
        }
        task.resume()
    }


}
