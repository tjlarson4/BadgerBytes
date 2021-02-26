//
//  OrderDetailsVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/25/21.
//

import UIKit
import PDFKit

class OrderDetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var orderItems = [MenuItem]()
    
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
    
    @objc func handleGetReceipt() {
        
        let pdfCreator = PDFCreator(menuItems: orderItems)
        
        let documentData = pdfCreator.createOrder()
        
        let pdfView = PDFView(frame: view.bounds)
        
        pdfView.autoScales = true
        pdfView.restorationIdentifier = "getReceiptButton"
        
        view.addSubview(pdfView)
        
        pdfView.anchor(collectionView.topAnchor, left: view.leftAnchor, bottom: getReceiptButton.topAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 10, rightConstant: 30, widthConstant: 0, heightConstant: 45)
        
        let pdfDocument = PDFDocument(data: documentData)
        pdfView.document = pdfDocument

        getReceiptButton.isHidden = true
        //closeReceiptButton.isHidden = false
        
    }
    
    //
    // MARK: Collection View
    //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderItems.count + 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.row == (orderItems.count)) {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomerInfo", for: indexPath) as! InformationViewCell
            cell.setTextColor(color: .black)
            cell.addLabelInOrder(label: globalCurrentUser!.firstName + " " + globalCurrentUser!.lastName, isBold: true, size: 20)
            cell.addLabelInOrder(label: "Phone: " + globalCurrentUser!.phoneNum, isBold: false, size: 15)
            cell.addLabelInOrder(label: "Driving: " + globalCurrentSelectedOrder!.carDesc, isBold: false, size: 15)
            cell.addLabelInOrder(label: "Pick-up: " + globalCurrentSelectedOrder!.creationDate.toStringWith(format: "h:mm a"), isBold: false, size: 15)
            cell.contentView.backgroundColor = .systemRed

            return cell
        }
        
        let detailItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailItemCell", for: indexPath) as! OrderDetailItemCell
        let menuItem = orderItems[indexPath.row]
        detailItemCell.configure(item: menuItem)

        return detailItemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (indexPath.row == orderItems.count) {
            return CGSize(width: collectionView.bounds.size.width - 16, height: 85)
        }
        
        return CGSize(width: self.view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func registerCells() {
        collectionView.register(OrderDetailItemCell.self, forCellWithReuseIdentifier: "detailItemCell")
        collectionView.register(InformationViewCell.self, forCellWithReuseIdentifier: "CustomerInfo")
        // time left for delivery
        // car description
        // items in order
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
    
    let getReceiptButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Get receipt ", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handleGetReceipt), for: .touchUpInside)
        return btn
    }()

    func setUpViews() {
        
        registerCells()
        
        //self.view.addSubview(collectionView)
        
        self.view.addSubviews(views: [dismissButton, collectionView, getReceiptButton])
        self.view.backgroundColor = .menu_white
        
        dismissButton.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 18, heightConstant: 18)
        
        collectionView.anchor(dismissButton.bottomAnchor, left: view.leftAnchor, bottom: getReceiptButton.topAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 50, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        getReceiptButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 20, rightConstant: 30, widthConstant: 0, heightConstant: 45)

        
        
    }

}
