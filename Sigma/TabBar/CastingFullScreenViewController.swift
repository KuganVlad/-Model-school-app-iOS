//
//  CastingFullScreenViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 9.04.23.
//

import UIKit
import MapKit

class CastingFullScreenViewController: UIViewController {

    @IBOutlet weak var mapKitDData: MKMapView!
    @IBOutlet weak var labelCastinData: UILabel!
    @IBOutlet weak var buttonCastinMakeAn: UIButton!
    var labelDataCasting:String?
    var castingID:String?
    let castingRecord = CastingAddCount()
    let userCastingRecord = CastingRecordUser()
    
    
    
    let typeUserData = UserDefaults.standard.object(forKey: "userType") as? String
    let idUser = UserDefaults.standard.object(forKey: "userID") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        if(typeUserData != typeUser.user.label){
            buttonCastinMakeAn.isHidden = true
        }
        
        
        labelCastinData.text = labelDataCasting
        let lines = labelDataCasting?.components(separatedBy: "\n")
        if let lastLine = lines?.last {
            let words = lastLine.components(separatedBy: " ")
            if words.count == 3 {
                castingID = String(words[2])
                if let xCoard = Double(words[0]), let yCoard = Double(words[1]){
                    let location = CLLocationCoordinate2D(latitude: xCoard, longitude: yCoard)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    mapKitDData.addAnnotation(annotation)
                    let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
                    mapKitDData.setRegion(region, animated: true)
                }
            }
        }
    }

    @IBAction func buttonCastinTouch(_ sender: UIButton) {
        guard let idCas = castingID else { return }
        guard let idUs = idUser else { return }
        userCastingRecord.castingRecUser(id: idUs, casting: idCas){ codeAuth in
            if "record" == codeAuth {
                self.castingRecord.castingAddCount(id: idCas)
                DispatchQueue.main.async {
                    self.showAlertRecorCasting()
                }
            }else {
                DispatchQueue.main.async {
                    self.showAlertErrorRecorCasting()
                }
            }
        }
    }
    
    
    private func showAlertRecorCasting(){
        let alert = UIAlertController(title: "Уведомление!", message: "Вы записались на данный кастинг", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    private func showAlertErrorRecorCasting(){
        let alert = UIAlertController(title: "Уведомление!", message: "Вы не можете записаться на данный кастинг", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

