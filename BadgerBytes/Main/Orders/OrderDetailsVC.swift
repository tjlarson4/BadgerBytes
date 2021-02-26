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
        return orderItems.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let detailItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailItemCell", for: indexPath) as! OrderDetailItemCell
        let menuItem = orderItems[indexPath.row]
        detailItemCell.configure(item: menuItem)
        
        return detailItemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 80)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func registerCells() {
        collectionView.register(OrderDetailItemCell.self, forCellWithReuseIdentifier: "detailItemCell")
    }
    
    //
    // MARK: UI Setup
    //
    
    let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Order Info:", font: UIFont(boldWithSize: 22), textColor: .black)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let infoContainerView: UIView = {
        let vw = UIView()
        vw.layer.borderColor = UIColor.black.cgColor
        vw.layer.borderWidth = 2
        vw.layer.cornerRadius = 10
        return vw
    }()
    
    let dismissButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "dismiss_btn")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Ordered: Friday, Feb 26, 4:09 AM", font: UIFont(regularWithSize: 18), textColor: .black)
        lbl.textAlignment = .left
        return lbl
    }()
    
    let pickupLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Pickup: Friday, Feb 26, 4:09 AM", font: UIFont(regularWithSize: 18), textColor: .black)
        lbl.textAlignment = .left
        return lbl
    }()
    
    let carDescLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Car Description: Blue Honda", font: UIFont(regularWithSize: 18), textColor: .black)
        lbl.textAlignment = .left
        return lbl
    }()
    
    let itemsLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Ordered Items:", font: UIFont(boldWithSize: 22), textColor: .black)
        lbl.textAlignment = .center
        return lbl
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
        
        self.view.addSubviews(views: [dismissButton, infoLabel, infoContainerView, itemsLabel, collectionView, getReceiptButton])
        self.infoContainerView.addSubviews(views: [dateLabel, pickupLabel, carDescLabel])

        self.view.backgroundColor = .menu_white
        
        dismissButton.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 18, heightConstant: 18)
        
        infoLabel.anchor(dismissButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        infoContainerView.anchor(infoLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 130)

//        customerLabel.anchor(infoContainerView.topAnchor, left: infoContainerView.leftAnchor, bottom: nil, right: infoContainerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 30)
        
        dateLabel.anchor(infoContainerView.topAnchor, left: infoContainerView.leftAnchor, bottom: nil, right: infoContainerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 30)
        
        pickupLabel.anchor(dateLabel.bottomAnchor, left: infoContainerView.leftAnchor, bottom: nil, right: infoContainerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 30)
        
        carDescLabel.anchor(pickupLabel.bottomAnchor, left: infoContainerView.leftAnchor, bottom: nil, right: infoContainerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 30)
        
        itemsLabel.anchor(infoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)

        collectionView.anchor(itemsLabel.bottomAnchor, left: view.leftAnchor, bottom: getReceiptButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 50, rightConstant: 0, widthConstant: 0, heightConstant: 0)

        getReceiptButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 20, rightConstant: 30, widthConstant: 0, heightConstant: 45)

        
        
    }

}
