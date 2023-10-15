//
//  CastingUserViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 31.03.23.
//

import UIKit

class CastingUserViewController: UIViewController {
    var userID:String!
    var castingArr: [String: Any] = [:]
    let castingData = UserCastingData()
    let deleteCastingRecord = UserDeleteCastingRecord()
    
    @IBOutlet weak var labelDataCasting: UILabel!
    @IBOutlet weak var castingDataCollection: UICollectionView!
    
    @IBOutlet weak var cancelCastingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        userID = UserDefaults.standard.object(forKey: "userID") as? String
        castingData.getUserCastingData(id: userID) { responseArray in
            if let castingArr = responseArray {
                self.castingArr = castingArr
                DispatchQueue.main.async {
                    self.castingDataCollection.reloadData()
                    self.labelDataCasting.text = "Вы записаны на кастинг: "
                }
            }else {
                print("Невозможно получить данные о кастинге")
                DispatchQueue.main.async {
                    self.labelDataCasting.text = "Вы не записаны на кастинг"
                    self.cancelCastingButton.isHidden = true
                    self.castingDataCollection.isHidden = true
                }
            }
        }
        castingDataCollection.dataSource = self
        castingDataCollection.delegate = self
        
        
        
        castingDataCollection.register(CastingButtonCollectionViewCell.self, forCellWithReuseIdentifier: "CastingButtonCollection")
        
        
        
        
    }
    @objc func buttonCastingTapped(_ sender: UIButton) {
        // Получаем индекс ячейки, в которой была нажата кнопка
        let point = sender.convert(CGPoint.zero, to: castingDataCollection)
        if castingDataCollection.indexPathForItem(at: point) != nil {
            // Получаем название view controller'а для перехода
            let viewControllerName = "CastingFullScreenViewController"
            // Создаем экземпляр view controller'а и переходим на него
            if let viewController = UIStoryboard(name: "Casting", bundle: nil).instantiateViewController(withIdentifier: viewControllerName) as? CastingFullScreenViewController {
                if let data = sender.currentAttributedTitle?.string {
                    viewController.labelDataCasting = data
                }
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    @IBAction func touchCancelCastingButton(_ sender: UIButton) {
        deleteCastingRecord.castingRecUser(id: userID) { responseArray in
            if responseArray != nil {
                DispatchQueue.main.async {
                    self.castingDataCollection.isHidden = true
                    self.labelDataCasting.text = "Вы не записаны на кастинг"
                    self.cancelCastingButton.isHidden = true
                    self.castingDataCollection.reloadData()
                    
                }
            }else {
                print("Невозможно получить данные о кастинге")
                DispatchQueue.main.async {
                    self.labelDataCasting.text = "Вы записаны на кастинг:"
                    
                }
            }
        }
    }
}

extension CastingUserViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastingButtonCollection", for: indexPath) as! CastingButtonCollectionViewCell

        let attributedText = NSMutableAttributedString()
        if let city = castingArr["city"] as? String {
            let cityAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 17)]
            let cityString = NSMutableAttributedString(string: " Город: \(city)", attributes: cityAttributes)
            attributedText.append(cityString)
        }
        if let type = castingArr["type"] as? String {
            let typeAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
            let typeString = NSAttributedString(string: "\n Направление: \(type) ", attributes: typeAttributes)
            attributedText.append(typeString)
        }
        if let dateString = castingArr["date"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: dateString) {
                dateFormatter.dateFormat = "\n Дата: dd.MM.yyyy "
                let dateAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
                let dateString = NSAttributedString(string: dateFormatter.string(from: date), attributes: dateAttributes)
                attributedText.append(dateString)
            }
        }
        if let time = castingArr["time"] as? String {
            let timeAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
            let timeString = NSAttributedString(string: "\n Время:\(time)", attributes: timeAttributes)
            attributedText.append(timeString)
        }
        if let adress = castingArr["address"] as? String {
            let typeAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
            let typeString = NSAttributedString(string: "\n Адрес: \(adress) ", attributes: typeAttributes)
            attributedText.append(typeString)
        }
        if let corX = castingArr["x"] as? String {
            let corXAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 0)]
            let corXString = NSAttributedString(string: "\n\(corX) ", attributes: corXAttributes)
            attributedText.append(corXString)
        }
        if let corY = castingArr["y"] as? String {
            let corYAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 0)]
            let corYString = NSAttributedString(string: "\(corY) ", attributes: corYAttributes)
            attributedText.append(corYString)
        }
        if let id = castingArr["id"] as? Int {
            let idAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 0)]
            let idString = NSMutableAttributedString(string: "\(id)", attributes: idAttributes)
            attributedText.append(idString)
        }

        
        cell.button.setAttributedTitle(attributedText, for: .normal)
        cell.button.contentHorizontalAlignment = .left
        cell.button.addTarget(self, action: #selector(buttonCastingTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var buttonText = ""
        if let city = castingArr["city"] as? String {
            buttonText += "\(city) "
        }
        if let type = castingArr["type"] as? String {
            buttonText += "\n\(type) "
        }
        if let date = castingArr["date"] as? String {
            buttonText += "\n\(date) "
        }
        if let time = castingArr["time"] as? String {
            buttonText += "\n\(time)"
        }
        if let adress = castingArr["address"] as? String {
            buttonText += "\n\(adress)"
        }
        let font = UIFont.systemFont(ofSize: 17)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragraphStyle]
        let size = (buttonText as NSString).boundingRect(with: CGSize(width: collectionView.bounds.width, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)


        let buttonSize = CGSize(width: collectionView.frame.width, height: size.height + 30)
        return buttonSize
    }
    
}

