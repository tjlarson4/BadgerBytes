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
    
    var addCallback: (()->Void)?

    func configure(item: MenuItem) {
        itemLabel.text = item.name
        priceLabel.text = item.price
        itemImageView.loadImage(urlString: item.imageURL)
    }
    
    @objc func handleAddItem(sender: UIButton) {
        addCallback?()
    }
    
    private let itemImageView: CUImageView = {
        let iv = CUImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let itemLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Double Cheeseburger", font: UIFont(regularWithSize: 23), textColor: .black)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "$7", font: UIFont(regularWithSize: 27), textColor: .white)
        lbl.textAlignment = .center
        lbl.backgroundColor = .red
        lbl.clipsToBounds = true
        lbl.layer.cornerRadius = 45/2
        return lbl
    }()
    
    lazy var addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 45/2
        btn.add(text: "+", font: UIFont(boldWithSize: 27), textColor: .black)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 3
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(handleAddItem), for: .touchUpInside)
        return btn
    }()
    
    func setUpViews() {
        
        self.backgroundColor = .menu_white
        
        self.addSubviews(views: [itemImageView, itemLabel, priceLabel, addButton])
        
        itemImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 200)
                
        itemLabel.anchor(itemImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 30)
        
        priceLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 15, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 45, heightConstant: 45)
        
        addButton.anchor(self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 45, heightConstant: 45)


    }
}





