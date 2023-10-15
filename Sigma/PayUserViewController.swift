//
//  PayUserViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 31.03.23.
//

import UIKit

class PayUserViewController: UIViewController {
    
    var userID:String!
    let userDeposited = UserGetDeposit()
    var depositeArr: [[String: Any]] = []
    
    @IBOutlet weak var labelValuePay: UILabel!
    @IBOutlet weak var payCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payCollectionView.delegate = self
        payCollectionView.dataSource = self
        self.title = ""
        
        
        let layout = UICollectionViewFlowLayout()
        let itemWidth = self.payCollectionView.bounds.width
        let itemHeight = self.payCollectionView.bounds.height / 5
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.payCollectionView.collectionViewLayout = layout
        
        userID = UserDefaults.standard.object(forKey: "userID") as? String
        
        userDeposited.getUserDepositData(id: userID) { responseArray in
            if let depositeArr = responseArray {
                let sortedArr = depositeArr.sorted { (dict1, dict2) -> Bool in
                    guard let date1 = dict1["date"] as? String, let date2 = dict2["date"] as? String else {
                        return false
                    }
                    return date1 > date2
                }
                self.depositeArr = sortedArr
                var minDate = Date.distantFuture
                var sum = 0
                var count = 0
                var days_data = 0

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"

                for item in self.depositeArr {
                    if let dateString = item["date"] as? String,
                        let date = dateFormatter.date(from: dateString) {
                        if date < minDate {
                            minDate = date
                            let calendar = Calendar.current
                            days_data = calendar.component(.day, from: minDate)
                        }
                    }
                    if let itemSum = item["sum"] as? Int {
                        sum += itemSum
                    }
                    count += 1
                }

                let average = Double(sum) / Double(count)
                if average < 170 {
                    let calendar = Calendar.current
                    let monthToAdd = count
                    
                    let today = Date()
                    let currentDay = calendar.component(.day, from: today)

                    var newDate: Date?
                    if currentDay < days_data {
                        newDate = calendar.date(bySetting: .day, value: days_data, of: today)!
                    } else {
                        let nextMonth = calendar.date(byAdding: .month, value: 1, to: today)!
                        newDate = calendar.date(bySetting: .day, value: days_data, of: nextMonth)!
                    }

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yyyy"
                    let dateString = dateFormatter.string(from: newDate!)
                    let result = Double(count * 170) - Double(sum)
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    
                    if let unwrappedDate = newDate {
                        let dateString = dateFormatter.string(from: unwrappedDate)
                        DispatchQueue.main.async {
                            self.labelValuePay.text = "Вам необходимо оплатить \(result) до \(dateString)"
                        }
                    }
                }


            }

        }

    payCollectionView.register(UINib(nibName: "PayViewUserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PayViewUserCollectionViewCell")
    }
    
}

extension PayUserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return depositeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PayViewUserCollectionViewCell", for: indexPath) as! PayViewUserCollectionViewCell
        
        let depositData = depositeArr[indexPath.row]
        let attributedText = NSMutableAttributedString()
        if let sum = depositData["sum"] as? String {
            let typeAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
            let typeString = NSAttributedString(string: "Сумма \(sum) рублей(копеек)", attributes: typeAttributes)

            attributedText.append(typeString)
        }
        if let dateString = depositData["date"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: dateString) {
                dateFormatter.dateFormat = "\nвнесена dd.MM.yyyy "
                let dateAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
                let dateString = NSAttributedString(string: dateFormatter.string(from: date), attributes: dateAttributes)

                attributedText.append(dateString)
            }
        }
        cell.payViewCell.layer.borderWidth = 2
        if (indexPath.row % 2 == 0){
            cell.payViewCell.backgroundColor = .black
            cell.payViewCell.layer.borderColor = UIColor.white.cgColor
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedText.length))
        }else{
            cell.payViewCell.layer.borderColor = UIColor.black.cgColor
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: attributedText.length))
        }
        
        cell.payViewCell.setAttributedTitle(attributedText, for: .normal)
        cell.payViewCell.contentHorizontalAlignment = .center
        cell.payViewCell.layer.cornerRadius = 10

        return cell
    }
    
    
    //Установка высоты ячейки по содержанию
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.bounds.width
        let height = (collectionView.bounds.height)
        return CGSize(width: width, height: height)
    }



        

}
