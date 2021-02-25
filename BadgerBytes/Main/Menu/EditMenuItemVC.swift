//
//  EditMenuItemVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/25/21.
//

import UIKit

class EditMenuItemVC: UIViewController {
    
    var itemToEdit: MenuItem?
        
    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        setUpViews()
    }
    
    //
    // MARK: Functions
    //
    
    @objc func handleDismiss() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func configure(item: MenuItem) {
        itemLabel.text = item.name
        itemImageView.loadImage(urlString: item.imageURL)
    }
    
    var updateItemCallback: (()->Void)?
    
    @objc func handleUpdateItem() {
        updateItemCallback?()
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //
    // MARK: UI Setup
    //
    
    let dismissButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "dismiss_btn")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()
    
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
    
    let updateItemButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Update menu item", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handleUpdateItem), for: .touchUpInside)
        return btn
    }()
    
    func setUpViews() {
        
        configure(item: itemToEdit!)
        
        self.view.addSubviews(views: [dismissButton, itemImageView, itemLabel, updateItemButton])
        self.view.backgroundColor = .menu_white
        
        dismissButton.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 18, heightConstant: 18)
        
        itemImageView.anchor(dismissButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 200)
                
        itemLabel.anchor(itemImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        updateItemButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 20, rightConstant: 30, widthConstant: 0, heightConstant: 45)

    }
    
}


