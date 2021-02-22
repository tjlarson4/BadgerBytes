//
//  AuthInputView.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/18/21.
//

import UIKit

class AuthInputView: UIView {
    
    init(placeholder: String, keyboardType: UIKeyboardType, isPassword: Bool) {
        super.init(frame: .zero)
        setUpViews()
        input.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.subtitle_label])
        input.keyboardType = keyboardType
        input.isSecureTextEntry = isPassword
    }
    
    let input: UITextField = {
        let tf = UITextField()
        tf.textColor = .main_label
        tf.tintColor = .main_label
        tf.font = UIFont(regularWithSize: 16)
        tf.keyboardAppearance = .dark
        tf.autocapitalizationType = .none
        return tf
    }()
    
    let underlineSeparator = LineView(color: .subtitle_label)
    
    func setUpViews() {
        
        self.addSubviews(views: [input, underlineSeparator])
        
        input.anchor(topAnchor, left: leftAnchor, bottom: underlineSeparator.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 3, bottomConstant: 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        underlineSeparator.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

