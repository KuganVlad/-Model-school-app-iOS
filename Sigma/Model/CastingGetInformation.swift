//
//  CastingGetInformation.swift
//  Sigma
//
//  Created by Vlad Kugan on 9.04.23.
//

import Foundation
import UIKit


class CastingGetInfo {
    typealias CastingInfoCompletion = (([[String:Any]]?) -> Void)

    func getInfoCasting(completion: CastingInfoCompletion?) {
        let url = URL(string: "http://localhost/authentication-jwt/api/get_casting_data.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [:] // здесь должны быть переданы параметры запроса
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
                                var responseArray: [[String: Any]] = []
                                for (_, value) in json {
                                    if let castingDict = value as? [String: Any] {
                                        responseArray.append(castingDict)
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
