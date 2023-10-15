//
//  ParthnerViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 30.03.23.
//

import UIKit

class ParthnerViewController: UIViewController {

    var imagesParthnerArray = [UIImage]()
    
    let offset: CGFloat = 2.0
    let verticalCountSells = 2
    
    @IBOutlet weak var parthnerCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parthnerCollectionView.dataSource = self
        parthnerCollectionView.delegate = self
        
        for i in 0...10{
            let image = UIImage(named: "parthner\(i)")!
            imagesParthnerArray.append(image)
        }
    }
}

extension ParthnerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesParthnerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageParthnerIdentificator", for: indexPath) as! ParthnerCollectionViewCell
        let image = imagesParthnerArray[indexPath.item]
        cell.parthnerImage.image = image
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let frameCurrentCV = collectionView.frame
            let widthCell = frameCurrentCV.width / CGFloat(verticalCountSells)
            let heightCell = widthCell * 2
            let spacing = CGFloat(verticalCountSells + 1) * offset / CGFloat(verticalCountSells)
            return CGSize(width: widthCell - spacing, height: heightCell - offset*2)
    }
    
}
