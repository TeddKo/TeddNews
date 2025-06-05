//
//  Label.swift
//  TeddNews
//
//  Created by Ko Minhyuk on 6/6/25.
//

import UIKit

func setUnderLineText(label: UILabel?) {
    guard let text = label?.text else { return }
    
    let attributedString = NSMutableAttributedString(string: text)
    
    let range = NSRange(location: 00, length: attributedString.length)
    
    attributedString
        .addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: range
        )
    
    label?.attributedText = attributedString
}
