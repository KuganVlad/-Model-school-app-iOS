//
//  StudentListViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 18.04.23.
//

import UIKit

class StudentListViewController: UIViewController {
    var groupId:Int!
    
    var cityName:String!
    let getUserList =  GetStudentData()
    let getUserUpgradeList = GetUserListUpdate()
    let getUserDeleteList = GetUserListDelete()
    let getUserAddList = GetUserListAdd()
    var userIDList:String!
    
    var userListSortedArr: [[String: Any]] = []
    var userAddDict: [String: Any] = [:]
    
    @IBOutlet weak var addUserButton: UIButton!
    @IBOutlet weak var userTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
        
        // добавляем выполнение функции в группу
        group.enter()
        self.title = ""
        getDataUserList {
            // когда функция завершится, мы вызываем leave() для завершения группы
            group.leave()
        }
        group.notify(queue: .main) {
            self.userTable.delegate = self
            self.userTable.dataSource = self
            
            self.userTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    

    @IBAction func touchAddUserButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Добавить пользователя", message: "Введите новые данные пользователя", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Электронная почта"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Пароль"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Тип пользователя"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Фамилия"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Имя"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Отчество"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Возраст"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Организация"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Должность"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Должность"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Статус"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Кастинг"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Группа"
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { (action) in
            let email = alertController.textFields![0]
            let password = alertController.textFields![1]
            let type = alertController.textFields![2]
            let lname = alertController.textFields![3]
            let fname = alertController.textFields![4]
            let sname = alertController.textFields![5]
            let age = alertController.textFields![6]
            let org = alertController.textFields![7]
            let pos = alertController.textFields![8]
            let status = alertController.textFields![9]
            let casting = alertController.textFields![10]
            let group = alertController.textFields![11]
            
            guard let email = email.text, !email.isEmpty,
                  let password = password.text, !password.isEmpty,
                  let type = type.text, !type.isEmpty
                        else {
                self.showAlertProjectAddError()
                return
            }
                
            self.userAddDict["email"] = email
            self.userAddDict["password"] = password
            self.userAddDict["type_user"] = type
            self.userAddDict["last_name"] = lname.text
            self.userAddDict["first_name"] = fname.text
            self.userAddDict["sur_name"] = sname.text
            self.userAddDict["age"] = age.text
            self.userAddDict["organization"] = org.text
            self.userAddDict["position"] = pos.text
            self.userAddDict["status_account"] = status.text
            self.userAddDict["casting"] = casting.text
            self.userAddDict["group"] = group.text
                
                
                do {
                    self.getUserAddList.userListAdd(data: self.userAddDict) { responseString in
                        if let result = responseString, !result.isEmpty {
                            DispatchQueue.main.async {
                                self.showAlertProjectAddComplete()
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showAlertProjectAddError()
                            }
                        }
                    }
                }
            }
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            
            self.present(alertController, animated: true, completion: nil)
    }
    
    func getDataUserList(completion: @escaping () -> Void){
        getUserList.getStudentData(id: String(groupId)){ responseArray in
            if let userListArr = responseArray {
                self.userListSortedArr = userListArr
                completion()
            }else{
                self.showAlertUserListError()
            }
        }
    }
    
    
    private func showAlertUserListError(){
        let alert = UIAlertController(title: "Уведомление!", message: "Невозможно отобразить пользователей", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    private func showAlertProjectError(){
        let alert = UIAlertController(title: "Уведомление!", message: "Невозможно удалить запись", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showAlertProjectAddError(){
        let alert = UIAlertController(title: "Уведомление!", message: "Невозможно создать запись! Заполните все поля", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showAlertProjectAddComplete(){
        let alert = UIAlertController(title: "Уведомление!", message: "Запись успешно добавлена и будет отображена при повторном доступе к проектам", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showAlertProjectUpdateError(){
        let alert = UIAlertController(title: "Уведомление!", message: "Невозможно обновить запись!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showAlertProjectUpdateComplete(){
        let alert = UIAlertController(title: "Уведомление!", message: "Запись успешно обновлена и будет отображена при повторном доступе к проектам", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension StudentListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userListSortedArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        cell.textLabel?.numberOfLines = 10
        let projectData = userListSortedArr[indexPath.item]
        
        
        let attributedText = NSMutableAttributedString()
        
        if let email = projectData["email"] as? String {
            attributedText.append(NSAttributedString(string: "\(email)\n"))
        }
        if let lname = projectData["lname"] as? String {
            attributedText.append(NSAttributedString(string: "\(lname) "))
        }
        if let fname = projectData["fname"] as? String {
            attributedText.append(NSAttributedString(string: "\(fname)\n"))
        }
        if let sname = projectData["sname"] as? String {
            attributedText.append(NSAttributedString(string: "\(sname)\n"))
        }
        if let phone = projectData["phone"] as? String {
            attributedText.append(NSAttributedString(string: "\(phone)\n"))
        }
        if let city = projectData["city"] as? Int {
            switch city {
            case 24:
                self.cityName = "Мозырь"
            case 23:
                self.cityName = "Могилев"
            case 22:
                self.cityName = "Минск"
            case 21:
                self.cityName = "Гродно"
            case 20:
                self.cityName = "Гомель"
            case 19:
                self.cityName = "Витебск"
            case 18:
                self.cityName = "Брест"
            case 17:
                self.cityName = "Барановичи"
            default:
                self.cityName = "Неизвестный город"
            }
            attributedText.append(NSAttributedString(string: "\(self.cityName ?? "Неизвестный город")"))
        } else {
            self.cityName = "Неизвестный город"
            attributedText.append(NSAttributedString(string: "\(self.cityName ?? "Неизвестный город")"))
        }

        
        
        
        cell.textLabel?.layer.borderWidth = 2
        cell.textLabel?.layer.cornerRadius = 20
        cell.textLabel?.layer.masksToBounds = true
        if (indexPath.row % 2 == 0){
            cell.textLabel?.backgroundColor = .black
            cell.textLabel?.layer.borderColor = UIColor.white.cgColor
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedText.length))
        }else{
            cell.textLabel?.layer.borderColor = UIColor.black.cgColor
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: attributedText.length))
        }
        
        cell.textLabel?.attributedText = attributedText
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let projectData = userListSortedArr[indexPath.item]
        let text = "\(projectData["email"] as? String ?? "")\n\(projectData["lname"] as? String ?? "") \(projectData["fname"] as? String ?? "")\n\(projectData["sname"] as? String ?? "")\n\(projectData["phone"] as? String ?? "")\n\(self.cityName ?? "Неизвестный город"))"
        
        let font = UIFont.systemFont(ofSize: 17) // задайте необходимый шрифт
        let size = CGSize(width: tableView.frame.width - 32, height: .infinity) // 32 - это расстояние между ячейкой и границей таблицы. Размер по ширине должен быть равен ширине таблицы.
        let estimatedSize = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return estimatedSize.height + 32 // 32 - это отступ сверху и снизу текста в ячейке
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //свайп влево
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let projectData = userListSortedArr[indexPath.item]
            if let id = projectData["id"] as? Int{
                self.userIDList = String(id)
                getUserDeleteList.getUserListDelete(id: self.userIDList){ result in
                    if result != nil {
                        // Удаляем элемент из массива данных
                        self.userListSortedArr.remove(at: indexPath.item)
                        // Удаляем соответствующую ячейку из таблицы
                        DispatchQueue.main.async {
                            tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                    } else {
                        self.showAlertProjectError()
                    }
                }
            } else {
                self.showAlertProjectError()
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var projectData = userListSortedArr[indexPath.item]
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            
            let alertController = UIAlertController(title: "Изменить пользователя", message: "Введите новые данные пользователя", preferredStyle: .alert)
            
            alertController.addTextField { (textField) in
                textField.placeholder = "Электронная почта"
                textField.text = projectData["email"] as? String
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Пароль"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Тип пользователя"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Фамилия"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Имя"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Отчество"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Возраст"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Организация"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Должность"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Должность"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Статус"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Кастинг"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Группа"
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                completionHandler(false)
            }
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
                let email = alertController.textFields![0]
                let password = alertController.textFields![1]
                let type = alertController.textFields![2]
                let lname = alertController.textFields![3]
                let fname = alertController.textFields![4]
                let sname = alertController.textFields![5]
                let age = alertController.textFields![6]
                let org = alertController.textFields![7]
                let pos = alertController.textFields![8]
                let status = alertController.textFields![9]
                let casting = alertController.textFields![10]
                let group = alertController.textFields![11]
                self.userIDList = projectData["id"] as? String
                projectData["email"] = email.text ?? ""
                projectData["password"] = password.text ?? ""
                projectData["type_user"] = type.text ?? ""
                projectData["last_name"] = lname.text ?? ""
                projectData["first_name"] = fname.text ?? ""
                projectData["sur_name"] = sname.text ?? ""
                projectData["age"] = age.text ?? ""
                projectData["organization"] = org.text ?? ""
                projectData["position"] = pos.text ?? ""
                projectData["status_account"] = status.text ?? ""
                projectData["casting"] = casting.text ?? ""
                projectData["group"] = group.text ?? ""
                
                
                do {
                    self.getUserUpgradeList.getUserListUpdate(data: projectData){ responseString in
                        if let result = responseString, !result.isEmpty {
                            DispatchQueue.main.async {
                                self.showAlertProjectUpdateComplete()
                                tableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showAlertProjectUpdateError()
                            }
                        }
                        
                    }
                    
                }
                completionHandler(true)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        editAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
       
    
}
