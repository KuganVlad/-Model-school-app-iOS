//
//  ProjectUserViewController.swift
//  Sigma
//
//  Created by Vlad Kugan on 31.03.23.
//

import UIKit

class ProjectUserViewController: UIViewController {

    let getUserProject = UserGetProject()
    var projectSortedArr: [[String: Any]] = []
    
    @IBOutlet weak var projectUserCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectUserCollectionView.dataSource = self
        projectUserCollectionView.delegate = self
        self.title = ""

        getDataProject()
        
        let layout = UICollectionViewFlowLayout()
        let itemWidth = self.projectUserCollectionView.bounds.width
        let itemHeight = self.projectUserCollectionView.bounds.height / 8
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.projectUserCollectionView.collectionViewLayout = layout
        
        
        projectUserCollectionView.register(UINib(nibName: "ProjectUserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProjectUserCollectionViewCell")
 
    }
    

    

    func getDataProject(){
        getUserProject.getProjectUser(){ responseArray in
            if let projectArr = responseArray {
                self.projectSortedArr = projectArr
                
            }
        }
    }

}


extension ProjectUserViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectSortedArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectUserCollectionViewCell", for: indexPath) as! ProjectUserCollectionViewCell
        
        let projectData = projectSortedArr[indexPath.item]

        let attributedText = NSMutableAttributedString()

        if let name = projectData["name"] as? String {
            let boldText = "\(name)\n"
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 28)]
            attributedText.append(NSAttributedString(string: boldText, attributes: attributes))
        }
        if let location = projectData["location"] as? String {
            attributedText.append(NSAttributedString(string: "\(location)\n"))
        }
        if let date = projectData["date"] as? String {
            attributedText.append(NSAttributedString(string: "\(date)\n"))
        }
        if let projectText = projectData["text"] as? String {
            attributedText.append(NSAttributedString(string: "\(projectText)\n"))
        }
        if let textUser = projectData["text_user"] as? String {
            attributedText.append(NSAttributedString(string: "\(textUser)\n"))
        }
        if let contact = projectData["contact"] as? String {
            attributedText.append(NSAttributedString(string: "\(contact)"))
        }


        cell.labelData.layer.borderWidth = 2
        cell.labelData.layer.cornerRadius = 20
        cell.labelData.layer.masksToBounds = true
        if (indexPath.row % 2 == 0){
            cell.labelData.backgroundColor = .black
            cell.labelData.layer.borderColor = UIColor.white.cgColor
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedText.length))
        }else{
            cell.labelData.layer.borderColor = UIColor.black.cgColor
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: attributedText.length))
        }
        
        cell.labelData.attributedText = attributedText

        
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let projectData = projectSortedArr[indexPath.item]
        var labelText = ""
        if let name = projectData["name"] as? String {
            labelText += "\(name)\n"
        }
        if let location = projectData["location"] as? String {
            labelText += "\(location)\n"
        }
        if let date = projectData["date"] as? String {
            labelText += "\(date)\n"
        }
        if let projectText = projectData["text"] as? String {
            labelText += "\(projectText)\n"
        }
        if let textUser = projectData["text_user"] as? String {
            labelText += "\(textUser)\n"
        }
        if let contact = projectData["contact"] as? String {
            labelText += "\(contact)"
        }
        let font = UIFont.systemFont(ofSize: 25)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragraphStyle]
        let size = (labelText as NSString).boundingRect(with: CGSize(width: collectionView.bounds.width, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)


        let labelSize = CGSize(width: collectionView.frame.width, height: size.height + 40)
        return labelSize
    }

    
    
}
