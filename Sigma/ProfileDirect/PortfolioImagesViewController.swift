//
//  PortfolioImagesViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 16.04.23.
//

import UIKit

class PortfolioImagesViewController: UIViewController {

    var photosArray = [UIImage]()
    
    let offset: CGFloat = 2.0
    let verticalCountSells = 2
    
    @IBOutlet weak var portfolioWaterfallCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(photosArray)
        portfolioWaterfallCollectionView.dataSource = self
        portfolioWaterfallCollectionView.delegate = self
        setupCollectionView()

    }
    func setupCollectionView(){
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        // Collection view attributes
        portfolioWaterfallCollectionView.alwaysBounceVertical = true
        // Add the waterfall layout to your collection view
        portfolioWaterfallCollectionView.collectionViewLayout = layout
    }

}

extension PortfolioImagesViewController: UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout{
    //возвращает количество элементов в коллекции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            //метод переиспользования ячеек
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePortfolioCollectionViewCell", for: indexPath) as! ImagePortfolioCollectionViewCell
            let image = photosArray[indexPath.item]
            cell.portfolioImageView.image = image
            return cell
    }
    
    //Метод изменения размера элемента по ключу (Делегат UICollectionViewDelegateFlowLayout)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            let frameCurrentCV = collectionView.frame
            let widthCell = frameCurrentCV.width / CGFloat(verticalCountSells)
            let heightCell = CGFloat.random(in: 200...400)
            let spacing = CGFloat(verticalCountSells + 1) * offset / CGFloat(verticalCountSells)
            return CGSize(width: widthCell - spacing, height: heightCell - offset*2)
        }else{
            let frameCurrentCV = collectionView.frame
            let widthCell = frameCurrentCV.width / CGFloat(verticalCountSells)
            let heightCell = widthCell * 2
            let spacing = CGFloat(verticalCountSells + 1) * offset / CGFloat(verticalCountSells)
            return CGSize(width: widthCell - spacing, height: heightCell - offset*2)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PortfolioWaterfallViewController") as! PortfolioWaterfallViewController
        vc.imageWaterfall = photosArray
        vc.indexPath = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


