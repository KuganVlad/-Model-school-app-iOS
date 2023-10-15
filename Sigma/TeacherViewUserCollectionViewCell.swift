//
//  TeacherViewUserCollectionViewCell.swift
//  Sigma
//
//  Created by Vlad Kugan on 13.04.23.
//

import UIKit

class TeacherViewUserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageTeacherImageView: UIImageView!
    
    @IBOutlet weak var labelTeacherName: UILabel!
    
    @IBOutlet weak var labelTeacherLastName: UILabel!
    
    @IBOutlet weak var labelTeacherPosition: UILabel!
    
    @IBOutlet weak var labelTeacherPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
