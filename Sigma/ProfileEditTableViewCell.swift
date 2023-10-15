//
//  ProfileEditTableViewCell.swift
//  Sigma
//
//  Created by Vlad Kugan on 10.04.23.
//

import UIKit


class ProfileEditTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCellCustom: UILabel!
    @IBOutlet weak var textCellCustom: UITextField!
    


    
    override func awakeFromNib() {
        super.awakeFromNib()
        textCellCustom.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
