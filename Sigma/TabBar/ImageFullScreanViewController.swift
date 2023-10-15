//
//  ImageFullScreanViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 2.04.23.
//

import UIKit

class ImageFullScreanViewController: UIViewController {
    var imageWaterfall: ImageGalaryHome!
    let countCells = 1
    var indexPath: IndexPath!
    @IBOutlet weak var imageFullScrean: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageFullScrean.image = imageWaterfall.imagesArray[indexPath.item]
    }
    
}

