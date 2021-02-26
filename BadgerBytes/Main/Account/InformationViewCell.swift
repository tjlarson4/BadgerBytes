//
//  InformationViewCell.swift
//  BadgerBytes
//
//  Created by Connor Hanson on 2/25/21.
//

import UIKit

class InformationViewCell: UICollectionViewCell {
    var textLabel: UILabel!
    
    var stack: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.stack = UIStackView()
        stack.axis = .vertical
        self.stack.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.stack)
        NSLayoutConstraint.activate([
            self.stack.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.stack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.stack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.stack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
        self.contentView.layer.cornerRadius = 5
        self.contentView.backgroundColor = .card_background
    }
    
    func addLabelInOrder(label: String, isBold: Bool, size: CGFloat) {
        
        let newLabel = UILabel()
        if (isBold) {
            newLabel.add(text: label, font: .init(boldWithSize: 20), textColor: .white)
        } else {
            newLabel.add(text: label, font: .init(regularWithSize: 15), textColor: .white)
        }
        
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        self.stack.addArrangedSubview(newLabel)
        
//        NSLayoutConstraint.activate([
//            self.stack.topAnchor
//        ])
        
        
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

        //self.textLabel.text = nil
    }
}
