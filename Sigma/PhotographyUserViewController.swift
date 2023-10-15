//
//  PhotographyUserViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 31.03.23.
//

import UIKit

class PhotographyUserViewController: UIViewController {
    var userID:String!
    let getUserPhotoshoot = UserGetPhotoshoot()
    var photoshootSortedArr: [[String: Any]] = []
    
    @IBOutlet weak var photoshootCollectionView: UICollectionView!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
           
           // добавляем выполнение функции в группу
           group.enter()
        self.title = ""
        getDataPhotoshoot {
               // когда функция завершится, мы вызываем leave() для завершения группы
               group.leave()
           }
        group.notify(queue: .main) {
            
            
            self.photoshootCollectionView.dataSource = self
            self.photoshootCollectionView.delegate = self

            
            
            let layout = UICollectionViewFlowLayout()
            let itemWidth = self.photoshootCollectionView.bounds.width
            let itemHeight = self.photoshootCollectionView.bounds.height / 8
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            self.photoshootCollectionView.collectionViewLayout = layout
            
            
            self.photoshootCollectionView.register(UINib(nibName: "ProjectUserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProjectUserCollectionViewCell")
            
        }
    }
    
    
    func getDataPhotoshoot(completion: @escaping () -> Void){
        userID = UserDefaults.standard.object(forKey: "userID") as? String
        getUserPhotoshoot.getPhotoshootUser(id: userID){ responseArray in
            if let attedanceArr = responseArray {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let filteredArray = attedanceArr.filter { attendance in
                    if let status = attendance["status"] as? Int, status == 1 {
                        return true
                    }
                    return false
                }
                let sortedArray = filteredArray.sorted { (dict1, dict2) -> Bool in
                    guard let dateString1 = dict1["date"] as? String,
                          let dateString2 = dict2["date"] as? String,
                          let date1 = dateFormatter.date(from: dateString1),
                          let date2 = dateFormatter.date(from: dateString2) else {
                        return false // если не удалось получить даты из словарей, то не сортируем элементы
                    }
                    return date1 > date2
                }
                self.photoshootSortedArr = sortedArray
                completion()
            }
        }
    }


}


extension PhotographyUserViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoshootSortedArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectUserCollectionViewCell", for: indexPath) as! ProjectUserCollectionViewCell
        let attedanceData = photoshootSortedArr[indexPath.item]
        
        let attributedText = NSMutableAttributedString()
        
        if let groupName = attedanceData["id_group"] as? String {
            groupNameLabel.text = "Группа \(groupName)"
        }
        
        if let name = attedanceData["name"] as? String {
            let boldText = "\(name)\n"
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 28)]
            attributedText.append(NSAttributedString(string: boldText, attributes: attributes))
        }
        if let loc = attedanceData["location"] as? String {
            let boldText = "\(loc)\n"
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 20)]
            attributedText.append(NSAttributedString(string: boldText, attributes: attributes))
        }
        
        if let time = attedanceData["time"] as? String {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss"
            if let timeDate = timeFormatter.date(from: time) {
                timeFormatter.dateFormat = "HH:mm"
                let formattedTime = timeFormatter.string(from: timeDate)
                attributedText.append(NSAttributedString(string: "\(formattedTime)  "))
            }
        }

        if let date = attedanceData["date"] as? String {
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
        let projectData = photoshootSortedArr[indexPath.item]
        var labelText = ""
        if let name = projectData["name"] as? String {
            labelText += "\(name)\n"
        }
        if let name = projectData["location"] as? String {
            labelText += "\(name)\n"
        }
        if let location = projectData["time"] as? String {
            labelText += "\(location)"
        }
        if let date = projectData["date"] as? String {
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
