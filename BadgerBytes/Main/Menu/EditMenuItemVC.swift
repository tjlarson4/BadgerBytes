//
//  EditMenuItemVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/25/21.
//

import UIKit
import Firebase

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
        nameInputView.input.text = itemToEdit?.name
        priceInputView.input.text = itemToEdit?.price
        inStockSwitch.setOn(itemToEdit!.inStock, animated: true)
        handleInStock(sender: inStockSwitch)
        itemImageView.loadImage(urlString: item.imageURL)
    }
    
    var updateItemCallback: (()->Void)?
    
    @objc func handleUpdateItem() {
        
        print("update item")
        
        guard let price = priceInputView.input.text else { return }
        guard let name = nameInputView.input.text else { return }
        let inStock = inStockSwitch.isOn

        let values = ["price": price, "name": name, "inStock": inStock] as [String: Any]
                
        Database.database().reference().child("menuItems").child(itemToEdit!.id).updateChildValues(values) { (err, ref) in
            self.updateItemCallback?()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    var deleteItemCallback: (()->Void)?

    @objc func handleDeleteItem() {
        let menuItemRef = Database.database().reference().child("menuItems").child(itemToEdit!.id)
        menuItemRef.removeValue()
        
        let storageRef = Storage.storage().reference().child("menuItems").child(itemToEdit!.imageURL)
        
        storageRef.delete(completion: { [self] (err) in
            if let err = err {
                print("Storage error: " + err.localizedDescription)
            }
            
            print("File deleted")
            
            self.deleteItemCallback?()            
        })
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func handleInStock(sender: UISwitch) {
        if(sender.isOn){
            inStockLabel.text = "In Stock"
            inStockLabel.textColor = UIColor(hex: "087A31")
        } else{
            inStockLabel.text = "Out of Stock"
            inStockLabel.textColor = UIColor(hex: "B80000")
        }
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
    
    let nameInputView = AuthInputView(placeholder: "Menu Item Name", keyboardType: .default, isPassword: false)
    let priceInputView = AuthInputView(placeholder: "Menu Item Price", keyboardType: .default, isPassword: false)
    
    let inStockLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "In Stock", font: UIFont(name: "PingFangHK-Regular", size: 18)!, textColor: UIColor(hex: "B80000"))
        lbl.textAlignment = .center
        return lbl
    }()
    
    let inStockSwitch: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(handleInStock(sender:)), for: .touchUpInside)
        return sw
    }()
    
    let updateItemButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Update menu item", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handleUpdateItem), for: .touchUpInside)
        return btn
    }()
    
    let deleteItemButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = UIColor(hex: "B80000")
        btn.add(text: "Delete menu item", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "FFFFFF"))
        btn.addTarget(self, action: #selector(handleDeleteItem), for: .touchUpInside)
        return btn
    }()
    
    func setUpViews() {
        
        configure(item: itemToEdit!)
        
        if (globalCurrentUser?.accountType == "staff"){
        self.view.addSubviews(views: [dismissButton, itemImageView, nameInputView,priceInputView,inStockLabel,inStockSwitch,deleteItemButton,updateItemButton])
            inStockSwitch.anchor(priceInputView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 75, bottomConstant: 0, rightConstant: 75, widthConstant: 0, heightConstant: 50)
            inStockLabel.anchor(priceInputView.bottomAnchor, left: inStockSwitch.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 75, bottomConstant: 0, rightConstant: 75, widthConstant: 0, heightConstant: 50)
        } else {
            self.view.addSubviews(views: [dismissButton, itemImageView, nameInputView,priceInputView,deleteItemButton,updateItemButton])

        }
        
        self.view.backgroundColor = .menu_white
        nameInputView.input.textColor = .black
        priceInputView.input.textColor = .black
        
        dismissButton.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 18, heightConstant: 18)
        
        itemImageView.anchor(dismissButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 200)
                
        nameInputView.anchor(itemImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 50, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 50)
        
        priceInputView.anchor(nameInputView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 25, leftConstant: 50, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 50)
        
        
        
        
    
        updateItemButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 20, rightConstant: 30, widthConstant: 0, heightConstant: 45)
        
        deleteItemButton.anchor(nil, left: view.leftAnchor, bottom: updateItemButton.topAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 20, rightConstant: 30, widthConstant: 0, heightConstant: 45)

    }
    
}


