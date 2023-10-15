//
//  TeacherViewManagerCollectionViewCell.swift
//  Sigma
//
//  Created by Vlad Kugan on 19.04.23.
//

import UIKit

class TeacherViewManagerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var teacherImage: UIImageView!
    
    
    @IBOutlet weak var teacherFirstName: UILabel!
    
    
    @IBOutlet weak var teacherLastName: UILabel!
    
    
    @IBOutlet weak var teacherPosition: UILabel!
    
    @IBOutlet weak var teacherPhone: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
