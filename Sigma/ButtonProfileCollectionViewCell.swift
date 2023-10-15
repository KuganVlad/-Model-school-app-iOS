//
//  ButtonProfileCollectionViewCell.swift
//  Sigma
//
//  Created by Vlad Kugan on 5.04.23.
//

import UIKit

class ButtonProfileCollectionViewCell: UICollectionViewCell {
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(button)
        
        // Добавляем constraints на кнопку, чтобы она растягивалась на всю ячейку
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // Отправляем событие нажатия кнопки в UserProfileViewController
        if let userVC = self.superview?.next as? UserProfileViewController {
            userVC.buttonTapped(sender)
        }
    }
}
