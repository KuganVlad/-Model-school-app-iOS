//
//  AttendaneceUserViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 31.03.23.
//

import UIKit

class AttendaneceUserViewController: UIViewController {
    var userID:String!
    let getUserAttendance = UserGetAttendance()
    var attedanceSortedArr: [[String: Any]] = []
    var attedanceCount:Int = 0
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var propDataLabel: UILabel!
    @IBOutlet weak var attendanceCollectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
           
           // добавляем выполнение функции в группу
           group.enter()
        self.title = ""
        getDataAttadance {
               // когда функция завершится, мы вызываем leave() для завершения группы
               group.leave()
           }
        group.notify(queue: .main) {
            
            self.attendanceCollectionView.delegate = self
            self.attendanceCollectionView.dataSource = self

            
            
            
            let layout = UICollectionViewFlowLayout()
            let itemWidth = self.attendanceCollectionView.bounds.width
            let itemHeight = self.attendanceCollectionView.bounds.height / 8
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            self.attendanceCollectionView.collectionViewLayout = layout
            
            
            self.attendanceCollectionView.register(UINib(nibName: "ProjectUserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProjectUserCollectionViewCell")
        }
    }
    
    
    
    func getDataAttadance(completion: @escaping () -> Void){
        userID = UserDefaults.standard.object(forKey: "userID") as? String
        getUserAttendance.getProjectUser(id: userID){ responseArray in
            if let attedanceArr = responseArray {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let filteredArray = attedanceArr.filter { attendance in
                    if let status = attendance["status"] as? Int, status == 0 {
                        return true
                    }
                    return false
                }
                let sortedArray = filteredArray.sorted { (dict1, dict2) -> Bool in
                    guard let dateString1 = dict1["lesson_data"] as? String,
                          let dateString2 = dict2["lesson_data"] as? String,
                          let date1 = dateFormatter.date(from: dateString1),
                          let date2 = dateFormatter.date(from: dateString2) else {
                        return false // если не удалось получить даты из словарей, то не сортируем элементы
                    }
                    return date1 > date2
                }
                self.attedanceSortedArr = sortedArray
                self.attedanceCount = filteredArray.count
                completion()
            }
        }
    }

    
}


extension AttendaneceUserViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attedanceSortedArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectUserCollectionViewCell", for: indexPath) as! ProjectUserCollectionViewCell
        let attedanceData = attedanceSortedArr[indexPath.item]

        if self.attedanceCount > 0{
            self.propDataLabel.text = "Пропущено занятий:  \(self.attedanceCount)"
        }
        
        let attributedText = NSMutableAttributedString()

        
        
        if let groupName = attedanceData["group_name"] as? String {
            groupNameLabel.text = "Группа \(groupName)"
        }
        
        if let name = attedanceData["discip_name"] as? String {
            let boldText = "\(name)\n"
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 28)]
            attributedText.append(NSAttributedString(string: boldText, attributes: attributes))
        }
        if let time = attedanceData["lesson_time"] as? String {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss"
            if let timeDate = timeFormatter.date(from: time) {
                timeFormatter.dateFormat = "HH:mm"
                let formattedTime = timeFormatter.string(from: timeDate)
                attributedText.append(NSAttributedString(string: "\(formattedTime)  "))
            }
        }

        if let date = attedanceData["lesson_data"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let dateDate = dateFormatter.date(from: date) {
                dateFormatter.dateFormat = "dd.MM.yyyy"
                let formattedDate = dateFormatter.string(from: dateDate)
                attributedText.append(NSAttributedString(string: "\(formattedDate)"))
            }
        }



        cell.labelData.layer.borderWidth = 2
        cell.labelData.layer.cornerRadius = 20
        cell.labelData.layer.masksToBounds = true
        if (indexPath.row % 2 == 0){
            cell.labelData.backgroundColor = .black
            cell.labelData.layer.borderColor = UIColor.white.cgColor
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedText.length))
        }else{
            cell.labelData.layer.borderColor = UIColor.black.cgColor
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: attributedText.length))
        }
        
        cell.labelData.attributedText = attributedText
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let projectData = attedanceSortedArr[indexPath.item]
        var labelText = ""
        if let name = projectData["discip_name"] as? String {
            labelText += "\(name)\n"
        }
        if let location = projectData["lesson_time"] as? String {
            labelText += "\(location)"
        }
        if let date = projectData["lesson_data"] as? String {
            labelText += "\(date)"
        }
        
        let font = UIFont.systemFont(ofSize: 25)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragraphStyle]
        let size = (labelText as NSString).boundingRect(with: CGSize(width: collectionView.bounds.width, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)


        let labelSize = CGSize(width: collectionView.frame.width, height: size.height + 50)
        return labelSize
    }
    
}
