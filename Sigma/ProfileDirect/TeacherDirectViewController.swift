//
//  TeacherDirectViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 5.04.23.
//

import UIKit

class TeacherDirectViewController: UIViewController {
    
    var makeTeacherArr: [[String: Any]] = []
    let dataTeacher = GetTeacherManagerData()
    var cityName:String!
    
    
    @IBOutlet weak var teacherManagerCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        teacherManagerCollectionView.dataSource = self
        teacherManagerCollectionView.delegate = self
    
       
        dataTeacher.getTeacherListData(){ teacherJsonData in
                if let teacherArr = teacherJsonData {
                    self.makeTeacherArr = teacherArr
                }else {
                    print("Невозможно получить данные о руководстве")

                        self.showAlertErrorDataTeacher()

                }
        }



        teacherManagerCollectionView.register(UINib(nibName: "TeacherViewManagerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TeacherViewManagerCollectionViewCell")
    }



    private func showAlertErrorDataTeacher(){
        let alert = UIAlertController(title: "Уведомление!", message: "Невозможно получить данные о пользователе, повторите попытку позже", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }


}


extension TeacherDirectViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return makeTeacherArr.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeacherViewManagerCollectionViewCell", for: indexPath) as! TeacherViewManagerCollectionViewCell


        let managerData = makeTeacherArr[indexPath.row]
        if managerData["image"] as? String == ""{
            cell.teacherImage.image = UIImage(named: "avatar")
        }else{
            if let imageString = managerData["image"] as? String, let imageData = Data(base64Encoded: imageString) {

                let image = UIImage(data: imageData)

                let buttonSize = cell.teacherImage.frame.size
                let renderer = UIGraphicsImageRenderer(size: buttonSize)
                let newImage = renderer.image { _ in
                    image?.draw(in: CGRect(origin: .zero, size: buttonSize))
                }
                cell.teacherImage.layer.borderWidth = 3
                cell.teacherImage.layer.borderColor = UIColor.black.cgColor
                cell.teacherImage.image = newImage
                cell.teacherImage.contentMode = .scaleAspectFit
                cell.teacherImage.clipsToBounds = true
                cell.teacherImage.layer.cornerRadius =  cell.teacherImage.frame.size.width / 2

            }
        }

        if let firstName = managerData["first_name"] as? String {
            cell.teacherFirstName.text = firstName
        }
        if let lastName = managerData["last_name"] as? String {
            cell.teacherLastName.text = lastName
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
            cell.teacherPosition.text = type
        }
        if let phoneNumber = managerData["phone_number"] as? String {
            cell.teacherPhone.text = phoneNumber
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = (collectionView.bounds.height) / 2
        return CGSize(width: width, height: height)
    }


}
