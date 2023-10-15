//
//  GroupListViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 18.04.23.
//

import UIKit

class GroupListViewController: UIViewController {

    let getGroupList = GroupGetList()
    var filialID:Int!
    var groupId:Int!
    var groupSortedArr: [[String: Any]] = []
    
    @IBOutlet weak var groupTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
        
        // добавляем выполнение функции в группу
        group.enter()
        self.title = ""
        getGroupData {
            group.leave()
        }
        group.notify(queue: .main) {
            self.groupTableView.delegate = self
            self.groupTableView.dataSource = self
            
            self.groupTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
  
    func getGroupData(completion: @escaping () -> Void){
        getGroupList.getGroup(id: String(self.filialID)){ responseArray in
            if let groupArr = responseArray {
                self.groupSortedArr = groupArr
                print(self.groupSortedArr)
                completion()
            }else{
                self.showAlertFilialError()
            }
        }
    }
    
    
    private func showAlertFilialError(){
        let alert = UIAlertController(title: "Уведомление!", message: "Невозможно получить список групп", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension GroupListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return groupSortedArr.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let group = groupSortedArr[indexPath.row]
        let name = group["name"] as? String ?? "Нет данных о названии"
        let type = group["type"] as? String ?? "Нет данных об типе группы"
        cell.textLabel?.text = "\(name)\n\(type)"
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let group = groupSortedArr[indexPath.row]
        let text = "\(group["name"] as? String ?? "Нет данных о названии")\n\(group["type"] as? String ?? "Нет данных об типе группы")"
        
        let font = UIFont.systemFont(ofSize: 17) // задайте необходимый шрифт
        let size = CGSize(width: tableView.frame.width - 32, height: .infinity) // 32 - это расстояние между ячейкой и границей таблицы. Размер по ширине должен быть равен ширине таблицы.
        let estimatedSize = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return estimatedSize.height + 32 // 32 - это отступ сверху и снизу текста в ячейке
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = groupSortedArr[indexPath.row]
        let groupID = group["id"] as? Int ?? 0
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let studentListVC = storyboard.instantiateViewController(withIdentifier: "StudentListViewController") as! StudentListViewController
        studentListVC.groupId = groupID
        navigationController?.pushViewController(studentListVC, animated: true)

    }
}
