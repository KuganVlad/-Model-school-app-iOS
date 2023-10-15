//
//  UserGetPhotoshoot.swift
//  Sigma
//
//  Created by Vlad Kugan on 15.04.23.
//

import Foundation
import UIKit


class UserGetPhotoshoot{
    typealias UserGetPhotoshootCompletion = (([[String:Any]]?) -> Void)

    func getPhotoshootUser(id: String, completion: UserGetPhotoshootCompletion?) {
        let url = URL(string: "http://localhost/authentication-jwt/api/get_user_photagraphy.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "id": id
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

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
                            var responseArray: [[String: Any]] = []
                            for (_, value) in json {
                                if let photoshootArr = value as? [String: Any] {
                                    responseArray.append(photoshootArr)
                                }
                            }
                            completion?(responseArray)
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

