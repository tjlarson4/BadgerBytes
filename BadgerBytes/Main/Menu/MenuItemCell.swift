//
//  MenuItemCell.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/23/21.
//

import UIKit

class MenuItemCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(text: String, imageName: String) {
        myLabel.text = text
        myImageView.image = UIImage(named: imageName)
    }
    
    private let startButton: UIButton = {
        let startButton = UIButton(type: .system)
        startButton.setTitle(">", for: .normal)
        return startButton
    }()
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "Chicken tacos")
        imageView.contentMode = .scaleAspectFill
        
        //make sure image does not exceed bounds of cell
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let myLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        //label.text = "Custom Menu Label"
        return label
    }()
    
    func setUpViews() {
        
        self.addSubviews(views: [startButton, myImageView, myLabel])
        
        myImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 15, leftConstant: 15, bottomConstant: 15, rightConstant: 0, widthConstant: 70, heightConstant: 0)
        
        startButton.anchor(self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 15, rightConstant: 15, widthConstant: 50, heightConstant: 0)
        
        myLabel.anchor(self.topAnchor, left: myImageView.rightAnchor, bottom: nil, right: startButton.leftAnchor, topConstant: 15, leftConstant: 15, bottomConstant: 15, rightConstant: 0, widthConstant: 200, heightConstant: 20)

    }
}





