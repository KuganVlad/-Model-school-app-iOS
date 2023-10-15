//
//  AuthKeyViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 12.03.23.
//

import UIKit

class AuthKeyViewController: UIViewController {

    @IBOutlet weak var authCodeUiTextField: UITextField!
    @IBOutlet weak var regUiButton: UIButton!
    var stringLoginCheck: String?
    let checkEmailData = EmailCodeCheck()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAlertKeyAuth()
        regUiButton.isEnabled = false
        regUiButton.setImage(UIImage(named: "ЗарегистрироватьсяНеАкт"), for: .normal)
        regUiButton.contentMode = .scaleToFill

    }

    //Обработчик действия по вводу текста
    @IBAction func codeCheckTextField(_ sender: UITextField) {
        if (!authCodeUiTextField.isEmpty && sender.text!.count >= 6){
            regUiButton.isEnabled = true
            regUiButton.setImage(UIImage(named: "ЗарегистрироватьсяАкт"), for: .normal)
            regUiButton.contentMode = .scaleToFill
        }else{
            regUiButton.isEnabled = false
            regUiButton.setImage(UIImage(named: "ЗарегистрироватьсяНеАкт"), for: .normal)
            regUiButton.contentMode = .scaleToFill
        }
    }

    //Обработчик кнопки регистрации
    @IBAction func regTouchUiButton(_ sender: UIButton) {
        guard let codeCheck = authCodeUiTextField.text else { return }
        guard let dataLogin = stringLoginCheck else { return }
        checkEmailData.createUser(email: dataLogin, code: codeCheck) { codeAuth in
                if codeAuth != nil {
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: false)
                        self.showAlertConfirmAuth()
                    }
                } else {
                    print("Введён неверный код")
                    DispatchQueue.main.async {
                        self.showAlertErrorServer()
                    }
                    
                }
            }
        }
    //Алерт при открытии окна
    private func showAlertKeyAuth(){
        let alert = UIAlertController(title: "Уведомление!", message: "На указанный вами ящик электронной почты направлено письмо с проверочным кодом. Введите код из письма в соответствующие поле", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    //Алерт при нажатии кнопки
    private func showAlertConfirmAuth(){
        let alert = UIAlertController(title: "Уведомление!", message: "Вы успешно зарегистрированы", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)

    }

    private func showAlertNotAuth(){
        let alert = UIAlertController(title: "Уведомление!", message: "Вы ввели неверный код, проверьте свою электронную почту", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)

    }
    
    private func showAlertErrorServer(){
        let alert = UIAlertController(title: "Уведомление!", message: "Не удалось проверить код - повторите попытку позже", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)

    }

}

