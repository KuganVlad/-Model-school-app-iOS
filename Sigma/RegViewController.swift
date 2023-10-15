//
//  RegViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 12.03.23.
//
import UIKit

class RegViewController: UIViewController {

    @IBOutlet weak var emailRegUiTextField: UITextField!
    @IBOutlet weak var passRegUiTextField: UITextField!
    @IBOutlet weak var nextRegUiButton: UIButton!
    @IBOutlet weak var regTextView: UITextView!
    
    let registrationUser = RegistrationUser()
    var strData: String = ""
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextRegUiButton.isEnabled = false
        nextRegUiButton.setImage(UIImage(named: "ДалееНеАктивная"), for: .normal)
        nextRegUiButton.contentMode = .scaleToFill
        
        regTextView.addHyperLinksToText(originalText: "Нажимая «Далее», вы подтверждаете, что ознакомлены и принимаете условия Соглашения, и даете согласие на обработку персональных данных в соответствии с условиями Соглашения", hyperLinks: ["Соглашения": "https://clck.ru/342anz",])
    }
    
    @IBAction func checkLoginActionTextField(_ sender: Any) {
        updateNextButtonState()
    }
    
    @IBAction func checkPassActionTextFiled(_ sender: Any) {
        updateNextButtonState()
    }
    
    // обновляем состояние кнопки "Далее"
    private func updateNextButtonState() {
        if (!emailRegUiTextField.isEmpty && !passRegUiTextField.isEmpty){
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
            if emailPredicate.evaluate(with: emailRegUiTextField.text) {
                nextRegUiButton.isEnabled = true
                nextRegUiButton.setImage(UIImage(named: "ДалееАктивная"), for: .normal)
                nextRegUiButton.contentMode = .scaleToFill
            }
        }else{
            nextRegUiButton.isEnabled = false
            nextRegUiButton.setImage(UIImage(named: "ДалееНеАктивная"), for: .normal)
            nextRegUiButton.contentMode = .scaleToFill
        }
    }
    
    @IBAction func nextButtonReg(_ sender: UIButton) {
        guard let loginData = emailRegUiTextField.text else { return }
        guard let passwordData = passRegUiTextField.text else { return }
        registrationUser.createUser(email: loginData, password: passwordData) { codeAuth in
            if codeAuth != nil {
                self.strData = loginData
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AuthKeyViewController") as! AuthKeyViewController
                    vc.stringLoginCheck = self.strData // Передача данных в свойство data второго view controller'а
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                print("Failed to create user")
                DispatchQueue.main.async {
                    self.showAlertUserCreated()
                }
            }
        }
    }
    
    private func showAlertUserCreated(){
        let alert = UIAlertController(title: "Уведомление!", message: "Невозможно зарегистрировать пользователя с указанной электронной почтой", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)

    }
}
