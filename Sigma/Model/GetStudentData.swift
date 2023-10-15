//
//  GetStudentData.swift
//  Sigma
//
//  Created by Vlad Kugan on 18.04.23.
//

import Foundation
import UIKit


class GetStudentData {
    typealias GetStudentDataCompletion = (([[String:Any]]?) -> Void)

    func getStudentData(id: String, completion: GetStudentDataCompletion?) {
        let url = URL(string: "http://localhost/authentication-jwt/api/get_list_group.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["id":id]
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
                                if let userListArr = value as? [String: Any] {
                                    responseArray.append(userListArr)
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

