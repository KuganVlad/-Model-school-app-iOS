//
//  UserEditProfileSettingsViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 23.03.23.
//

import UIKit

class UserEditProfileSettingsViewController: UIViewController {

    @IBOutlet weak var textTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTestView"{
            let text = textTextField.text
            let newVC = segue.destination as! TestViewController
            newVC.textFromVC = text
        }
            
    }
}
