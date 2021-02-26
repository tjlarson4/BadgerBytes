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

    func configure(item: MenuItem) {
        titleLabel.text = item.name
        subtitleLabel.text = "Price: $\(item.price)"
        orderImageView.loadImage(urlString: item.imageURL)
        infoButton.isHidden = true
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
    
    let prioritytitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Priority: X", font: UIFont(regularWithSize: 16), textColor: .black)
        return lbl
    }()
    
    let infoButton: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setImage(UIImage(named: "right_arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .info_btn
        return btn
    }()
    
    let borderView: UIView = {
        let vw = UIView()
        vw.layer.borderWidth = 2
        vw.layer.borderColor = UIColor.cred.cgColor
        vw.backgroundColor = .clear
        vw.isHidden = true
        return vw
    }()
    
    func setUpViews() {
        
        self.backgroundColor = .menu_white
        
        self.addSubviews(views: [borderView, orderImageView, titleLabel, subtitleLabel, infoButton, ])
        
        borderView.fillSuperview()
        
        orderImageView.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 11, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 80)
        orderImageView.anchorCenterYToSuperview()
        
        titleLabel.anchor(orderImageView.topAnchor, left: orderImageView.rightAnchor, bottom: nil, right: infoButton.leftAnchor, topConstant: 5, leftConstant: 9, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 17)
        
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 19)
        
        infoButton.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 23, heightConstant: 23)
        infoButton.anchorCenterYToSuperview()
        
    }
}

import UIKit

class OrderDetailItemCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item: MenuItem) {
        titleLabel.text = item.name
        subtitleLabel.text = "Price: $\(item.price)"
        orderImageView.loadImage(urlString: item.imageURL)
        infoButton.isHidden = true
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
    
    let borderView: UIView = {
        let vw = UIView()
        vw.layer.borderWidth = 2
        vw.layer.borderColor = UIColor.cred.cgColor
        vw.backgroundColor = .clear
        vw.isHidden = true
        return vw
    }()
    
    func setUpViews() {
        
        self.backgroundColor = .menu_white
        
        self.addSubviews(views: [borderView, orderImageView, titleLabel, subtitleLabel, infoButton, ])
        
        borderView.fillSuperview()
        
        orderImageView.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 30, widthConstant: 100, heightConstant: 80)
        orderImageView.anchorCenterYToSuperview()
        
        titleLabel.anchor(orderImageView.centerYAnchor, left: leftAnchor, bottom: nil, right: orderImageView.leftAnchor, topConstant: -17, leftConstant: 30, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 17)
        
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 19)
        
        infoButton.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 23, heightConstant: 23)
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
        lbl.add(text: "Active", font: UIFont(regularWithSize: 17), textColor: .black)
        return lbl
    }()
    
    let prioritizeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Prioritize", font: UIFont(boldWithSize: 17), textColor: UIColor(hex: "565656"))
        return btn
    }()
    
    
    func setUpViews() {
        
        self.backgroundColor = .clear
        
        self.addSubviews(views: [titleLabel, prioritizeButton])
        
        titleLabel.anchor(nil, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 17)
        titleLabel.anchorCenterYToSuperview()
        
        prioritizeButton.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 7, leftConstant: 0, bottomConstant: 7, rightConstant: 15, widthConstant: 120, heightConstant: 0)
        prioritizeButton.anchorCenterYToSuperview()


    }
}

