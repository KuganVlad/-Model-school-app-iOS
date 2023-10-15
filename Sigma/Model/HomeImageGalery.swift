//
//  HomeImageGalery.swift
//  Sigma
//
//  Created by Vlad Kugan on 2.04.23.
//

import Foundation
import UIKit

class ImageGalaryHome{
    
    var imagesArray = [UIImage]()
    
    init() {
        arrayInitial()
    }
    
    func arrayInitial() -> Void {
        for i in 0...11{
            let image = UIImage(named: "image\(i)")!
            imagesArray.append(image)
        }
    }
}
