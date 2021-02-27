//
//  MenuItemCell.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/23/21.
//

import UIKit

class MenuItemCell: UICollectionViewCell {
    
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
        if(!item.inStock){
            inStockLabel.isHidden = false
            openCartButton.isHidden = true
        }else{
            inStockLabel.isHidden = true
            openCartButton.isHidden = false
        }
        if(globalCurrentUser?.accountType == "customer"){
            editItemButton.isHidden = true
        }else{
            editItemButton.isHidden = false
        }
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
    
    let inStockLabel: UILabel = {
       let lbl = UILabel()
        lbl.isHidden = true
        lbl.add(text: "Out of Stock",font: UIFont(boldWithSize: CGFloat(60)), textColor: UIColor(hex: "B50000"))
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
    
    lazy var openCartButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 45/2
        btn.add(text: "+", font: UIFont(boldWithSize: 24), textColor: .black)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 2
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(handleOpenCart), for: .touchUpInside)
        return btn
    }()
    
    lazy var editItemButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "edit_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.layer.cornerRadius = 45/2
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 2
        btn.backgroundColor = .white
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(handleEditItem), for: .touchUpInside)
        return btn
    }()
    
    func setUpViews() {
        
        self.backgroundColor = .menu_white
        
        self.addSubviews(views: [itemImageView, itemLabel, inStockLabel,priceLabel, openCartButton, editItemButton])
        
        itemImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: itemLabel.topAnchor, right: self.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 0)
                
        inStockLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 30)
        
        itemLabel.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 15, rightConstant: 5, widthConstant: 0, heightConstant: 30)
        
        priceLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 15, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 45, heightConstant: 45)
        
        // TEST CONSTRAINTS - REMOVE LATER
        
//        openCartButton.anchor(self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 45, heightConstant: 45)
//
//        editItemButton.anchor(openCartButton.bottomAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 45, heightConstant: 45)
        
        // COMMENTED OUT FOR TESTING - DO NOT REMOVE
        
        openCartButton.anchor(self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 45, heightConstant: 45)

        editItemButton.anchor(self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 70, heightConstant: 45)

    }
}





