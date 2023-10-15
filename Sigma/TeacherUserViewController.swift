//
//  TeacherUserViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 5.04.23.
//

import UIKit

class TeacherUserViewController: UIViewController {
    
    var makeTeacherArr: [[String: Any]] = []
    let dataTeacher = GetTeacherDataList()
    var cityName:String!
    
    
    
    @IBOutlet weak var teacherCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        teacherCollectionView.dataSource = self
        teacherCollectionView.delegate = self
    
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
        dataTeacher.getTeacherListData(city: cityName){ teacherJsonData in
                if let teacherArr = teacherJsonData {
                    self.makeTeacherArr = teacherArr
                }else {
                    print("Невозможно получить данные о руководстве")

                        self.showAlertErrorDataTeacher()

                }
        }



        teacherCollectionView.register(UINib(nibName: "TeacherViewUserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TeacherViewUserCollectionViewCell")
    }



    private func showAlertErrorDataTeacher(){
        let alert = UIAlertController(title: "Уведомление!", message: "Невозможно получить данные о пользователе, повторите попытку позже", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }


}


extension TeacherUserViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return makeTeacherArr.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeacherViewUserCollectionViewCell", for: indexPath) as! TeacherViewUserCollectionViewCell


        let managerData = makeTeacherArr[indexPath.row]
        if managerData["image"] as? String == ""{
            cell.imageTeacherImageView.image = UIImage(named: "avatar")
        }else{
            if let imageString = managerData["image"] as? String, let imageData = Data(base64Encoded: imageString) {

                let image = UIImage(data: imageData)

                let buttonSize = cell.imageTeacherImageView.frame.size
                let renderer = UIGraphicsImageRenderer(size: buttonSize)
                let newImage = renderer.image { _ in
                    image?.draw(in: CGRect(origin: .zero, size: buttonSize))
                }
                cell.imageTeacherImageView.layer.borderWidth = 3
                cell.imageTeacherImageView.layer.borderColor = UIColor.black.cgColor
                cell.imageTeacherImageView.image = newImage
                cell.imageTeacherImageView.contentMode = .scaleAspectFit
                cell.imageTeacherImageView.clipsToBounds = true
                cell.imageTeacherImageView.layer.cornerRadius =  cell.imageTeacherImageView.frame.size.width / 2

            }
        }

        if let firstName = managerData["first_name"] as? String {
            cell.labelTeacherName.text = firstName
        }
        if let lastName = managerData["last_name"] as? String {
            cell.labelTeacherLastName.text = lastName
        }
        if var type = managerData["type_manager"] as? String {
            switch type {
            case "1":
                type = "Дефиле"
            case "2":
                type = "Фотопозирование"
            case "3":
                type = "Фитнес"
            case "4":
                type = "Психология"
            case "5":
                type = "Пластика"
            case "6":
                type = "Имидж"
            case "7":
                type = "Актерское мастерство"
            case "8":
                type = "Инстаграмоведение"
            default:
                type = "Преподаватель"
            }
            cell.labelTeacherPosition.text = type
        }
        if let phoneNumber = managerData["phone_number"] as? String {
            cell.labelTeacherPhone.text = phoneNumber
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = (collectionView.bounds.height) / 2
        return CGSize(width: width, height: height)
    }


}
