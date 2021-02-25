//
//  SimpleTextInputCell.swift
//  BadgerBytes
//
//  Created by Connor Hanson on 2/23/21.
//

import Firebase
import UIKit

class SimpleTextInputCell: UICollectionViewCell {
    var placeHolderText: String!
    var isPassword: Bool!
    
    let textInput: UITextField = {
        let tf = UITextField()
        tf.textColor = .main_label
        tf.tintColor = .main_label
        tf.font = UIFont(regularWithSize: 16)
        tf.keyboardAppearance = .dark
        tf.autocapitalizationType = .none
        return tf
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textInput.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textInput)
        NSLayoutConstraint.activate([
            textInput.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            textInput.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            textInput.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            textInput.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
        self.contentView.layer.cornerRadius = 5
        self.contentView.backgroundColor = .card_background
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Interface Builder is not supported!")
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        fatalError("Interface Builder is not supported!")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }
}
