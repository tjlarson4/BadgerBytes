//
//  AddMenuItemVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/24/21.
//

import UIKit
import Firebase

class AddMenuItemVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var menuVC: MenuVC?
    var category = ""
    
    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    //
    // MARK: Functions
    //

    @objc func handleDismiss() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleAddNewItem() {
        
        guard let image = self.plusPhotoButton.imageView?.image else { return }
        
        guard let uploadData = image.jpegData(compressionQuality: 0.2) else { return }

        let filename = NSUUID().uuidString
       
        let storageRef = Storage.storage().reference().child("menuItems").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
            
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to fetch downloadURL:", err)
                    return
                }
                guard let imageUrl = downloadURL?.absoluteString else { return }
                
                print("Successfully uploaded post image:", imageUrl)
                
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            })
        }

    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        
        guard let name = nameInputView.input.text else {return}
        guard let price = priceInputView.input.text else {return}
        
        let menuItemRef = Database.database().reference().child("menuItems")
        let ref = menuItemRef.childByAutoId()
            
        let values = ["name": name, "price": price, "category": category, "imageURL": imageUrl, "inStock" : true]  as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", err)
                return
            }
            
            print("Successfully saved item to DB")
            
            self.menuVC?.fetchMenu()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleCatSelect(sender: UIButton) {
        
        cat1Button.backgroundColor = .subtitle_label
        cat2Button.backgroundColor = .subtitle_label
        cat3Button.backgroundColor = .subtitle_label

        sender.backgroundColor = .red
        sender.tintColor = .white
        
        switch sender.tag {
            case 0: category = "Burgers"
            case 1: category = "Chicken"
        default:
            category = "Seafood"
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        subtitleLabel.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    //
    // MARK: UI Setup
    //
    
    let dismissButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "dismiss_btn")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        btn.tintColor = .black
        return btn
    }()
    
    
    let cat1Button: UIButton = {
        let btn = UIButton(type: .system)
        btn.tag = 0
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Burger", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handleCatSelect(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let cat2Button: UIButton = {
        let btn = UIButton(type: .system)
        btn.tag = 1
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Chicken", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handleCatSelect(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let cat3Button: UIButton = {
        let btn = UIButton(type: .system)
        btn.tag = 2
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Seafood", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handleCatSelect(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var catStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [cat1Button, cat2Button, cat3Button])
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.spacing = 5
        return sv
    }()
    
    let nameInputView = AuthInputView(placeholder: "Menu Item Name", keyboardType: .default, isPassword: false)
    let priceInputView = AuthInputView(placeholder: "Menu Item Price", keyboardType: .default, isPassword: false)
    
    let plusPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "menuItem_placeholder")!.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.clipsToBounds = true
        btn.tintColor = .gray
        return btn
    }()
    
    let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Click above to add a picture", font: UIFont(name: "PingFangHK-Regular", size: 14)!, textColor: .black)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let addNewItemButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Add new item", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handleAddNewItem), for: .touchUpInside)
        return btn
    }()
    
    func setUpViews() {
        
        self.view.addSubviews(views: [dismissButton, plusPhotoButton, subtitleLabel, nameInputView, priceInputView, addNewItemButton, catStackView])
        self.view.backgroundColor = .menu_white
        
        nameInputView.input.attributedPlaceholder = NSAttributedString(string: "Insert Name (ex. Cheeseburger)", attributes: [.foregroundColor: UIColor.black])
        priceInputView.input.attributedPlaceholder = NSAttributedString(string: "Insert price (ex. 6, 7, 9)", attributes: [.foregroundColor: UIColor.black])
        nameInputView.input.textColor = .black
        priceInputView.input.textColor = .black
        
        dismissButton.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 18, heightConstant: 18)
        
        plusPhotoButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 100, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 200)
        plusPhotoButton.anchorCenterXToSuperview()
        
        subtitleLabel.anchor(plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 50)
        
        nameInputView.anchor(subtitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 50, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 50)
        
        catStackView.anchor(nameInputView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 75, bottomConstant: 0, rightConstant: 75, widthConstant: 0, heightConstant: 50)

        priceInputView.anchor(catStackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 25, leftConstant: 50, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 50)
        
        addNewItemButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 20, rightConstant: 30, widthConstant: 0, heightConstant: 45)

    
    }
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
