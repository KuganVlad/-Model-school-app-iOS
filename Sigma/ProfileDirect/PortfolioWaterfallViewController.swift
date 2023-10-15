//
//  PortfolioWaterfallViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 16.04.23.
//

import UIKit

class PortfolioWaterfallViewController: UIViewController {

    
    
    var imageWaterfall = [UIImage]()
    let countCells = 1
    var indexPath: IndexPath!
    
    
    @IBOutlet weak var imageFullScreen: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageFullScreen.image = imageWaterfall[indexPath.item]
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
