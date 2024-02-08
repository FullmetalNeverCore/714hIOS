//
//  ErrorBanner.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 07/02/2024.
//

import Foundation
import Network

class NetworkStuff{
    
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
    
    
    func getLocalIPAddress(completion: @escaping (String?) -> Void) {
        var ipAddress: String?

        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if let interface = path.availableInterfaces.first {
                let interfaceName = interface.name
                ipAddress = self.getIPAddress(for: interfaceName)
                print("Local IP Address: \(ipAddress ?? "Not available")")
            }

            DispatchQueue.main.async {
                completion(ipAddress)
            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func getIPAddress(for interface: String) -> String? {
        var address: String?
        
        // Get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // Iterate through the list of interfaces
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interfaceName = String(cString: ifptr.pointee.ifa_name)
            
            if interfaceName == interface {
                let addrFamily = ifptr.pointee.ifa_addr.pointee.sa_family
                if addrFamily == AF_INET || addrFamily == AF_INET6 {
                    
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(ifptr.pointee.ifa_addr, socklen_t(ifptr.pointee.ifa_addr.pointee.sa_len),
                                    &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        address = String(cString: hostname)
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return address
    }
}
