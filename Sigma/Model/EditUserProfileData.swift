//
//  EditUserProfileData.swift
//  Sigma
//
//  Created by Vlad Kugan on 10.04.23.
//

import Foundation


class EditUserProfileData {
    
    
    func buttonToTypeUser(typeUser: String) -> [String] {
        var userAttributesKeyArray: [String] = []
        switch typeUser {
        case "user":
            userAttributesKeyArray.append("Фамилия")
            userAttributesKeyArray.append("Имя")
            userAttributesKeyArray.append("Отчество")
            userAttributesKeyArray.append("Возраст")
            userAttributesKeyArray.append("Эл. почта")
            userAttributesKeyArray.append("Пароль")
            userAttributesKeyArray.append("Телефон")
            userAttributesKeyArray.append("Город")
            userAttributesKeyArray.append("Изображение")
            return userAttributesKeyArray
        case "student":
            userAttributesKeyArray.append("Фамилия")
            userAttributesKeyArray.append("Имя")
            userAttributesKeyArray.append("Отчество")
            userAttributesKeyArray.append("Возраст")
            userAttributesKeyArray.append("Эл. почта")
            userAttributesKeyArray.append("Пароль")
            userAttributesKeyArray.append("Телефон")
            userAttributesKeyArray.append("Город")
            userAttributesKeyArray.append("Изображение")
            return userAttributesKeyArray
        case "teacher":
            userAttributesKeyArray.append("Фамилия")
            userAttributesKeyArray.append("Имя")
            userAttributesKeyArray.append("Отчество")
            userAttributesKeyArray.append("Эл. почта")
            userAttributesKeyArray.append("Пароль")
            userAttributesKeyArray.append("Телефон")
            userAttributesKeyArray.append("Город")
            userAttributesKeyArray.append("Должность")
            userAttributesKeyArray.append("Изображение")
            return userAttributesKeyArray
        case "customer":
            userAttributesKeyArray.append("Фамилия")
            userAttributesKeyArray.append("Имя")
            userAttributesKeyArray.append("Отчество")
            userAttributesKeyArray.append("Возраст")
            userAttributesKeyArray.append("Эл. почта")
            userAttributesKeyArray.append("Пароль")
            userAttributesKeyArray.append("Телефон")
            userAttributesKeyArray.append("Город")
            userAttributesKeyArray.append("Изображение")
            userAttributesKeyArray.append("Организация")
            userAttributesKeyArray.append("Должность")
            return userAttributesKeyArray
        case "director":
            userAttributesKeyArray.append("Фамилия")
            userAttributesKeyArray.append("Имя")
            userAttributesKeyArray.append("Отчество")
            userAttributesKeyArray.append("Эл. почта")
            userAttributesKeyArray.append("Пароль")
            userAttributesKeyArray.append("Телефон")
            userAttributesKeyArray.append("Город")
            userAttributesKeyArray.append("Должность")
            userAttributesKeyArray.append("Изображение")
            return userAttributesKeyArray
        case "manager":
            userAttributesKeyArray.append("Фамилия")
            userAttributesKeyArray.append("Имя")
            userAttributesKeyArray.append("Отчество")
            userAttributesKeyArray.append("Эл. почта")
            userAttributesKeyArray.append("Пароль")
            userAttributesKeyArray.append("Телефон")
            userAttributesKeyArray.append("Город")
            userAttributesKeyArray.append("Должность")
            userAttributesKeyArray.append("Изображение")
            return userAttributesKeyArray
        default:
            userAttributesKeyArray.append("Фамилия")
            userAttributesKeyArray.append("Имя")
            userAttributesKeyArray.append("Отчество")
            userAttributesKeyArray.append("Возраст")
            userAttributesKeyArray.append("Эл. почта")
            userAttributesKeyArray.append("Пароль")
            userAttributesKeyArray.append("Телефон")
            userAttributesKeyArray.append("Город")
            userAttributesKeyArray.append("Изображение")
            return userAttributesKeyArray
        }
    }
}
