//
//  UserProfileViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 23.03.23.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userIconImageView.layer.cornerRadius = 55
        userIconImageView.layer.borderWidth = 3.0
        userIconImageView.layer.borderColor = UIColor.lightGray.cgColor
        
    }

}
