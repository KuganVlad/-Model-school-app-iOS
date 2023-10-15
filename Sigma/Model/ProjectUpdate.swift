//
//  ProjectUpdate.swift
//  Sigma
//
//  Created by Vlad Kugan on 17.04.23.
//

import Foundation
import UIKit


class ProjectUpdate {
    typealias ProjectUpdateCompletion = ((String?) -> Void)

    func projectUpdate(data: [String: Any], completion: ProjectUpdateCompletion?) {
        let url = URL(string: "http://localhost/authentication-jwt/api/project_update.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var parameters: [String: Any] = [:]
        if let id = data["id"] {
            parameters["id"] = id
        }

        if let name = data["name"] {
            parameters["name"] = name
        }

        if let location = data["location"] {
            parameters["location"] = location
        }

        if let date = data["date"] {
            parameters["date"] = date
        }

        if let text = data["text"] {
            parameters["text"] = text
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
