//
//  UserProfileViewControllerNames.swift
//  Sigma
//
//  Created by Vlad Kugan on 5.04.23.
//

import Foundation

enum typeUser:String {
    case user
    case student
    case teacher
    case customer
    case director
    case manager

    var label: String{
        switch self{
        case .user: return "user"
        case .student: return "student"
        case .teacher: return "teacher"
        case .customer: return "customer"
        case .director: return "director"
        case .manager: return "manager"
        }
    }
}

class UserProfileVC{
    
    func buttonToTypeUser(typeUser: String) -> [String] {
        var arr = [String]()
        switch typeUser {
        case "user":
            arr.append("CastingUserViewController")
            arr.append("ManagerUserViewController")
            arr.append("TeacherUserViewController")
            return arr
        case "student":
            arr.append("AttendaneceUserViewController")
            arr.append("ScheduleUserViewController")
            arr.append("PhotographyUserViewController")
            arr.append("TeacherUserViewController")
            arr.append("PayUserViewController")
            arr.append("ManagerUserViewController")
            arr.append("ProjectUserViewController")
            return arr
        case "teacher":
            arr.append("ScheduleUserViewController")
            arr.append("ProjectUserViewController")
            arr.append("TeacherUserViewController")
            arr.append("ManagerUserViewController")
            return arr
        case "customer":
            arr.append("ProjectDirectViewController")
            arr.append("PortfolioDirectViewController")
            arr.append("ManagerUserViewController")
            return arr
        case "director":
            //arr.append("ScheduleDirectViewController")
            //arr.append("PayDirectViewController")
            arr.append("TeacherDirectViewController")
            arr.append("ProjectDirectViewController")
            arr.append("PortfolioDirectViewController")
            //arr.append("PhotographyDirectViewController")
            //arr.append("CastingDirectViewController")
            arr.append("UsersDirectViewController")
            //arr.append("StartLearningUserViewController")
            //arr.append("ManagerUserViewController")
            return arr
        case "manager":
            //arr.append("ScheduleDirectViewController")
            //arr.append("PayDirectViewController")
            arr.append("TeacherDirectViewController")
            arr.append("ProjectDirectViewController")
            arr.append("PortfolioDirectViewController")
            //arr.append("PhotographyDirectViewController")
            //arr.append("CastingDirectViewController")
            arr.append("UsersDirectViewController")
            //arr.append("StartLearningDirectViewController")
            //arr.append("ManagerDirectViewController")
            return arr
        default:
            arr.append("CastingUserViewController")
            arr.append("ManagerUserViewController")
            arr.append("TeacherUserViewController")
            return arr
        }
    }
}

class ImageButtonClass{
    
    func imageToTypeUser(typeUser: String) -> [String] {
        var arr = [String]()
        switch typeUser {
        case "user":
            arr.append("CastingImageButton")
            arr.append("ManagerImageButton")
            arr.append("TeacherImageButton")
            return arr
        case "student":
            arr.append("AttedanceImmageButton")
            arr.append("ScheduleImageButton")
            arr.append("PhotographyImageButton")
            arr.append("TeacherImageButton")
            arr.append("PayImageButton")
            arr.append("ManagerForStudentButton")
            arr.append("ProjectImmageButton")
            return arr
        case "teacher":
            arr.append("ScheduleImageButton")
            arr.append("ProjectImmageButton")
            arr.append("TeacherImageButton")
            arr.append("ManagerImageButton")
            return arr
        case "customer":
            arr.append("ProjectImmageButton")
            arr.append("PortfolioImageButton")
            arr.append("ManagerImageButton")
            return arr
        case "director":
            //arr.append("ScheduleImageButton")
            //arr.append("PayImageButton")
            arr.append("TeacherImageButton")
            arr.append("ProjectImmageButton")
            arr.append("PortfolioImageButton")
            //arr.append("PhotographyImageButton")
            //arr.append("CastingImageButton")
            arr.append("GroupImageButton")
            //arr.append("StartLearningImageButton")
            //arr.append("ManagerImageButton")
            return arr
        case "manager":
            //arr.append("ScheduleImageButton")
            //arr.append("PayImageButton")
            arr.append("TeacherImageButton")
            arr.append("ProjectImmageButton")
            arr.append("PortfolioImageButton")
            //arr.append("PhotographyImageButton")
            //arr.append("CastingImageButton")
            arr.append("GroupImageButton")
            //arr.append("StartLearningImageButton")
            //arr.append("ManagerImageButton")
            return arr
        default:
            arr.append("CastingImageButton")
            arr.append("ManagerImageButton")
            arr.append("TeacherImageButton")
            return arr
        }
    }
}
