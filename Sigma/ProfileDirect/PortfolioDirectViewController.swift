//
//  PortfolioDirectViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 31.03.23.
//

import UIKit

class PortfolioDirectViewController: UIViewController {
    

    @IBOutlet weak var kidsButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var ageButton: UIButton!
    @IBOutlet weak var menButton: UIButton!
    @IBOutlet weak var womanButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        
    }
    

    @IBAction func touchKidsButton(_ sender: UIButton) {
        let arrayPhotoLink = [
            "https://mommyagency.com/wp-content/uploads/2022/03/photo_2022-11-21_15-00-39-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2023/03/photo_2023-03-30_11-44-10-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2021/07/imgonline-com-ua-Black-White-szapxCAVBDLr0iJW-1-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2021/05/imgonline-com-ua-Black-White-vAPcasvy3i532Y-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2021/06/photoeditorsdk-export-5-1-768x845.png",
            "https://mommyagency.com/wp-content/uploads/2022/09/photo_2022-09-05_12-41-30-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2021/05/uyt-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2022/06/photo_2022-06-09_10-22-19-2-1-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2022/01/imgonline-com-ua-Black-White-7P5xs7EhcFyMZVK-1-768x845.jpg"
           
        ]
        if !arrayPhotoLink.isEmpty{
            goToDestinationViewController(array: arrayPhotoLink)
        }

    }
    
    @IBAction func touchWomenButton(_ sender: UIButton) {
        let arrayPhotoLink = [
            "https://mommyagency.com/wp-content/uploads/2021/02/photo_2022-02-17_09-58-47-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2021/05/MAINPAGE-1-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2021/02/Zaichik_AD3_7-scaled-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2021/02/bdb00903-1fc4-496d-9963-e63dfae5124f-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2021/05/photoeditorsdk-export-768x845.png",
            "https://mommyagency.com/wp-content/uploads/2021/02/imgonline-com-ua-Black-White-Ol4Vvw5B5VGVP-1-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2021/02/12-768x845.jpg",
            "https://mommyagency.com/m/vanilla/",
            "https://mommyagency.com/wp-content/uploads/2021/02/photo_2023-01-25_16-41-35-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2021/02/temmy-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2022/03/imgonline-com-ua-Black-White-KayZr29VROF-768x845.jpg"
            
        ]
        if !arrayPhotoLink.isEmpty{
            goToDestinationViewController(array: arrayPhotoLink)
        }
        
    }
    
    @IBAction func touchMenButton(_ sender: UIButton) {
        let arrayPhotoLink = [
            "https://mommyagency.com/wp-content/uploads/2022/05/photo_2022-05-24_16-36-16-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2021/05/MAINPAGE-3-300x330.jpg",
            "https://mommyagency.com/wp-content/uploads/2022/03/imgonline-com-ua-Black-White-T2QJ2rRCQCbVkb-1-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2022/08/photo_2022-08-04_14-34-32-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2022/08/photo_2022-08-04_17-10-17-2-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2023/01/photo_2023-01-26_17-56-54-4-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2022/08/photo_2022-08-04_16-40-32-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2022/09/photo_2022-09-06_17-43-10-2-768x845.jpg",
            "https://mommyagency.com/wp-content/uploads/2021/08/ГЛАВНАЯ-768x845.jpg"
        ]
        if !arrayPhotoLink.isEmpty{
            goToDestinationViewController(array: arrayPhotoLink)
        }
    }
    
    @IBAction func touchAgeButton(_ sender: UIButton) {
    
        let arrayPhotoLink = [
            "https://mommyagency.com/wp-content/uploads/2022/03/photo_2022-01-19_07-27-36-4-768x845.jpg",
        ]
        if !arrayPhotoLink.isEmpty{
            goToDestinationViewController(array: arrayPhotoLink)
        }
    }
    
    @IBAction func touchFavButton(_ sender: UIButton) {
        
    }

    
    func goToDestinationViewController(array: [String]) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "PortfolioImagesViewController") as! PortfolioImagesViewController
        let session = URLSession.shared
        var loadedPhotos = [UIImage]()
        let group = DispatchGroup()
        
        for urlString in array {
            group.enter()
            if let url = URL(string: urlString) {
                let task = session.dataTask(with: url, completionHandler: { data, response, error in
                    if let data = data, let photo = UIImage(data: data) {
                        loadedPhotos.append(photo)
                    }
                    group.leave()
                })
                task.resume()
            } else {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            destinationVC.photosArray = loadedPhotos
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
}
