//
//  TeacherGetSchedule.swift
//  Sigma
//
//  Created by Vlad Kugan on 18.04.23.
//

import Foundation
import UIKit


class TeacherGetSchedule {
    typealias TeacherGetScheduleCompletion = (([[String:Any]]?) -> Void)

    func getScheduleTeacher(id: String, completion: TeacherGetScheduleCompletion?) {
        let url = URL(string: "http://localhost/authentication-jwt/api/get_teacher_schedule.php")!
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
                            var responseArray: [[String: Any]] = []
                            for (_, value) in json {
                                if let scheduleArr = value as? [String: Any] {
                                    responseArray.append(scheduleArr)
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

