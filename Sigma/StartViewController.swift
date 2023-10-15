//
//  StartViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 12.03.23.
//

import UIKit

class StartViewController: UIViewController {
    
    let checkTokenJWT = AuthJWTApplication()
    var arrDataUser: [String] = []
    
    @IBOutlet weak var signedInUiButton: UIButton!
    @IBOutlet weak var signedUpUiButton: UIButton!
    
    @IBOutlet weak var fbUiButton: UIButton!
    @IBOutlet weak var vkUiButton: UIButton!
    @IBOutlet weak var instUiButton: UIButton!
    @IBOutlet weak var ytUiButton: UIButton!
    @IBOutlet weak var tgUiButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let dataInformaion = UserDefaults.standard.object(forKey: "jwtToken") as? String else {return}
        checkTokenJWT.authUsers(token: dataInformaion) { [self] arrResult in
            if let result = arrResult {
                let dataType:String?
                switch result[1] {
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
                UserDefaults.standard.set(result[0], forKey: "userID")
                UserDefaults.standard.set(dataType, forKey: "userType")
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCTabBar") as! VCTabBar
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        self.navigationController?.navigationBar.isHidden = true
//    }

    @IBAction func touchsignUpUiButton(_ sender: UIButton) {

    }
    
    @IBAction func faceBookUIButtonTouch(_ sender: UIButton) {
        if let url = URL(string: "https://www.facebook.com/sigmascoutingbelarus/"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @IBAction func vkUiButtonTouch(_ sender: UIButton) {
        if let url = URL(string: "https://vk.com/sigma_belarus"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func instagramUIButtonTouch(_ sender: UIButton) {
        if let url = URL(string: "https://www.instagram.com/sigma_belarus/"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func youTubeUIButtonTouch(_ sender: UIButton) {
        if let url = URL(string: "https://www.youtube.com/channel/UCDr6-RRH6Vy3Vx8KRhxO9cA"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    

    @IBAction func telegramUIButtonTouch(_ sender: UIButton) {
        if let url = URL(string: "https://t.me/sigmamodels"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
}
