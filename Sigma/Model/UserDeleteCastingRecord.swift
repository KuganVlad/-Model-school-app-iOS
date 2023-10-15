//
//  UserDeleteCastingRecord.swift
//  Sigma
//
//  Created by Vlad Kugan on 13.04.23.
//

import Foundation
import UIKit


class UserDeleteCastingRecord {
    typealias DeleteCastingRecordUserCompletion = ((String?) -> Void)

    func castingRecUser(id: String, completion: DeleteCastingRecordUserCompletion?) {
        let url = URL(string: "http://localhost/authentication-jwt/api/user_delete_casting.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "id": id,
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
                            let codeAuth = json["message"] as? String
                            completion?(codeAuth)
                        } else {
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

