//
//  DataEx.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 06/02/2024.
//

import Foundation


class DataEx
{
    func getJSON(ip:String,endp:String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = URL(string: "http://\(ip):5001/\(endp)")!

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
        
        chatEX(ip:ip, endpoint: endpoint, json: json)
    }

    func chatEX(ip:String,endpoint: String, json: [String: String]) {
        do {
            let engine = eng
//            print(engine)
//            print(String(format: "Engine: %@", engine))
            
            let urlString = String(format: "http://%@:5001/%@", ip, endpoint) 
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
                    sendNotification(title: "Mikoshi->Host", subtitle: "", body:"Host accepted the request.", id: "Mikoshi")
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
        guard let url = URL(string: "http://\(ip):5001/neofetch") else {
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

}
