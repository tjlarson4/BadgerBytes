//
//  MenuWelcomeView.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/23/21.
//

import UIKit

class MenuWelcomeView: UICollectionViewCell {
            
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
    

    
    //
    // MARK: UI Setup
    //
    
    let welcomeLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Welcome to...", font: UIFont(regularWithSize: 23), textColor: .black)
        lbl.textAlignment = .left
        return lbl
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "BadgerBytes", font: UIFont(name: "PingFangHK-Regular", size: 45)!, textColor: .black)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let userLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "", font: UIFont(name: "PingFangHK-Regular", size: 23)!, textColor: .black)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let startOrderButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.add(text: "Start your order", font: UIFont(boldWithSize: 18), textColor: .black)
        btn.layer.borderColor = UIColor.subtitle_label.cgColor
        btn.layer.borderWidth = 4
        btn.alpha = 0.8
        btn.backgroundColor = .white
        return btn
    }()
    
    let addMenuItemButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.add(text: "Add menu item", font: UIFont(boldWithSize: 18), textColor: .black)
        btn.layer.borderColor = UIColor.subtitle_label.cgColor
        btn.layer.borderWidth = 3
        btn.alpha = 0.8
        btn.backgroundColor = .white
        return btn
    }()
    
    func setUpViews() {
        
        self.addSubviews(views: [welcomeLabel, titleLabel, userLabel, startOrderButton, addMenuItemButton])
        
        welcomeLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 40, leftConstant: 20, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 35)
        
        titleLabel.anchor(welcomeLabel.bottomAnchor, left: welcomeLabel.leftAnchor, bottom: nil, right: welcomeLabel.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 60)
        
        addMenuItemButton.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 200, leftConstant: 30, bottomConstant: 40, rightConstant: 30, widthConstant: 0, heightConstant: 50)
        addMenuItemButton.anchorCenterXToSuperview()
        
        startOrderButton.anchor(nil, left: addMenuItemButton.leftAnchor, bottom: addMenuItemButton.topAnchor, right: addMenuItemButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        userLabel.anchor(addMenuItemButton.bottomAnchor, left: welcomeLabel.leftAnchor, bottom: nil, right: welcomeLabel.rightAnchor, topConstant: 200, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 60)
        
    }
    
}
