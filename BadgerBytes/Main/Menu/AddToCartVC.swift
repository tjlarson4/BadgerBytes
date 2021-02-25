//
//  AddToCartVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/24/21.
//

import UIKit

class AddToCartVC: UIViewController {
    
    var itemToAdd: MenuItem?
    var quantity = 1
    var totalPrice = 0
    var itemPrice = 0
        
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
        itemPrice = Int(item.price)!
    }
    
    var addToCartCallback: (()->Void)?
    
    @objc func handleAddToCart() {
        addToCartCallback?()
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func handlePlus() {
    
        self.minusButton.isEnabled = true
        
        quantity = quantity + 1
        quantityLabel.text = "\(quantity)"
        
        totalPrice = quantity*itemPrice
        self.addToCartButton.setTitle("Add \(quantity) to cart - $\(totalPrice).00", for: .normal)
        updateValues()
    }
    
    @objc func handleMinus() {

        if quantity > 2 {
            quantity = quantity - 1
            self.addToCartButton.setTitle("Add \(quantity) to cart - $\(quantity*itemPrice).00", for: .normal)
        } else {
            quantity = quantity - 1
            self.minusButton.isEnabled = false
            self.addToCartButton.setTitle("Add to cart - $\(quantity*itemPrice).00", for: .normal)
        }
        
        updateValues()
    }
    
    func updateValues() {
        quantityLabel.text = "\(quantity)"
        
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
    
    lazy var plusButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.add(text: "+", font: UIFont(boldWithSize: 27), textColor: .black)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 3
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(handlePlus), for: .touchUpInside)
        btn.frame.size = CGSize(width: 45, height: 45)
        return btn
    }()
    
    let quantityLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "1", font: UIFont(regularWithSize: 23), textColor: .black)
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var minusButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.add(text: "-", font: UIFont(boldWithSize: 27), textColor: .black)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 3
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(handleMinus), for: .touchUpInside)
        return btn
    }()
    
    lazy var quantityBtnStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [minusButton, quantityLabel, plusButton])
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.spacing = 10
        return sv
    }()
    
    let addToCartButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Add to cart", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handleAddToCart), for: .touchUpInside)
        return btn
    }()
    
    func setUpViews() {
        
        configure(item: itemToAdd!)

        totalPrice = itemPrice

        self.addToCartButton.setTitle("Add to cart - $\(itemPrice).00", for: .normal)
        
        self.view.addSubviews(views: [dismissButton, itemImageView, itemLabel, addToCartButton, quantityBtnStackView])
        self.view.backgroundColor = .menu_white
        
        dismissButton.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 18, heightConstant: 18)
        
        itemImageView.anchor(dismissButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 200)
                
        itemLabel.anchor(itemImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        quantityBtnStackView.anchor(itemLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 95, heightConstant: 30)
        quantityBtnStackView.anchorCenterXToSuperview()

        addToCartButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 20, rightConstant: 30, widthConstant: 0, heightConstant: 45)

    }
    
}

