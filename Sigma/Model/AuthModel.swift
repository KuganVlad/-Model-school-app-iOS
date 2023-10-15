//
//  AuthModel.swift
//  Sigma
//
//  Created by Vlad Kugan on 7.04.23.
//

import Foundation
import UIKit


class AuthApplication {
    typealias AuthApplicationCompletion = (([String:Any]?) -> Void)

    func authUsers(email: String, password: String, completion: AuthApplicationCompletion?) {
        let url = URL(string: "http://localhost/authentication-jwt/api/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("gzip;q=1.0, compress;q=0.5", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("en-US;q=0.8", forHTTPHeaderField: "Accept-Language")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("iOS", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("utf-8", forHTTPHeaderField: "Accept-Charset")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion?(nil)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        var arrResult: [String:Any] = [:]
                            
                        guard let jwtAuth = json["jwt"] as? String else {
                            print("Error: Failed to get JWT from JSON")
                            completion?(nil)
                            return
                        }
                        arrResult["jwt"] = jwtAuth
                            
                            
                        guard let idAuth = json["id"] as? Int else {
                            print("Error: Failed to get ID from JSON")
                            completion?(nil)
                            return
                        }
                        let idUserString = String(idAuth)
                        arrResult["id"] = idUserString
                            
                        guard let typeUser = json["type"] as? Int else {
                            print("Error: Failed to get user Type from JSON")
                            completion?(nil)
                            return
                        }
                        let typeUserString = String(typeUser)
                        arrResult["type"] = typeUserString
                            
                            
                        completion?(arrResult)
                        }else {
                        print("Failed to deserialize JSON")
                        completion?(nil)
                        }
                    } catch {
                        print(error.localizedDescription)
                        completion?(nil)
                    }
                } else {
                    print("Error: \(httpResponse.statusCode)")
                    completion?(nil)
                }
            }
        }
        task.resume()
    }
}
