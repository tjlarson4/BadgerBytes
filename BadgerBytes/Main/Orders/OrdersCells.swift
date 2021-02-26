//
//  OrderCells.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/22/21.
//

import UIKit

class OrderCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    let orderImageView: CUImageView = {
        let iv = CUImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Order Title", font: UIFont(regularWithSize: 18), textColor: .black)
        return lbl
    }()
    
    let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Order Subtitle", font: UIFont(regularWithSize: 16), textColor: .black)
        return lbl
    }()
    
    let infoButton: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setImage(UIImage(named: "right_arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .info_btn
        return btn
    }()
    
    func setUpViews() {
        
        self.backgroundColor = .menu_white
        
        self.addSubviews(views: [orderImageView, titleLabel, subtitleLabel, infoButton])
        
        orderImageView.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 11, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 80)
        orderImageView.anchorCenterYToSuperview()
        
        titleLabel.anchor(orderImageView.topAnchor, left: orderImageView.rightAnchor, bottom: nil, right: infoButton.leftAnchor, topConstant: 15, leftConstant: 9, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 17)
        
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 19)
        
        infoButton.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 23, heightConstant: 23)
        infoButton.anchorCenterYToSuperview()
        
    }
}

import UIKit

class OrderDetailItemCell: UICollectionViewCell {
    
    //
    // MARK: View Lifecycle
    //
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // MARK: Functions
    //

    func configure(item: MenuItem) {
        itemLabel.text = item.name
        priceLabel.text = "$\(item.price)"
        itemImageView.loadImage(urlString: item.imageURL)
    }
    
    var openCartCallback: (()->Void)?
    @objc func handleOpenCart() {
        print("Callback")
        openCartCallback?()
    }
    
    var editItemCallback: (()->Void)?
    @objc func handleEditItem() {
        editItemCallback?()
    }
    
    //
    // MARK: UI Setup
    //
    
     let itemImageView: CUImageView = {
        let iv = CUImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
     let itemLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Double Cheeseburger", font: UIFont(regularWithSize: 23), textColor: .black)
        lbl.textAlignment = .center
        return lbl
    }()
    
     lazy var priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "$7", font: UIFont(regularWithSize: 24), textColor: .white)
        lbl.textAlignment = .center
        lbl.backgroundColor = .cred
        lbl.clipsToBounds = true
        lbl.layer.cornerRadius = 45/2
        return lbl
    }()
    
    func setUpViews() {
        
        self.backgroundColor = .menu_white
        
        self.addSubviews(views: [itemImageView, itemLabel, priceLabel])
        
        itemImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: itemLabel.topAnchor, right: self.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 0)
                
        itemLabel.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 15, rightConstant: 5, widthConstant: 0, heightConstant: 30)
        
        priceLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 15, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 45, heightConstant: 45)
                    
    }
}

class OrderHeaderCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Active", font: UIFont(regularWithSize: 17), textColor: .black)
        return lbl
    }()
    
    func setUpViews() {
        
        self.backgroundColor = .clear
        
        self.addSubviews(views: [titleLabel])
        
        titleLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 27)
    }
}

