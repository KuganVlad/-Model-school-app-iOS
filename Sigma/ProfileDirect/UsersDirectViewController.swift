//
//  UsersDirectViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 31.03.23.
//

import UIKit

class UsersDirectViewController: UIViewController {

    let getFilialList = FilialGetList()
    var filialID:Int!
    var filialSortedArr: [[String: Any]] = []
    
    @IBOutlet weak var filialDataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
        
        // добавляем выполнение функции в группу
        group.enter()
        self.title = ""
        getFilialData {
            // когда функция завершится, мы вызываем leave() для завершения группы
            group.leave()
        }
        group.notify(queue: .main) {
            self.filialDataTableView.delegate = self
            self.filialDataTableView.dataSource = self
            
            self.filialDataTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }

    func getFilialData(completion: @escaping () -> Void){
        getFilialList.getFilial(){ responseArray in
            if let filialArr = responseArray {
                self.filialSortedArr = filialArr
                completion()
            }else{
                self.showAlertFilialError()
            }
        }
    }

    private func showAlertFilialError(){
        let alert = UIAlertController(title: "Уведомление!", message: "Невозможно получить список филиалов", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

}

extension UsersDirectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            // первая секция для Пользователей
            return "Пользователи"
        } else {
            // вторая секция для Филиалов
            return "Филиалы"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // первая секция для Пользователей
            return 1
        } else {
            // вторая секция для Филиалов
            return filialSortedArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            // первая секция для Пользователей
            cell.textLabel?.text = "Список пользователей"
            
        } else {
            // вторая секция для Филиалов
            let filial = filialSortedArr[indexPath.row]
            self.filialID = filial["id"] as? Int
            let name = filial["name"] as? String ?? "Нет данных о названии"
            let adress = filial["adress"] as? String ?? "Нет данных об адресе"
            let director = filial["director"] as? String ?? "Нет данных о директоре"
            cell.textLabel?.text = "\(name)\n\(adress)\n\(director)"
            cell.textLabel?.numberOfLines = 5
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let filial = filialSortedArr[indexPath.row]
        if indexPath.section == 0 {
            let text = "Список пользователей"
            
            let font = UIFont.systemFont(ofSize: 17) // задайте необходимый шрифт
            let size = CGSize(width: tableView.frame.width - 32, height: .infinity) // 32 - это расстояние между ячейкой и границей таблицы. Размер по ширине должен быть равен ширине таблицы.
            let estimatedSize = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            
            return estimatedSize.height + 32 // 32 - это отступ сверху и снизу текста в ячейке
        }else{
            let text = "\(filial["name"] as? String ?? "Нет данных о названии")\n\(filial["adress"] as? String ?? "Нет данных об адресе")\n\(filial["director"] as? String ?? "Нет данных о директоре")"
            
            let font = UIFont.systemFont(ofSize: 17) // задайте необходимый шрифт
            let size = CGSize(width: tableView.frame.width - 32, height: .infinity) // 32 - это расстояние между ячейкой и границей таблицы. Размер по ширине должен быть равен ширине таблицы.
            let estimatedSize = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            
            return estimatedSize.height + 32 // 32 - это отступ сверху и снизу текста в ячейке
        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let userListVC = storyboard.instantiateViewController(withIdentifier: "UserListViewController") as! UserListViewController
            navigationController?.pushViewController(userListVC, animated: true)
        }
        if indexPath.section == 1 {
            let filial = filialSortedArr[indexPath.row]
            let filialID = filial["id"] as? Int ?? 0
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let groupListVC = storyboard.instantiateViewController(withIdentifier: "GroupListViewController") as! GroupListViewController
            groupListVC.filialID = filialID
            navigationController?.pushViewController(groupListVC, animated: true)
        }
    }
}

