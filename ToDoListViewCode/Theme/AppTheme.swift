//
//  AppTheme.swift
//  ToDoListViewCode
//
//  Created by Renato F. dos Santos Jr on 28/03/22.
//

import Foundation
import UIKit

final class AppTheme {
    
    // TODO: abstract to build buttons with different types
    static func buildButton(with _type: UIButton.ButtonType,
                            title: String,
                            fontSize: CGFloat,
                            fontColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        button.tintColor = fontColor
        button.layer.backgroundColor = UIColor.systemGray5.cgColor
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.layer.borderWidth = 4
        button.layer.cornerRadius = 10
        return button
    }
    
    static func buildTextField(placeholder: String,
                               fontColor: UIColor,
                               fontSize: CGFloat) -> UITextField {
        let inputText = UITextField()
        inputText.layer.borderWidth = 1
        inputText.layer.borderColor = UIColor.systemGray5.cgColor
        inputText.textColor = fontColor
        inputText.placeholder = placeholder
//        inputText.tintColor = .black
        inputText.textAlignment = .center
        inputText.translatesAutoresizingMaskIntoConstraints = false
        inputText.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        inputText.layer.cornerRadius = 5
        return inputText
    }
}
