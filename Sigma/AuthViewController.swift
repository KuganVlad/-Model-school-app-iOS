//
//  AuthViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 12.03.23.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var loginAuthUiTextField: UITextField!
    @IBOutlet weak var passAuthUiTextField: UITextField!
    @IBOutlet weak var authUiButton: UIButton!
    @IBOutlet weak var labelAuth: UILabel!
    
    let authUser = AuthApplication()
    let authManager = AuthMangerApplication()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUiButton.isEnabled = false
        authUiButton.setImage(UIImage(named: "ВойтиНеАкт"), for: .normal)
        authUiButton.contentMode = .scaleToFill
        
    }
    

    
    
    @IBAction func loginCheckTextField(_ sender: UITextField) {
        if (!loginAuthUiTextField.isEmpty && !passAuthUiTextField.isEmpty){
            authUiButton.isEnabled = true
            authUiButton.setImage(UIImage(named: "ВойтиАкт"), for: .normal)
            authUiButton.contentMode = .scaleToFill
        }else{
            authUiButton.isEnabled = false
            authUiButton.setImage(UIImage(named: "ВойтиНеАкт"), for: .normal)
            authUiButton.contentMode = .scaleToFill
        }
    }
    
    @IBAction func passChecktTextField(_ sender: UITextField) {
        if (!loginAuthUiTextField.isEmpty && !passAuthUiTextField.isEmpty){
            authUiButton.isEnabled = true
            authUiButton.setImage(UIImage(named: "ВойтиАкт"), for: .normal)
            authUiButton.contentMode = .scaleToFill
        }else{
            authUiButton.isEnabled = false
            authUiButton.setImage(UIImage(named: "ВойтиНеАкт"), for: .normal)
            authUiButton.contentMode = .scaleToFill
        }
    }
    
    @IBAction func touchAuthUiButton(_ sender: UIButton) {
        guard let loginData = loginAuthUiTextField.text else { return }
        guard let passwordData = passAuthUiTextField.text else { return }
        
        
        
        self.authUser.authUsers(email: loginData, password: passwordData) { [self] arrResult in
            if let result = arrResult {
                let dataType:String?
                switch result["type"] as? String {
                case "1":
                    dataType = typeUser.user.label
                case "2":
                    dataType = typeUser.student.label
                case "3":
                    dataType = typeUser.customer.label
                case "4":
                    dataType = typeUser.teacher.label
                case "5":
                    dataType = typeUser.director.label
                case "6":
                    dataType = typeUser.manager.label
                default:
                    dataType = typeUser.user.label
                }
                UserDefaults.standard.set(result["jwt"], forKey: "jwtToken")
                UserDefaults.standard.set(dataType, forKey: "userType")
                UserDefaults.standard.set(result["id"], forKey: "userID")
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCTabBar") as! VCTabBar
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                self.authManager.authManager(email: loginData, password: passwordData) { [self] arrResult in
                    if let result = arrResult {
                        let dataType:String?
                        switch result["type"] as? String {
                        case "1":
                            dataType = typeUser.user.label
                        case "2":
                            dataType = typeUser.student.label
                        case "3":
                            dataType = typeUser.customer.label
                        case "4":
                            dataType = typeUser.teacher.label
                        case "5":
                            dataType = typeUser.director.label
                        case "6":
                            dataType = typeUser.manager.label
                        default:
                            dataType = typeUser.user.label
                        }
                        UserDefaults.standard.set(result["jwt"], forKey: "jwtToken")
                        UserDefaults.standard.set(dataType, forKey: "userType")
                        UserDefaults.standard.set(result["id"], forKey: "userID")
                        DispatchQueue.main.async {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCTabBar") as! VCTabBar
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else{
                        print("Failed to login user")
                        DispatchQueue.main.async {
                            self.showAlertUserLogin()
                        }
                    }
                }
            }
        }
    }
    
    
    
    private func showAlertUserLogin(){
        let alert = UIAlertController(title: "Уведомление!", message: "Неверный логин или пароль", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
