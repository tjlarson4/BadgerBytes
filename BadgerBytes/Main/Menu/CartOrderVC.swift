//
//  CartOrderVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/24/21.
//

import UIKit
import PDFKit
import Firebase

class CartOrderVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var cartItems = [MenuItem]()
    var totalOrderPrice = 0
    var ref: DatabaseReference!
    
    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        setUpViews()
        print(totalOrderPrice)
    }
    
    //
    // MARK: Functions
    //
    
    @objc func handleDismiss() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    var placeOrderCallback: (()->Void)?

    @objc func handlePlaceOrder() {
        if (globalCurrentUser?.payment["cardNum"] != nil){
        
            guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        
            var menuItems = [String: Int]()
        
            for item in cartItems {
                menuItems.updateValue(1, forKey: item.id)
            }
        
            let values = ["ownerID": currentUserID, "menuItems": menuItems, "totalPrice": totalOrderPrice, "creationDate": Date().timeIntervalSince1970, "status": "active", "priority": 0] as [String : Any]
            
            ref = Database.database().reference().child("orders").childByAutoId()
        
            ref.setValue(values, withCompletionBlock: { (err, ref) in
               
                if let err = err {
                    print("Database info error: " + err.localizedDescription)
                }
            
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let order = [snapshot.key: 1]
                
                Database.database().reference().child("Users").child(currentUserID).child("orders").updateChildValues(order, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print("Database info error: " + err.localizedDescription)
                    }
                    
                    self.present(PickupDetailsVC(), animated: true, completion: nil)
                                  
                    print("Successfully stored user order within userinfo")
                    
                    Database.uploadUsageAction(usageItem: UsageItem(type: .orderCreated, desc: "Order Placed of \"\(menuItems.count)\" items, totalling $\(self.totalOrderPrice).00", actingUserID: Auth.auth().currentUser?.uid ?? ""))
                    
                    })
                                                
                }) { (err) in
                    print("Failed to fetch order:", err)
                }
            
                print("Successfully stored uploaded order")
            })
            
        } else {
            
            let alert = UIAlertController(title: "Error!", message: "No payment information saved.", preferredStyle: .alert)
            
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 4
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func handleGetReceipt() {
        print("get receipt button pressed")
        
        let pdfCreator = PDFCreator(menuItems: cartItems)
        
        let documentData = pdfCreator.createOrder()
        
        let pdfView = PDFView(frame: view.bounds)
        
        pdfView.autoScales = true
        pdfView.restorationIdentifier = "getReceiptButton"
        
        view.addSubview(pdfView)
        
        pdfView.anchor(collectionView.topAnchor, left: view.leftAnchor, bottom: getReceiptButton.topAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 10, rightConstant: 30, widthConstant: 0, heightConstant: 45)
        
        let pdfDocument = PDFDocument(data: documentData)
        pdfView.document = pdfDocument

        getReceiptButton.isHidden = true
        closeReceiptButton.isHidden = false
    }
    
    @objc func handleCloseReceipt() {
        for subview in self.view.subviews {
            if (subview.restorationIdentifier == "getReceiptButton") {
                subview.removeFromSuperview()
            }
        }
        

        getReceiptButton.isHidden = false
        closeReceiptButton.isHidden = true
    }
    
    var emptyCartCallback: (()->Void)?
    
    @objc func handleEmptyCart() {
        emptyCartCallback?()
        self.dismiss(animated: true, completion: nil)
    }
    
    //
    // MARK: Collection View
    //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let menuItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuItemCell", for: indexPath) as! MenuItemCell
        let menuItem = cartItems[indexPath.row]
        menuItemCell.configure(item: menuItem)
        menuItemCell.openCartButton.isHidden = true
        menuItemCell.editItemButton.isHidden = true
                        
        return menuItemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func registerCells() {
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: "menuItemCell")
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
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        return cv
    }()
    
    let placeOrderButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Place order", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handlePlaceOrder), for: .touchUpInside)
        return btn
    }()
    
    let getReceiptButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Show receipt", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handleGetReceipt), for: .touchUpInside)
        return btn
    }()
    
    let closeReceiptButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Close receipt", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handleCloseReceipt), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    let emptyCartButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Empty Cart", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handleEmptyCart), for: .touchUpInside)
        return btn
    }()
    

    func setUpViews() {
        
        registerCells()
        
        self.view.addSubviews(views: [dismissButton, collectionView, getReceiptButton, closeReceiptButton, placeOrderButton, emptyCartButton])
        self.view.backgroundColor = .menu_white
        
        dismissButton.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 18, heightConstant: 18)
        
        collectionView.anchor(dismissButton.bottomAnchor, left: view.leftAnchor, bottom: getReceiptButton.topAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 50, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        getReceiptButton.anchor(collectionView.bottomAnchor, left: view.leftAnchor, bottom: placeOrderButton.topAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 10, rightConstant: 30, widthConstant: 0, heightConstant: 45)
        
        closeReceiptButton.anchor(collectionView.bottomAnchor, left: view.leftAnchor, bottom: placeOrderButton.topAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 10, rightConstant: 30, widthConstant: 0, heightConstant: 45)
        
        placeOrderButton.anchor(getReceiptButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 20, rightConstant: 30, widthConstant: 0, heightConstant: 45)

        emptyCartButton.anchor(dismissButton.topAnchor, left: dismissButton.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: -8.5, leftConstant: 180, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 35)

        
    }
    
}
