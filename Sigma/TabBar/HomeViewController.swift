//
//  HomeViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 25.03.23.
//

import UIKit

class HomeViewController: UIViewController {
    
    var dataUserType:String!
    //Массив для изображений
    var imageWaterfall = ImageGalaryHome()
    
    let offset: CGFloat = 2.0
    let verticalCountSells = 2
    
    @IBOutlet weak var verticalCollectionView: UICollectionView!
      
    override func viewDidLoad() {
        super.viewDidLoad()
        verticalCollectionView.dataSource = self
        verticalCollectionView.delegate = self
        setupCollectionView()
        
        //Заполнение массива с изображениями
       
    }
    
    
    func setupCollectionView(){
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        // Collection view attributes
        verticalCollectionView.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        verticalCollectionView.collectionViewLayout = layout
    }
}
    //UICollectionViewDelegateFlowLayout или CHTCollectionViewDelegateWaterfallLayout
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout{
    //возвращает количество элементов в коллекции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageWaterfall.imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            //метод переиспользования ячеек
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "verticalCellImage", for: indexPath) as! VerticalImageCollectionViewCell
            let image = imageWaterfall.imagesArray[indexPath.item]
            cell.vertImageView.image = image
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "ImageFullScreanViewController") as! ImageFullScreanViewController
        vc.imageWaterfall = imageWaterfall
        vc.indexPath = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


