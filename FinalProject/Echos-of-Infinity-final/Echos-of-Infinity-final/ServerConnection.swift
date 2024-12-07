//
//  ServerConnection.swift
//  The Echos of Infinity
//
//  Created by James Wang on 11/22/24.
//

import Foundation

class ServerConnection {
    static let shared = ServerConnection()
    
    let baseUrl: String?
    
    private init() {
        EnvLoader.load()
        baseUrl = ProcessInfo.processInfo.environment["API_BASE_URL"]
    }
    
    func serverConnection(payload: [String: Any], endpoint: String, completion: @escaping (String?) -> Void) {
        guard let baseUrl = baseUrl, let url = URL(string: "\(baseUrl)/\(endpoint)") else {
            print("Invalid base URL or endpoint")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: payload)
        URLSession.shared.uploadTask(with: request, from: jsonData) { data, _, error in
            if let error = error {
                print("Error sending data: \(error)")
                completion(nil)
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                completion(responseString)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
