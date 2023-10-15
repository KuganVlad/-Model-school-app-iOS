//
//  ProjectCreate.swift
//  Sigma
//
//  Created by Vlad Kugan on 17.04.23.
//

import Foundation
import UIKit


class ProjectCreate {
    typealias ProjectCreateCompletion = ((String?) -> Void)

    func projectCreate(data: [String: Any], completion: ProjectCreateCompletion?) {
        let url = URL(string: "http://localhost/authentication-jwt/api/create_project.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var parameters: [String: Any] = [
            "status": "1"
        ]

        if let name = data["name"] {
            parameters["name"] = name
        }else{
            parameters["name"] = ""
        }

        if let location = data["location"] {
            parameters["location"] = location
        }else{
            parameters["location"] = ""
        }

        if let date = data["date"] {
            parameters["date"] = date
        }else{
            parameters["date"] = ""
        }

        if let text = data["text"] {
            parameters["text"] = text
        }else{
            parameters["text"] = ""
        }

        if let fk_contact_custommer = data["fk_contact_custommer"] {
            parameters["fk_contact_custommer"] = fk_contact_custommer
        }

        if let fk_contact_director = data["fk_contact_director"] {
            parameters["fk_contact_director"] = fk_contact_director
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
