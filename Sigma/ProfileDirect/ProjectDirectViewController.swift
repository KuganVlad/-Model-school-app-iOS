//
//  ProjectDirectViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 31.03.23.
//

import UIKit

class ProjectDirectViewController: UIViewController {
    var userID:String!
    var userDataType:String!
    let getUserProject = UserGetProject()
    let projectCreate = ProjectCreate()
    let projectUpdate = ProjectUpdate()
    let projectDelete = ProjectDelete()
    var projectSortedArr: [[String: Any]] = []
    var projectAddDict: [String: Any] = [:]
    var projetcId:String!
    
    @IBOutlet weak var addProjectButton: UIButton!
    @IBOutlet weak var projectTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
        
        // добавляем выполнение функции в группу
        group.enter()
        self.title = ""
        getDataProject {
            // когда функция завершится, мы вызываем leave() для завершения группы
            group.leave()
        }
        group.notify(queue: .main) {
            self.projectTableView.delegate = self
            self.projectTableView.dataSource = self
            
            
            self.userDataType =  UserDefaults.standard.object(forKey: "userType") as? String
            
            self.projectTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    
    @IBAction func touchAddProjectButton(_ sender: UIButton) {
        
        
        let alertController = UIAlertController(title: "Изменить проект", message: "Введите новые данные проекта", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Имя проекта"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Место проведения"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Дата проведения"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Описание"
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { (action) in
            let nameTextField  = alertController.textFields![0]
            let locationTextField = alertController.textFields![1]
            let dateTextField = alertController.textFields![2]
            let textTextField = alertController.textFields![3]
            
            guard let name = nameTextField.text, !name.isEmpty,
                  let location = locationTextField.text, !location.isEmpty,
                  let date = dateTextField.text, !date.isEmpty,
                  let text = textTextField.text, !text.isEmpty else {
                self.showAlertProjectAddError()
                return
            }
            
            self.projectAddDict["name"] = name
            self.projectAddDict["location"] = location
            self.projectAddDict["date"] = date
            self.projectAddDict["text"] = text
            
            if (self.userDataType == typeUser.director.label || self.userDataType == typeUser.manager.label){
                self.projectAddDict["fk_contact_director"] = self.userID
            }else{
                self.projectAddDict["fk_contact_custommer"] = self.userID
            }
            do {
                self.projectCreate.projectCreate(data: self.projectAddDict){ responseString in
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




    
    func getDataProject(completion: @escaping () -> Void){
        getUserProject.getProjectUser(){ responseArray in
            if let projectArr = responseArray {
                self.userID = UserDefaults.standard.object(forKey: "userID") as? String
                let filteredProjects = projectArr.filter {
                    if let id_cust = $0["id_cust"] as? Int, id_cust == Int(self.userID) {
                         return true
                     }
                    if let id_dir = $0["id_dir"] as? Int, id_dir == Int(self.userID) {
                         return true
                     }
                     return false
                 }
                self.projectSortedArr = filteredProjects
                completion()
            }
        }
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


extension ProjectDirectViewController: UITableViewDelegate, UITableViewDataSource {
    //количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectSortedArr.count
    }
    
    //заполнение ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        cell.textLabel?.numberOfLines = 10
        let projectData = projectSortedArr[indexPath.item]


        let attributedText = NSMutableAttributedString()

        if let name = projectData["name"] as? String {
            attributedText.append(NSAttributedString(string: "\(name)\n"))
        }
        if let location = projectData["location"] as? String {
            attributedText.append(NSAttributedString(string: "\(location)\n"))
        }
        if let date = projectData["date"] as? String {
            attributedText.append(NSAttributedString(string: "\(date)\n"))
        }
        if let projectText = projectData["text"] as? String {
            attributedText.append(NSAttributedString(string: "\(projectText)\n"))
        }
        if let textUser = projectData["text_user"] as? String {
            attributedText.append(NSAttributedString(string: "\(textUser)\n"))
        }
        if let contact = projectData["contact"] as? String {
            attributedText.append(NSAttributedString(string: "\(contact)"))
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
        let projectData = projectSortedArr[indexPath.item]
        let text = "\(projectData["name"] as? String ?? "")\n\(projectData["location"] as? String ?? "")\n\(projectData["date"] as? String ?? "")\n\(projectData["text"] as? String ?? "")\n\(projectData["text_user"] as? String ?? "")\n\(projectData["contact"] as? String ?? "")"
        
        let font = UIFont.systemFont(ofSize: 17) // задайте необходимый шрифт
        let size = CGSize(width: tableView.frame.width - 32, height: .infinity) // 32 - это расстояние между ячейкой и границей таблицы. Размер по ширине должен быть равен ширине таблицы.
        let estimatedSize = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return estimatedSize.height + 32 // 32 - это отступ сверху и снизу текста в ячейке
    }
    
    
    //изменение ячейки
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //свайп влево
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let projectData = projectSortedArr[indexPath.item]
            if let id = projectData["id"] as? Int{
                self.projetcId = String(id)
                projectDelete.projectDelete(id: self.projetcId){ result in
                    if result != nil {
                        // Удаляем элемент из массива данных
                        self.projectSortedArr.remove(at: indexPath.item)
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


    //свайп вправо
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var projectData = projectSortedArr[indexPath.item]
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            
            let alertController = UIAlertController(title: "Изменить проект", message: "Введите новые данные проекта", preferredStyle: .alert)
            
            alertController.addTextField { (textField) in
                textField.placeholder = "Имя проекта"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Место проведения"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Дата проведения"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Описание"
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                completionHandler(false)
            }
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
                let nameTextField = alertController.textFields![0]
                let locationTextField = alertController.textFields![1]
                let dateTextField = alertController.textFields![2]
                let textTextField = alertController.textFields![3]
                self.projetcId = projectData["id"] as? String
                projectData["name"] = nameTextField.text ?? ""
                projectData["location"] = locationTextField.text ?? ""
                projectData["date"] = dateTextField.text ?? ""
                projectData["text"] = textTextField.text ?? ""
                
                do {
                    self.projectUpdate.projectUpdate(data: projectData){ responseString in
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
