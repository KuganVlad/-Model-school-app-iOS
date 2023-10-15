//
//  ScheduleUserViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 31.03.23.
//

import UIKit




class ScheduleUserViewController: UIViewController {
    var typeUserData:String!
    var userID:String!
    let getUserSchedule = UserGetSchedule()
    let getTeacherSchedule = TeacherGetSchedule()
    var scheduleSortedArr: [[String: Any]] = []
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var scheduleUserCollectionView: UICollectionView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
        
        // добавляем выполнение функции в группу
        group.enter()
        self.title = ""
        getDataSchedule {
            // когда функция завершится, мы вызываем leave() для завершения группы
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.scheduleUserCollectionView.delegate = self
            self.scheduleUserCollectionView.dataSource = self
            
            let layout = UICollectionViewFlowLayout()
            let itemWidth = self.scheduleUserCollectionView.bounds.width
            let itemHeight = self.scheduleUserCollectionView.bounds.height / 2
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            self.scheduleUserCollectionView.collectionViewLayout = layout
            
            
            
            self.scheduleUserCollectionView.register(UINib(nibName: "ScheduleUserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ScheduleUserCollectionViewCell")
        }
        
        
        
    }
    
    
    func getDataSchedule(completion: @escaping () -> Void){
        userID = UserDefaults.standard.object(forKey: "userID") as? String
        typeUserData = UserDefaults.standard.object(forKey: "userType") as? String
        if (typeUserData! == typeUser.user.label ||
            typeUserData! == typeUser.student.label ||
            typeUserData! == typeUser.customer.label){
            getUserSchedule.getScheduleUser(id: userID) { responseArray in
                if let scheduleArr = responseArray {
                    // Исходный массив
                    // Создаем словарь для хранения данных в новом формате
                    var newArray: [[String: Any]] = []
                    
                    // Создаем словарь для временного хранения данных по датам
                    var dateDict: [String: Any] = [:]
                    
                    // Проходим по исходному массиву
                    for item in scheduleArr {
                        
                        // Извлекаем значения даты и времени из текущего элемента массива
                        guard let date = item["date"] as? String, let time = item["time_lesson"] as? String else {
                            continue
                        }
                        
                        // Создаем массив для временного хранения значений по времени
                        var timeArray: [[String: Any]] = []
                        
                        // Извлекаем все элементы исходного массива, соответствующие текущей дате и времени
                        for currentItem in scheduleArr where currentItem["date"] as? String == date && currentItem["time_lesson"] as? String == time {
                            
                            // Добавляем элемент в массив для временного хранения значений по времени
                            timeArray.append(currentItem)
                        }
                        
                        // Сортируем массив по времени
                        timeArray = timeArray.sorted { ($0["time_lesson"] as? String ?? "") < ($1["time_lesson"] as? String ?? "") }
                        //Создаем словарь для хранения значений текущей даты и времени
                        var dict: [String: Any] = [:]
                        dict["date"] = date
                        dict["time"] = time
                        dict["items"] = timeArray
                        
                        // Добавляем словарь с данными текущей даты и времени в словарь для временного хранения данных по датам
                        if var items = dateDict[date] as? [[String: Any]] {
                            items.append(dict)
                            dateDict[date] = items
                        } else {
                            dateDict[date] = [dict]
                        }
                    }
                    // Проходим по словарю для временного хранения данных по датам и добавляем данные в новый массив в нужном формате
                    for (date, items) in dateDict {
                        var dict: [String: Any] = [:]
                        dict["date"] = date
                        dict["items"] = items
                        newArray.append(dict)
                    }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let sortedArray = newArray.sorted { (dict1, dict2) -> Bool in
                        guard let dateString1 = dict1["date"] as? String,
                              let dateString2 = dict2["date"] as? String,
                              let date1 = dateFormatter.date(from: dateString1),
                              let date2 = dateFormatter.date(from: dateString2) else {
                            return false // если не удалось получить даты из словарей, то не сортируем элементы
                        }
                        return date1 > date2
                    }
                    
                    self.scheduleSortedArr =  sortedArray
                    completion()
                }
            }
        }else{
            getTeacherSchedule.getScheduleTeacher(id: userID){responseArray in
                if let scheduleArr = responseArray {
                    // Исходный массив
                    // Создаем словарь для хранения данных в новом формате
                    var newArray: [[String: Any]] = []
                    
                    // Создаем словарь для временного хранения данных по датам
                    var dateDict: [String: Any] = [:]
                    
                    // Проходим по исходному массиву
                    for item in scheduleArr {
                        
                        // Извлекаем значения даты и времени из текущего элемента массива
                        guard let date = item["date"] as? String, let time = item["time_lesson"] as? String else {
                            continue
                        }
                        
                        // Создаем массив для временного хранения значений по времени
                        var timeArray: [[String: Any]] = []
                        
                        // Извлекаем все элементы исходного массива, соответствующие текущей дате и времени
                        for currentItem in scheduleArr where currentItem["date"] as? String == date && currentItem["time_lesson"] as? String == time {
                            
                            // Добавляем элемент в массив для временного хранения значений по времени
                            timeArray.append(currentItem)
                        }
                        
                        // Сортируем массив по времени
                        timeArray = timeArray.sorted { ($0["time_lesson"] as? String ?? "") < ($1["time_lesson"] as? String ?? "") }
                        //Создаем словарь для хранения значений текущей даты и времени
                        var dict: [String: Any] = [:]
                        dict["date"] = date
                        dict["time"] = time
                        dict["items"] = timeArray
                        
                        // Добавляем словарь с данными текущей даты и времени в словарь для временного хранения данных по датам
                        if var items = dateDict[date] as? [[String: Any]] {
                            items.append(dict)
                            dateDict[date] = items
                        } else {
                            dateDict[date] = [dict]
                        }
                    }
                    // Проходим по словарю для временного хранения данных по датам и добавляем данные в новый массив в нужном формате
                    for (date, items) in dateDict {
                        var dict: [String: Any] = [:]
                        dict["date"] = date
                        dict["items"] = items
                        newArray.append(dict)
                    }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let sortedArray = newArray.sorted { (dict1, dict2) -> Bool in
                        guard let dateString1 = dict1["date"] as? String,
                              let dateString2 = dict2["date"] as? String,
                              let date1 = dateFormatter.date(from: dateString1),
                              let date2 = dateFormatter.date(from: dateString2) else {
                            return false // если не удалось получить даты из словарей, то не сортируем элементы
                        }
                        return date1 > date2
                    }
                    
                    self.scheduleSortedArr =  sortedArray
                    completion()
                }else{
                    DispatchQueue.main.async {
                        self.groupNameLabel.text = ""
                        self.showAlertProjectAddComplete()
                    }
                }
            }
        }
    }
    private func showAlertProjectAddComplete(){
        let alert = UIAlertController(title: "Уведомление!", message: "Данные о занятиях отсутствуют", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
extension ScheduleUserViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scheduleSortedArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleUserCollectionViewCell", for: indexPath) as! ScheduleUserCollectionViewCell
        
        let scheduleData = scheduleSortedArr[indexPath.row]
//        if scheduleSortedArr.count == 1 {
//
//        }else if scheduleSortedArr.count == 0{
//
//        }
        let attributedText = NSMutableAttributedString()
        
        if let items = scheduleData["items"] as? [[String: Any]] {
            let sortedItems = items.sorted { (item1, item2) -> Bool in
                if let time1String = (item1["items"] as? [[String: Any]])?.first?["time_lesson"] as? String,
                   let time2String = (item2["items"] as? [[String: Any]])?.first?["time_lesson"] as? String {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    if let time1 = formatter.date(from: "2000-01-01 " + time1String),
                       let time2 = formatter.date(from: "2000-01-01 " + time2String) {
                        return time1 < time2
                    }
                }
                return false
            }
            if (sortedItems.count == 2){
                cell.threeLabelSchedule.isHidden = true
            }else if (sortedItems.count == 1){
                cell.threeLabelSchedule.isHidden = true
                cell.twoLabelSchedule.isHidden = true
            }
            if (typeUserData! == typeUser.user.label ||
                typeUserData! == typeUser.student.label ||
                typeUserData! == typeUser.customer.label){
                for (index, item) in sortedItems.enumerated() {
                    if item["time"] is String {
                        if let nestedItems = item["items"] as? [[String: Any]] {
                            let nestedItem = nestedItems[0]
                            if let group = nestedItem["group_name"] as? String,
                               let timeString = nestedItem["time_lesson"] as? String,
                               let discipline = nestedItem["discipline"] as? String,
                               let teacherLastName = nestedItem["lastname_teacher"] as? String {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                if let time = formatter.date(from: "2000-01-01 " + timeString) {
                                    formatter.dateFormat = "HH:mm"
                                    let formattedTime = formatter.string(from: time)
                                    let text = "\(formattedTime) - \(discipline)\n\(teacherLastName)"
                                    switch index {
                                    case 0:
                                        cell.firstLabelSchedule.text = text
                                    case 1:
                                        cell.twoLabelSchedule.text = text
                                    case 2:
                                        cell.threeLabelSchedule.text = text
                                    default:
                                        cell.isHidden = true
                                    }
                                    groupNameLabel.text = "Группа \(group)"
                                }
                            }
                        }
                    }
                }
                
            }else{
                for (index, item) in sortedItems.enumerated() {
                    if item["time"] is String {
                        if let nestedItems = item["items"] as? [[String: Any]] {
                            let nestedItem = nestedItems[0]
                            if let group = nestedItem["group_name"] as? String,
                               let timeString = nestedItem["time_lesson"] as? String,
                               let discipline = nestedItem["discipline"] as? String,
                               let _ = nestedItem["lastname_teacher"] as? String {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                if let time = formatter.date(from: "2000-01-01 " + timeString) {
                                    formatter.dateFormat = "HH:mm"
                                    let formattedTime = formatter.string(from: time)
                                    let text = "\(group)\n\(formattedTime) - \(discipline)"
                                    switch index {
                                    case 0:
                                        cell.firstLabelSchedule.text = text
                                    case 1:
                                        cell.twoLabelSchedule.text = text
                                    case 2:
                                        cell.threeLabelSchedule.text = text
                                    default:
                                        cell.isHidden = true
                                    }
                                    groupNameLabel.text = ""
                                }
                            }
                        }
                    }
                }
                
            }
        }
        
        if let dateString = scheduleData["date"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: dateString) {
                let weekday = Calendar.current.component(.weekday, from: date)
                let weekdayName = dateFormatter.weekdaySymbols[weekday - 1]
                dateFormatter.dateFormat = "dd.MM.yyyy  (\(weekdayName.uppercased()))"
                let dateAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
                let dateString = NSAttributedString(string: dateFormatter.string(from: date), attributes: dateAttributes)
                
                attributedText.append(dateString)
            }
        }
        cell.buttonDataSchedule.layer.borderWidth = 2
        if (indexPath.row % 2 == 0){
            cell.buttonDataSchedule.backgroundColor = .black
            cell.buttonDataSchedule.layer.borderColor = UIColor.white.cgColor
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedText.length))
        }else{
            cell.buttonDataSchedule.layer.borderColor = UIColor.black.cgColor
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: attributedText.length))
        }
        
        cell.buttonDataSchedule.setAttributedTitle(attributedText, for: .normal)
        cell.buttonDataSchedule.contentHorizontalAlignment = .center
        cell.buttonDataSchedule.layer.cornerRadius = 10
        
        
        return cell
        
    }
    
    //Установка высоты ячейки по содержанию
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let height = (collectionView.bounds.height)
        return CGSize(width: width, height: height)
    }
    
}
