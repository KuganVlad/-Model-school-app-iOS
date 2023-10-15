//
//  CastingButtonCollectionViewCell.swift
//  Sigma
//
//  Created by Vlad Kugan on 9.04.23.
//

import UIKit

class CastingButtonCollectionViewCell: UICollectionViewCell {
    
    var button = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button.titleLabel?.numberOfLines = 0
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(button)
        button.titleLabel?.textAlignment = .left
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(.black, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // Отправляем событие нажатия кнопки в CastingViewController
        if let castingVC = self.superview?.next as? CastingViewController {
            castingVC.buttonCastingTapped(sender)
        }
    }
    
}
