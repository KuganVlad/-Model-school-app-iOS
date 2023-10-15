//
//  ManagerUserViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 5.04.23.
//

import UIKit

class ManagerUserViewController: UIViewController {
    var makeManagerArr: [[String: Any]] = []
    let dataManager = GetManagerDataList()
    var cityName:String!
    
    @IBOutlet weak var managerCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        managerCollectionView.dataSource = self
        managerCollectionView.delegate = self
        
        
        cityName = UserDefaults.standard.object(forKey: "cityUser") as? String
            switch cityName {
            case "Мозырь":
                cityName = "24"
            case "Могилев":
                cityName = "23"
            case "Минск":
                cityName = "22"
            case "Гродно":
                cityName = "21"
            case "Гомель":
                cityName = "20"
            case "Витебск":
                cityName = "19"
            case "Брест":
                cityName = "18"
            case "Барановичи":
                cityName = "17"
            default:
                cityName = "25"
            }
        
        dataManager.getManagerListData(city: cityName){ managerJsonData in
                if let managerArr = managerJsonData {
                    self.makeManagerArr = managerArr
        
                }else {
                    print("Невозможно получить данные о руководстве")

                        self.showAlertErrorDataManager()
        
                }
        }

        
        
        managerCollectionView.register(UINib(nibName: "ManagerViewUserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ManagerViewUserCollectionViewCell")
    }

    
    
    private func showAlertErrorDataManager(){
        let alert = UIAlertController(title: "Уведомление!", message: "Невозможно получить данные о руководстве, повторите попытку позже", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    
}


extension ManagerUserViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return makeManagerArr.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ManagerViewUserCollectionViewCell", for: indexPath) as! ManagerViewUserCollectionViewCell
        
        
        let managerData = makeManagerArr[indexPath.row]
        if managerData["image"] as? String == ""{
            cell.imageManagerViewUser.image = UIImage(named: "avatar")
        }else{
            if let imageString = managerData["image"] as? String, let imageData = Data(base64Encoded: imageString) {
                
                let image = UIImage(data: imageData)
                
                let buttonSize = cell.imageManagerViewUser.frame.size
                let renderer = UIGraphicsImageRenderer(size: buttonSize)
                let newImage = renderer.image { _ in
                    image?.draw(in: CGRect(origin: .zero, size: buttonSize))
                }
                cell.imageManagerViewUser.layer.borderWidth = 3
                cell.imageManagerViewUser.layer.borderColor = UIColor.black.cgColor
                cell.imageManagerViewUser.image = newImage
                cell.imageManagerViewUser.contentMode = .scaleAspectFit
                cell.imageManagerViewUser.clipsToBounds = true
                cell.imageManagerViewUser.layer.cornerRadius =  cell.imageManagerViewUser.frame.size.width / 2

            }
        }
        
        if let firstName = managerData["first_name"] as? String {
            cell.labelNameManageViewUser.text = firstName
        }
        if let lastName = managerData["last_name"] as? String {
            cell.labelLastNameManageViewUser.text = lastName
        }
        if var type = managerData["type_manager"] as? String {
            switch type {
            case "5":
                type = "Директор"
            case "6":
                type = "Управляющий"
            default:
                type = "Руководитель"
            }
            cell.labelPositionManageViewUser.text = type
        }
        if let phoneNumber = managerData["phone_number"] as? String {
            cell.labelContactManageViewUser.text = phoneNumber
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = (collectionView.bounds.height) / 2
        return CGSize(width: width, height: height)
    }


}
