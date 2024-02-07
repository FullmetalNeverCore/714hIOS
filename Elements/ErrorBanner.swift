//
//  ErrorBanner.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 07/02/2024.
//

import Foundation


class ErrorBanner{
    func checkIP(ip: String, completion: @escaping (Bool) -> Void) {
        let endpointURL = URL(string: "http://\(ip):5001/char_list")!

        var request = URLRequest(url: endpointURL)
        
        request.httpMethod = "GET"
        request.timeoutInterval = 3

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("No HTTP response")
                completion(false)
                return
            }

            if httpResponse.statusCode == 200 {
                print("Request successful! Do something here.")
                completion(true)
            } else {
                print("Error: HTTP status code \(httpResponse.statusCode)")
                completion(false)
            }
        }

        task.resume()
    }
}
