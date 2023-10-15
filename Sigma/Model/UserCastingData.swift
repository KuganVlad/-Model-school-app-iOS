//
//  UserCastingData.swift
//  Sigma
//
//  Created by Vlad Kugan on 13.04.23.
//

import Foundation
import UIKit


class UserCastingData {
    typealias UserCastingDataCompletion = (([String:Any]?) -> Void)

    func getUserCastingData(id: String, completion: UserCastingDataCompletion?) {
        let url = URL(string: "http://localhost/authentication-jwt/api/get_user_casting_info.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "id": id] // здесь должны быть переданы параметры запроса
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
                                print(json)
                                var responseArray: [String: Any] = [:]
                                var dataCity = "Неизвестный город"
                                for (key, value) in json {
                                    if let stringValue = value as? String {
                                        responseArray[key] = stringValue
                                    } else if key == "city", let intValue = value as? Int {
                                        switch intValue {
                                        case 24:
                                            dataCity = "Мозырь"
                                        case 23:
                                            dataCity = "Могилев"
                                        case 22:
                                            dataCity = "Минск"
                                        case 21:
                                            dataCity = "Гродно"
                                        case 20:
                                            dataCity = "Гомель"
                                        case 19:
                                            dataCity = "Витебск"
                                        case 18:
                                            dataCity = "Брест"
                                        case 17:
                                            dataCity = "Барановичи"
                                        default:
                                            dataCity = "Неизвестный город"
                                        }
                                        responseArray[key] = dataCity
                                    } else {
                                        responseArray[key] = value
                                    }
                                }
                                completion?(responseArray)
                            }
else {
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
