//
//  UserProfileViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 25.03.23.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    
    
    @IBOutlet weak var userProfileCollectionView: UICollectionView!
    var typeUserData:String!
    var userIDData:String!
    let userButtonData = UserProfileVC()
    let imageButtonData = ImageButtonClass()
    let getUserData = GetUserData()
    let getManagerData = GetManagerData()
    var viewControllerNames: [String] = []
    var imageButton: [String] = []
    var cityName:String = "City"
    var discName:String = "Дисциплина"
    
    
    
    @IBOutlet weak var userProfImage: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var cityUserLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeUserData = UserDefaults.standard.object(forKey: "userType") as? String
        userIDData = UserDefaults.standard.object(forKey: "userID") as? String
        viewControllerNames = userButtonData.buttonToTypeUser(typeUser: typeUserData)
        imageButton = imageButtonData.imageToTypeUser(typeUser: typeUserData)
        
        userProfileCollectionView.dataSource = self
        userProfileCollectionView.delegate = self
        // Регистрируем ячейку для collection view
        userProfileCollectionView.register(ButtonProfileCollectionViewCell.self, forCellWithReuseIdentifier: "ButtonProfileCollectionViewCell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if (typeUserData! == typeUser.user.label ||
            typeUserData! == typeUser.student.label ||
            typeUserData! == typeUser.customer.label){
            getUserDataProfile()
        }else{
            getManagerDataProfile()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (typeUserData! == typeUser.user.label ||
            typeUserData! == typeUser.student.label ||
            typeUserData! == typeUser.customer.label){
            getUserDataProfile()
        }else{
            getManagerDataProfile()
        }
    }


    
    //Выход в меню
    @IBAction func exitMenuButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "jwtToken")
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "userType")
        UserDefaults.standard.removeObject(forKey: "cityUser")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let rootViewController = storyboard.instantiateInitialViewController(),
           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let mainWindow = windowScene.windows.first {
            mainWindow.rootViewController = rootViewController
            mainWindow.makeKeyAndVisible()
        }
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    //Переход 
    @objc func buttonTapped(_ sender: UIButton) {
        // Получаем индекс ячейки, в которой была нажата кнопка
        let point = sender.convert(CGPoint.zero, to: userProfileCollectionView)
        if let indexPath = userProfileCollectionView.indexPathForItem(at: point) {
            // Получаем название view controller'а для перехода
            let viewControllerName = viewControllerNames[indexPath.row % viewControllerNames.count]
            
            // Создаем экземпляр view controller'а и переходим на него
            let viewController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: viewControllerName)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
    private func showAlertErrorDataUser(){
        let alert = UIAlertController(title: "Уведомление!", message: "Невозможно получить данные о текущем пользователе, повторите попытку позже", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    
    
    
    
    func getUserDataProfile(){
        //Получение сведений о пользователе с БД
        getUserData.getUsers(id: userIDData){ userData in
            if let userDict = userData {
                if let lastName = userDict["last_name"] as? String {
                    DispatchQueue.main.async {
                        self.secondNameLabel.text = lastName
                    }
                }
                if let organization = userDict["organization"] as? String {
                    DispatchQueue.main.async {
                        if self.typeUserData! == typeUser.customer.label{
                            self.cityUserLabel.text = organization
                        }
                    }
                }
                if let firstName = userDict["first_name"] as? String {
                    DispatchQueue.main.async {
                        self.firstNameLabel.text = firstName
                    }
                }
                if let surName = userDict["last_name"] as? String {
                    DispatchQueue.main.async {
                        self.secondNameLabel.text = surName
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
                        UserDefaults.standard.set(self.cityName, forKey: "cityUser")
                        if self.typeUserData! == typeUser.user.label{
                            self.cityUserLabel.text = self.cityName
                        }
                    }
                }
                if let group = userDict["group"] as? String {
                    DispatchQueue.main.async {
                        if self.typeUserData == typeUser.student.label{
                            self.cityUserLabel.text = group
                        }
                    }
                }
                if let position = userDict["position"] as? String {
                    if self.typeUserData! == typeUser.customer.label{
                        DispatchQueue.main.async {
                            self.cityUserLabel.text! += ", \(position)"
                        }
                    }
                }
                if userDict["image"] as? String != ""{
                    if let imageString = userDict["image"] as? String {
                        if let imageData = Data(base64Encoded: imageString) {
                            DispatchQueue.main.async {
                                let image = UIImage(data: imageData)
                                
                                let buttonSize = self.userProfImage.frame.size
                                let renderer = UIGraphicsImageRenderer(size: buttonSize)
                                let newImage = renderer.image { _ in
                                    image?.draw(in: CGRect(origin: .zero, size: buttonSize))
                                }
                                self.userProfImage.layer.borderWidth = 3
                                self.userProfImage.layer.borderColor = UIColor.black.cgColor
                                self.userProfImage.image = newImage
                                self.userProfImage.contentMode = .scaleAspectFit
                                self.userProfImage.clipsToBounds = true
                                self.userProfImage.layer.cornerRadius =  self.userProfImage.frame.size.width / 2
                            }
                        }
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        self.userProfImage.image = UIImage(named: "avatar")
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
    
    func getManagerDataProfile(){
        getManagerData.dataGetManager(id: userIDData){ userData in
            if let userDict = userData {
                if let lastName = userDict["last_name"] as? String {
                    DispatchQueue.main.async {
                        self.secondNameLabel.text = lastName
                    }
                }
                if let firstName = userDict["first_name"] as? String {
                    DispatchQueue.main.async {
                        self.firstNameLabel.text = firstName
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
                        UserDefaults.standard.set(self.cityName, forKey: "cityUser")
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
                            self.discName = "Преподаватель"
                        }
                        if self.typeUserData! == typeUser.teacher.label{
                            self.cityUserLabel.text = self.discName
                        }else{
                            self.cityUserLabel.text = "Директор"
                        }
                    }
                }
                if userDict["image"] as? String != ""{
                    if let imageString = userDict["image"] as? String {
                        if let imageData = Data(base64Encoded: imageString) {
                            DispatchQueue.main.async {
                                let image = UIImage(data: imageData)
                                let buttonSize = self.userProfImage.frame.size
                                let renderer = UIGraphicsImageRenderer(size: buttonSize)
                                let newImage = renderer.image { _ in
                                    image?.draw(in: CGRect(origin: .zero, size: buttonSize))
                                }
                                self.userProfImage.layer.borderWidth = 3
                                self.userProfImage.layer.borderColor = UIColor.black.cgColor
                                self.userProfImage.image = newImage
                                self.userProfImage.contentMode = .scaleAspectFit
                                self.userProfImage.clipsToBounds = true
                                self.userProfImage.layer.cornerRadius =  self.userProfImage.frame.size.width / 2
                            }
                        }
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        self.userProfImage.image = UIImage(named: "avatar")
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

extension UserProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllerNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonProfileCollectionViewCell", for: indexPath) as! ButtonProfileCollectionViewCell
        
        // Устанавливаем изображение для кнопки
        cell.button.setImage(UIImage(named: imageButton[indexPath.row % imageButton.count]), for: .normal)
        
        cell.button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Устанавливаем размер ячейки
        let width = (collectionView.bounds.width - 20) / 3
        return CGSize(width: width, height: width)
    }
}




