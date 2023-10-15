//
//  getUserListAdd.swift
//  Sigma
//
//  Created by Vlad Kugan on 18.04.23.
//

import Foundation
import UIKit


class GetUserListAdd {
    typealias GetUserListAddCompletion = ((String?) -> Void)

    func userListAdd(data: [String: Any], completion: GetUserListAddCompletion?) {
        let url = URL(string: "http://localhost/authentication-jwt/api/get_manager_user_add.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var parameters: [String: Any] = [:]
        if let email = data["email"] {
            parameters["email"] = email
        }
        if let password = data["password"] {
            parameters["password"] = password
        }
        if let type_user = data["type_user"] {
            parameters["type_user"] = type_user
        }
        if let last_name = data["last_name"] {
            parameters["last_name"] = last_name
        }
        if let first_name = data["first_name"] {
            parameters["first_name"] = first_name
        }
        if let sur_name = data["sur_name"] {
            parameters["sur_name"] = sur_name
        }
        if let age = data["age"] {
            parameters["age"] = age
        }
        if let organization = data["organization"] {
            parameters["organization"] = organization
        }
        if let position = data["position"] {
            parameters["position"] = position
        }
        if let status_account = data["status_account"] {
            parameters["status_account"] = status_account
        }
        if let casting = data["casting"] {
            parameters["casting"] = casting
        }
        if let group = data["group"] {
            parameters["group"] = group
        }
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
                            guard let result = json["message"] as? String else {
                                return
                            }
                            completion?(result)
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
