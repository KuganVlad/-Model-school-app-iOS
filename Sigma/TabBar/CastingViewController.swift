//
//  CastingViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 25.03.23.
//

import UIKit


class CastingViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var buttonCastingCollectionView: UICollectionView!
    var viewControllerNames: [String] = []
    let getInfoCasting = CastingGetInfo()
    var castingArr: [[String: Any]] = []
    var filteredCastingArr: [[String: Any]] = []





    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filteredCastingArr = self.castingArr
        getInfoCasting.getInfoCasting() { castingData in
                if let castingArr = castingData {
                    self.castingArr = castingArr
                    DispatchQueue.main.async {
                        self.buttonCastingCollectionView.reloadData()
                    }
                }else {
                    print("Невозможно получить данные о кастинге")
                    DispatchQueue.main.async {
                        self.showAlertErrorDataCasting()
                    }
                }
        }
        
        buttonCastingCollectionView.dataSource = self
        buttonCastingCollectionView.delegate = self


        buttonCastingCollectionView.register(CastingButtonCollectionViewCell.self, forCellWithReuseIdentifier: "CastingButtonCollection")

    }
    //Загружаем первоначальные данные
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

                getInfoCasting.getInfoCasting() { castingData in
                    if let castingArr = castingData {
                        self.castingArr = castingArr
                        self.filteredCastingArr = castingArr
                        DispatchQueue.main.async {
                            self.buttonCastingCollectionView.reloadData()
                        }
                    } else {
                        print("Невозможно получить данные о кастинге")
                        DispatchQueue.main.async {
                            self.showAlertErrorDataCasting()
                        }
                    }
                }
            }


    @objc func buttonCastingTapped(_ sender: UIButton) {
        // Получаем индекс ячейки, в которой была нажата кнопка
        let point = sender.convert(CGPoint.zero, to: buttonCastingCollectionView)
        if buttonCastingCollectionView.indexPathForItem(at: point) != nil {
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

    private func showAlertErrorDataCasting(){
        let alert = UIAlertController(title: "Уведомление!", message: "Невозможно получить данные о кастингах, повторите попытку позже", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    //фильтрация
    @IBAction func changedTextFieldAction(_ sender: UITextField) {
        if let searchText = sender.text?.lowercased(), !searchText.isEmpty {
            // Фильтруем массив castingArr по критериям поиска
            filteredCastingArr = castingArr.filter { casting in
                if let city = casting["city"] as? String, city.lowercased().contains(searchText) {
                    return true
                }
                if let type = casting["type"] as? String, type.lowercased().contains(searchText) {
                    return true
                }
                if let type = casting["date"] as? String, type.lowercased().contains(searchText) {
                    return true
                }
                if let type = casting["time"] as? String, type.lowercased().contains(searchText) {
                    return true
                }
                
                // Добавьте другие критерии фильтрации, если необходимо
                return false
            }
        } else {
            filteredCastingArr = castingArr
        }
        // Обновляем данные коллекции
        buttonCastingCollectionView.reloadData()
    }
}


extension CastingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //Количество кнопок
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCastingArr.count
    }


    //Добавление содержимого ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastingButtonCollection", for: indexPath) as! CastingButtonCollectionViewCell

        let castingData = filteredCastingArr[indexPath.row]
        let attributedText = NSMutableAttributedString()
        if let city = castingData["city"] as? String {
            let cityAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 17)]
            let cityString = NSMutableAttributedString(string: " Город: \(city)", attributes: cityAttributes)
            attributedText.append(cityString)
        }
        if let type = castingData["type"] as? String {
            let typeAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
            let typeString = NSAttributedString(string: "\n Направление: \(type) ", attributes: typeAttributes)
            attributedText.append(typeString)
        }
        if let dateString = castingData["date"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: dateString) {
                dateFormatter.dateFormat = "\n Дата: dd.MM.yyyy "
                let dateAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
                let dateString = NSAttributedString(string: dateFormatter.string(from: date), attributes: dateAttributes)
                attributedText.append(dateString)
            }
        }
        if let time = castingData["time"] as? String {
            let timeAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
            let timeString = NSAttributedString(string: "\n Время:\(time)", attributes: timeAttributes)
            attributedText.append(timeString)
        }
        if let adress = castingData["address"] as? String {
            let typeAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
            let typeString = NSAttributedString(string: "\n Адрес: \(adress) ", attributes: typeAttributes)
            attributedText.append(typeString)
        }
        if let corX = castingData["x"] as? String {
            let corXAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 0)]
            let corXString = NSAttributedString(string: "\n\(corX) ", attributes: corXAttributes)
            attributedText.append(corXString)
        }
        if let corY = castingData["y"] as? String {
            let corYAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 0)]
            let corYString = NSAttributedString(string: "\(corY) ", attributes: corYAttributes)
            attributedText.append(corYString)
        }
        if let id = castingData["id"] as? Int {
            let idAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 0)]
            let idString = NSMutableAttributedString(string: "\(id)", attributes: idAttributes)
            attributedText.append(idString)
        }

        
        cell.button.setAttributedTitle(attributedText, for: .normal)
        cell.button.contentHorizontalAlignment = .left
        cell.button.addTarget(self, action: #selector(buttonCastingTapped(_:)), for: .touchUpInside)
        return cell
    }




    //Установка высоты ячейки по содержанию
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let castingData = castingArr[indexPath.row]
        var buttonText = ""
        if let city = castingData["city"] as? String {
            buttonText += "\(city) "
        }
        if let type = castingData["type"] as? String {
            buttonText += "\n\(type) "
        }
        if let date = castingData["date"] as? String {
            buttonText += "\n\(date) "
        }
        if let time = castingData["time"] as? String {
            buttonText += "\n\(time)"
        }
        if let adress = castingData["address"] as? String {
            buttonText += "\n\(adress)"
        }
        let font = UIFont.systemFont(ofSize: 17)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragraphStyle]
        let size = (buttonText as NSString).boundingRect(with: CGSize(width: collectionView.bounds.width, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)


        let buttonSize = CGSize(width: collectionView.bounds.width, height: size.height + 25)
        return buttonSize
    }

}
