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
    
    @objc func handleSubmit() {
        
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
        guard let category = categoryInputView.input.text else {return}
        
        let menuItemRef = Database.database().reference().child("menuItems")
        let ref = menuItemRef.childByAutoId()
            
        let values = ["name": name, "price": price, "category": category, "imageURL": imageUrl]  as [String : Any]
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
                
        dismiss(animated: true, completion: nil)
    }
    
    //
    // MARK: UI Setup
    //
    
    let dismissButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "dismiss_btn")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()
    
    let nameInputView = AuthInputView(placeholder: "Menu Item Name", keyboardType: .default, isPassword: false)
    let categoryInputView = AuthInputView(placeholder: "Menu Item Category", keyboardType: .default, isPassword: false)
    let priceInputView = AuthInputView(placeholder: "Menu Item Price", keyboardType: .default, isPassword: false)
    
    let plusPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "double_cheeseburger")!.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.clipsToBounds = true
        return btn
    }()
    
    let submitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.add(text: "Submit", font: UIFont(boldWithSize: 18), textColor: .subtitle_label)
        btn.layer.borderColor = UIColor.subtitle_label.cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return btn
    }()
    
    func setUpViews() {
        
        self.view.addSubviews(views: [dismissButton, plusPhotoButton, nameInputView, categoryInputView, priceInputView, submitButton])
        self.view.backgroundColor = .vc_background
        
        dismissButton.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 18, heightConstant: 18)
        
        plusPhotoButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 100, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 200)
        plusPhotoButton.anchorCenterXToSuperview()
        
        nameInputView.anchor(plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 100, bottomConstant: 0, rightConstant: 100, widthConstant: 0, heightConstant: 50)
        
        categoryInputView.anchor(nameInputView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 100, bottomConstant: 0, rightConstant: 100, widthConstant: 0, heightConstant: 50)

        priceInputView.anchor(categoryInputView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 100, bottomConstant: 0, rightConstant: 100, widthConstant: 0, heightConstant: 50)
        
        submitButton.anchor(priceInputView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 40, rightConstant: 30, widthConstant: 0, heightConstant: 50)
        submitButton.anchorCenterXToSuperview()
    
    }
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
