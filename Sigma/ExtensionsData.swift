//
//  ExtensionsData.swift
//  Sigma
//
//  Created by Vlad Kugan on 25.03.23.
//

import UIKit



//Расширение для проверки TextField на наличие текста
extension UITextField{
    var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
}

//Расширение для добавление гиперссылок в TextView
extension UITextView {
  func addHyperLinksToText(originalText: String, hyperLinks: [String: String]) {
    let fontText = UIFont.systemFont(ofSize: 14)
    let style = NSMutableParagraphStyle()
    style.alignment = .justified
    let attributedOriginalText = NSMutableAttributedString(string: originalText)
    for (hyperLink, urlString) in hyperLinks {
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: fontText, range: fullRange)
        
    }
    self.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.systemGray,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
    ]
    self.attributedText = attributedOriginalText
  }
}
