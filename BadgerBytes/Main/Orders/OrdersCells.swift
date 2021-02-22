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
    
    let separator = LineView(color: UIColor(hex: "6C6C6C"))
    
    let orderImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "food1")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Order Title", font: UIFont(regularWithSize: 16), textColor: .main_label)
        return lbl
    }()
    
    let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Order Subtitle", font: UIFont(regularWithSize: 13), textColor: .subtitle_label)
        return lbl
    }()
    
    let infoButton: UIButton = {
        let btn = UIButton(type: .infoLight)
        btn.tintColor = .info_btn
        return btn
    }()
    
    func setUpViews() {
        
        self.backgroundColor = .user_cell
        
        self.addSubviews(views: [separator, orderImageView, titleLabel, subtitleLabel, infoButton])
        
        separator.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 11, bottomConstant: 0, rightConstant: 11, widthConstant: 0, heightConstant: 1)
        
        orderImageView.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 11, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 80)
        orderImageView.anchorCenterYToSuperview()
        
        titleLabel.anchor(orderImageView.topAnchor, left: orderImageView.rightAnchor, bottom: nil, right: infoButton.leftAnchor, topConstant: 5, leftConstant: 9, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 17)
        
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 19)
        
        infoButton.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 18, heightConstant: 18)
        infoButton.anchorCenterYToSuperview()
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
        lbl.add(text: "Active", font: UIFont(regularWithSize: 17), textColor: .main_label)
        return lbl
    }()
    
    func setUpViews() {
        
        self.backgroundColor = .clear
        
        self.addSubviews(views: [titleLabel])
        
        titleLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 27)
    }
}

