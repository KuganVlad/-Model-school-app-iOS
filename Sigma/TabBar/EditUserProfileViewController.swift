//
//  EditUserProfileViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 31.03.23.
//

import UIKit

class EditUserProfileViewController: UIViewController {
    var typeUserData:String!
    var userIDData:String!
    let getUserData = GetUserData()
    let getManagerData = GetManagerData()
    var userProfileEdit = EditUserProfileData()
    var userAttributesDict: [String:Any] = [:]
    var userAttributesKey: [String] = []
    var dbSaveUserDataDict: [String:Any] = [:]
    var cityName:String = "Город"
    var discName:String = "Дисциплина"
    var dataImage: UIImage?
    let setUserData = SetUserData()
    let setManagerData = SetManagerData()
    
    
    
    @IBOutlet weak var buttonImageProfile: UIButton!
    @IBOutlet weak var tableButtonTableView: UITableView!
    @IBOutlet weak var navSaveButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            // обновление интерфейса в главном потоке
            self.tableButtonTableView.reloadData()
        }
        tableButtonTableView.delegate = self
        tableButtonTableView.dataSource = self
        
        
        tableButtonTableView.register(UINib(nibName: String(describing: ProfileEditTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProfileEditTableViewCell.self))
        
        
        //Получение данных о пользователе
        typeUserData = UserDefaults.standard.object(forKey: "userType") as? String
        userIDData = UserDefaults.standard.object(forKey: "userID") as? String
        
        userAttributesKey = userProfileEdit.buttonToTypeUser(typeUser: typeUserData)
        
        
        //поулчение данных о пользователе
        if (typeUserData! == typeUser.user.label ||
            typeUserData! == typeUser.student.label ||
            typeUserData! == typeUser.customer.label){
            dataGetUser()
        }else{
            getDataManager()
        }
    }
    
    @IBAction func buttonAddImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func actionSaveButton(_ sender: UIBarButtonItem) {
        
        if (typeUserData! == typeUser.user.label ||
            typeUserData! == typeUser.student.label ||
            typeUserData! == typeUser.customer.label){
            let visibleCells = tableButtonTableView.visibleCells
            for cell in visibleCells {
                if let profileCell = cell as? ProfileEditTableViewCell {
                    guard let key = profileCell.labelCellCustom.text else { return }
                    guard let value = profileCell.textCellCustom.text else { return }
                    if value != ""{
                        if key == "Город"{
                            switch value {
                            case "Мозырь":
                                self.cityName = "24"
                            case "Могилев":
                                self.cityName = "23"
                            case "Минск":
                                self.cityName = "22"
                            case "Гродно":
                                self.cityName = "21"
                            case "Гомель":
                                self.cityName = "20"
                            case "Витебск":
                                self.cityName = "19"
                            case "Брест":
                                self.cityName = "18"
                            case "Барановичи":
                                self.cityName = "17"
                            default:
                                self.cityName = "25"
                            }
                            dbSaveUserDataDict["city"] = self.cityName
                        }else if key == "Фамилия" {
                            dbSaveUserDataDict["lastname"] = value
                        } else if key == "Имя" {
                            dbSaveUserDataDict["firstname"] = value
                        } else if key == "Отчество" {
                            dbSaveUserDataDict["surname"] = value
                        } else if key == "Возраст" {
                            dbSaveUserDataDict["age"] = value
                        } else if key == "Эл. почта" {
                            dbSaveUserDataDict["email"] = value
                        } else if key == "Пароль" {
                            dbSaveUserDataDict["password"] = value
                        } else if key == "Телефон" {
                            dbSaveUserDataDict["phonenumber"] = value
                        } else if key == "Город" {
                            dbSaveUserDataDict["city"] = value
                        } else if key == "Организация" {
                            dbSaveUserDataDict["organization"] = value
                        } else if key == "Должность" {
                            dbSaveUserDataDict["position"] = value
                        }
                    }
                }
            }
            
            if dataImage != nil{
                //запись изображения
                let targetSize = CGSize(width: 200, height: 200)
                UIGraphicsBeginImageContext(targetSize)
                dataImage?.draw(in: CGRect(origin: .zero, size: targetSize))
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                if let imageData = newImage?.jpegData(compressionQuality: 0.5){
                    let base64String = imageData.base64EncodedString()
                    dbSaveUserDataDict["image"] = base64String
                }
            }
            //Обновление данных о пользователе
            if (typeUserData! == typeUser.user.label ||
                typeUserData! == typeUser.student.label ||
                typeUserData! == typeUser.customer.label){
                guard let dataToken = UserDefaults.standard.object(forKey: "jwtToken") as? String else {return}
                setUserData.setDataUsers(token: dataToken, data: dbSaveUserDataDict){dataResult in
                    if dataResult != nil {
                        UserDefaults.standard.set(dataResult, forKey: "jwtToken")
                        DispatchQueue.main.async {
                            self.showAlertUpdateDataUser()
                            self.buttonImageProfile.setImage(nil, for: .normal)
                            let cleanCells = self.tableButtonTableView.visibleCells
                            for cell in cleanCells {
                                if let profileCell = cell as? ProfileEditTableViewCell {
                                    profileCell.textCellCustom.text = ""
                                }
                            }
                            self.dataGetUser()
                        }
                    }
                }
            }
            self.navigationController?.popViewController(animated: true)
        }else{
            let visibleCells = tableButtonTableView.visibleCells
            for cell in visibleCells {
                if let profileCell = cell as? ProfileEditTableViewCell {
                    guard let key = profileCell.labelCellCustom.text else { return }
                    guard let value = profileCell.textCellCustom.text else { return }
                    if value != ""{
                        if key == "Город"{
                            switch value {
                            case "Мозырь":
                                self.cityName = "24"
                            case "Могилев":
                                self.cityName = "23"
                            case "Минск":
                                self.cityName = "22"
                            case "Гродно":
                                self.cityName = "21"
                            case "Гомель":
                                self.cityName = "20"
                            case "Витебск":
                                self.cityName = "19"
                            case "Брест":
                                self.cityName = "18"
                            case "Барановичи":
                                self.cityName = "17"
                            default:
                                self.cityName = "25"
                            }
                            dbSaveUserDataDict["city"] = self.cityName
                        }else if key == "Фамилия" {
                            dbSaveUserDataDict["lastname"] = value
                        } else if key == "Имя" {
                            dbSaveUserDataDict["firstname"] = value
                        } else if key == "Отчество" {
                            dbSaveUserDataDict["surname"] = value
                        } else if key == "Эл. почта" {
                            dbSaveUserDataDict["email"] = value
                        } else if key == "Пароль" {
                            dbSaveUserDataDict["password"] = value
                        } else if key == "Телефон" {
                            dbSaveUserDataDict["phonenumber"] = value
                        } else if key == "Город" {
                            dbSaveUserDataDict["city"] = value
                        } else if key == "Должность" {
                            var tmpData = ""
                            switch value {
                            case "Дефиле":
                                tmpData = "1"
                            case "Фотопозирование":
                                tmpData = "2"
                            case "Фитнес":
                                tmpData = "3"
                            case "Психология":
                                tmpData = "4"
                            case "Пластика":
                                tmpData = "5"
                            case "Инстаграмоведение":
                                tmpData = "6"
                            case "Имидж":
                                tmpData = "7"
                            case "Актерское":
                                tmpData = "8"
                            default:
                                tmpData = "9"
                            }
                            dbSaveUserDataDict["discipline"] = tmpData
                            
                        }
                    }
                }
            }
            
            if dataImage != nil{
                //запись изображения
                let targetSize = CGSize(width: 200, height: 200)
                UIGraphicsBeginImageContext(targetSize)
                dataImage?.draw(in: CGRect(origin: .zero, size: targetSize))
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                if let imageData = newImage?.jpegData(compressionQuality: 0.5){
                    let base64String = imageData.base64EncodedString()
                    dbSaveUserDataDict["image"] = base64String
                }
            }
            //Обновление данных о пользователе
            
            guard let dataToken = UserDefaults.standard.object(forKey: "jwtToken") as? String else {return}
            setManagerData.setDataManager(token: dataToken, data: dbSaveUserDataDict){dataResult in
                if dataResult != nil {
                    UserDefaults.standard.set(dataResult, forKey: "jwtToken")
                    DispatchQueue.main.async {
                        self.showAlertUpdateDataUser()
                        self.buttonImageProfile.setImage(nil, for: .normal)
                        let cleanCells = self.tableButtonTableView.visibleCells
                        for cell in cleanCells {
                            if let profileCell = cell as? ProfileEditTableViewCell {
                                profileCell.textCellCustom.text = ""
                            }
                        }
                        self.getDataManager()
                    }
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func showAlertUpdateDataUser(){
        let alert = UIAlertController(title: "Уведомление!", message: "Ваши данные обновлены", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showAlertErrorDataUser(){
        let alert = UIAlertController(title: "Уведомление!", message: "Невозможно получить данные о текущем пользователе, повторите попытку позже", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func dataGetUser(){
        //Получение сведений о пользователе с БД
        getUserData.getUsers(id: userIDData){ userData in
            if let userDict = userData {
                if let lastName = userDict["last_name"] as? String {
                    DispatchQueue.main.async {
                        self.userAttributesDict[self.userAttributesKey[0]] = lastName
                    }
                }
                if let firstName = userDict["first_name"] as? String {
                    DispatchQueue.main.async {
                        self.userAttributesDict[self.userAttributesKey[1]] =  firstName
                    }
                }
                if let surName = userDict["sur_name"] as? String {
                    DispatchQueue.main.async {
                        self.userAttributesDict[self.userAttributesKey[2]] = surName
                    }
                }
                if let age = userDict["age"] as? String {
                    DispatchQueue.main.async {
                        self.userAttributesDict[self.userAttributesKey[3]] = age
                    }
                }
                if let email = userDict["email"] as? String {
                    DispatchQueue.main.async {
                        self.userAttributesDict[self.userAttributesKey[4]] = email
                    }
                }
                if var password = userDict["password"] as? String {
                    password = "******"
                    DispatchQueue.main.async {
                        self.userAttributesDict[self.userAttributesKey[5]] = password
                    }
                }
                if let phone = userDict["phone_number"] as? String {
                    DispatchQueue.main.async {
                        self.userAttributesDict[self.userAttributesKey[6]] = phone
                    }
                }
                if let city = userDict["city"] as? String {
                    DispatchQueue.main.async {
                        switch city {
                        case "24":
                            self.cityName = "Мозырь"
                        case "23":
                            self.cityName = "Могилев"
                        case "22":
                            self.cityName = "Минск"
                        case "21":
                            self.cityName = "Гродно"
                        case "20":
                            self.cityName = "Гомель"
                        case "19":
                            self.cityName = "Витебск"
                        case "18":
                            self.cityName = "Брест"
                        case "17":
                            self.cityName = "Барановичи"
                        default:
                            self.cityName = "Неизвестный город"
                        }
                        self.userAttributesDict[self.userAttributesKey[7]] = self.cityName
                        
                    }
                }
                if userDict["image"] as? String != ""{
                    if let imageString = userDict["image"] as? String {
                        if let imageData = Data(base64Encoded: imageString) {
                            DispatchQueue.main.async {
                                guard let image = UIImage(data: imageData) else { return }
                                let buttonSize = self.buttonImageProfile.frame.size
                                let renderer = UIGraphicsImageRenderer(size: buttonSize)
                                let newImage = renderer.image { _ in
                                    image.draw(in: CGRect(origin: .zero, size: buttonSize))
                                }
                                self.buttonImageProfile.layer.borderWidth = 2
                                self.buttonImageProfile.layer.borderColor = UIColor.black.cgColor
                                self.buttonImageProfile.setImage(newImage, for: .normal)
                                self.buttonImageProfile.contentMode = .scaleAspectFit
                                self.buttonImageProfile.clipsToBounds = true
                                self.buttonImageProfile.layer.cornerRadius = buttonSize.width / 2.0
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.buttonImageProfile.setImage(UIImage(named: "LoadPhoto"), for: .normal)
                    }
                }
                if let organization = userDict["organization"] as? String {
                    DispatchQueue.main.async {
                        if self.typeUserData! == typeUser.customer.label{
                            self.userAttributesDict[self.userAttributesKey[9]] = organization
                        }
                    }
                }
                if let position = userDict["position"] as? String {
                    if self.typeUserData! == typeUser.customer.label{
                        DispatchQueue.main.async {
                            self.userAttributesDict[self.userAttributesKey[10]] = position
                        }
                    }
                }
                
                
            } else {
                print("Невозможно получить данные о пользователе")
                DispatchQueue.main.async {
                    self.showAlertErrorDataUser()
                }
            }
        }
    }
    
    func getDataManager(){
        getManagerData.dataGetManager(id: userIDData){ userData in
            if let userDict = userData {
                if let lastName = userDict["last_name"] as? String {
                    DispatchQueue.main.async {
                        self.userAttributesDict[self.userAttributesKey[0]] = lastName
                    }
                }
                if let firstName = userDict["first_name"] as? String {
                    DispatchQueue.main.async {
                        self.userAttributesDict[self.userAttributesKey[1]] = firstName
                    }
                }
                if let surName = userDict["sur_name"] as? String {
                    DispatchQueue.main.async {
                        self.userAttributesDict[self.userAttributesKey[2]] = surName
                    }
                }
                if let email = userDict["email"] as? String {
                    DispatchQueue.main.async {
                        self.userAttributesDict[self.userAttributesKey[3]] = email
                    }
                }
                if var password = userDict["password"] as? String {
                    password = "******"
                    DispatchQueue.main.async {
                        self.userAttributesDict[self.userAttributesKey[4]] = password
                    }
                }
                if var phone = userDict["phone_number"] as? String {
                    DispatchQueue.main.async {
                        self.userAttributesDict[self.userAttributesKey[5]] = phone
                    }
                }
                if let city = userDict["city"] as? String {
                    DispatchQueue.main.async {
                        switch city {
                        case "24":
                            self.cityName = "Мозырь"
                        case "23":
                            self.cityName = "Могилев"
                        case "22":
                            self.cityName = "Минск"
                        case "21":
                            self.cityName = "Гродно"
                        case "20":
                            self.cityName = "Гомель"
                        case "19":
                            self.cityName = "Витебск"
                        case "18":
                            self.cityName = "Брест"
                        case "17":
                            self.cityName = "Барановичи"
                        default:
                            self.cityName = "Неизвестный город"
                        }
                        self.userAttributesDict[self.userAttributesKey[6]] = self.cityName
                    }
                }
                if let discipline = userDict["discipline"] as? String {
                    DispatchQueue.main.async {
                        switch discipline {
                        case "1":
                            self.discName = "Дефиле"
                        case "2":
                            self.discName = "Фотопозирование"
                        case "3":
                            self.discName = "Фитнес"
                        case "4":
                            self.discName = "Психология"
                        case "5":
                            self.discName = "Пластика"
                        case "6":
                            self.discName = "Инстаграмоведение"
                        case "7":
                            self.discName = "Имидж"
                        case "8":
                            self.discName = "Актерское мастерство"
                        default:
                            self.discName = "Неизвестный город"
                        }
                        if self.typeUserData! == typeUser.teacher.label{
                            self.userAttributesDict[self.userAttributesKey[7]] = self.discName
                        }else{
                            self.userAttributesDict[self.userAttributesKey[7]] = "Директор"
                        }
                    }
                }
                if userDict["image"] as? String != ""{
                    if let imageString = userDict["image"] as? String {
                        if let imageData = Data(base64Encoded: imageString) {
                            DispatchQueue.main.async {
                                guard let image = UIImage(data: imageData) else { return }
                                let buttonSize = self.buttonImageProfile.frame.size
                                let renderer = UIGraphicsImageRenderer(size: buttonSize)
                                let newImage = renderer.image { _ in
                                    image.draw(in: CGRect(origin: .zero, size: buttonSize))
                                }
                                self.buttonImageProfile.layer.borderWidth = 2
                                self.buttonImageProfile.layer.borderColor = UIColor.black.cgColor
                                self.buttonImageProfile.setImage(newImage, for: .normal)
                                self.buttonImageProfile.contentMode = .scaleAspectFit
                                self.buttonImageProfile.clipsToBounds = true
                                self.buttonImageProfile.layer.cornerRadius = buttonSize.width / 2.0
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.buttonImageProfile.setImage(UIImage(named: "LoadPhoto"), for: .normal)
                    }
                }
            } else {
                print("Невозможно получить данные о пользователе")
                DispatchQueue.main.async {
                    self.showAlertErrorDataUser()
                }
            }
        }
    }
}

extension EditUserProfileViewController: UITableViewDelegate, UITableViewDataSource,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch typeUserData {
        case "user":
            return 9
        case "student":
            return 9
        case "teacher":
            return 9
        case "customer":
            return 11
        case "director":
            return 9
        case "manager":
            return 9
        default:
            return 9
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileEditTableViewCell.self)) as! ProfileEditTableViewCell
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.black.cgColor
        cell.textCellCustom.placeholder = self.userAttributesDict[self.userAttributesKey[indexPath.item]] as? String
        cell.labelCellCustom.text = self.userAttributesKey[indexPath.item]
        if cell.labelCellCustom.text == "Изображение"{
            cell.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
    //Обработчик загрузик изображения
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            dataImage = selectedImage
            
            
            let buttonSize = self.buttonImageProfile.frame.size
            let renderer = UIGraphicsImageRenderer(size: buttonSize)
            let newImage = renderer.image { _ in
                selectedImage.draw(in: CGRect(origin: .zero, size: buttonSize))
            }
            
            self.buttonImageProfile.layer.borderWidth = 2
            self.buttonImageProfile.layer.borderColor = UIColor.black.cgColor
            self.buttonImageProfile.setImage(newImage, for: .normal)
            self.buttonImageProfile.contentMode = .scaleAspectFit
            self.buttonImageProfile.clipsToBounds = true
            self.buttonImageProfile.layer.cornerRadius = buttonSize.width / 2.0
        }
        dismiss(animated: true, completion: nil)
    }
    
}

