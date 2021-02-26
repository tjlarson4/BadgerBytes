//
//  ManageVC.swift
//  BadgerBytes
//
//  Created by Connor Hanson on 2/18/21.
//

import UIKit
import Firebase

class ManageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var orders = [Order]()
    var userOrders = [Order]()
    
    //    var activeOrders = [Order]()
    //    var pastOrders = [Order]()
    
    var orderItems = [MenuItem]()
    
    var filteredMenuItems = [MenuItem]()
    
    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        setUpViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchOrders()
    }
    
    //
    // MARK: Functions
    //
    

    func fetchOrderItemsFor(order: Order) {
        
        self.orderItems = []
        
        for key in order.menuItems.keys {
            Database.fetchMenuItemWithID(id: key) { (menuItem) in
                self.orderItems.append(menuItem)
            }
        }
    }
    
    func fetchOrders() {
        
        orders = []
                
        let orderRef = Database.database().reference().child("orders")

        orderRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
                        
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                let order = Order(id: key, dictionary: dictionary)
                
                self.orders.append(order)
                
//                self.activeOrders = self.userOrders.filter({ (order) -> Bool in
//                    return order.status.contains("active")
//                })
                
            })
            
            self.collectionView.reloadData()
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
        
    }
    
    @objc func handleActiveOrders() {
        
        
    }
    
    @objc func handlePastOrders() {
        
        
    }
    
    @objc func handleUsageReport() {
        
        
    }
    
    
    //
    // MARK: CollectionView
    //

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return orders.count
        } else {
            return orders.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let orderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderCell", for: indexPath) as! OrderCell
        
        if indexPath.item == 0 {
            orderCell.separator.isHidden = true
        }
                
        orderCell.titleLabel.text = orders[indexPath.row].id
        orderCell.subtitleLabel.text = orders[indexPath.row].totalPrice

        return orderCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! OrderHeaderCell
            
            if indexPath.section == 0 {
                header.titleLabel.text = "Active"
            } else {
                header.titleLabel.text = "Past"
            }
            
            return header
            
        } else {
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
//        let orderDetailsVC = OrderDetailsVC()
//        orderDetailsVC.modalPresentationStyle = .overFullScreen
//        
//        var orderItems = [MenuItem]()
//        
//        for key in userOrders[indexPath.row].menuItems.keys {
//            Database.fetchMenuItemWithID(id: key) { (menuItem) in
//                orderItems.append(menuItem)
//                orderDetailsVC.orderItems = orderItems
//                orderDetailsVC.collectionView.reloadData()
//            }
//        }
//        
//        self.present(orderDetailsVC, animated: true, completion: nil)
        
    }

    //
    // MARK: UI Setup
    //
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        return cv
    }()
    
    lazy var activeOrdersButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = UIColor(hex: "B80000")
        btn.add(text: "Prioritize Active Orders", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "FFFFFF"))
        btn.addTarget(self, action: #selector(handleActiveOrders), for: .touchUpInside)
        return btn
    }()
    
    lazy var pastOrdersButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = UIColor(hex: "B80000")
        btn.add(text: "Manage Past Orders", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "FFFFFF"))
        btn.addTarget(self, action: #selector(handleActiveOrders), for: .touchUpInside)
        return btn
    }()
    
    lazy var usageReportButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = UIColor(hex: "B80000")
        btn.add(text: "See usage report", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "FFFFFF"))
        btn.addTarget(self, action: #selector(handleActiveOrders), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [activeOrdersButton, pastOrdersButton, usageReportButton])
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        return sv
    }()
    
    func setUpViews() {
        
        fetchOrders()
        
        collectionView.register(OrderCell.self, forCellWithReuseIdentifier: "orderCell")
        collectionView.register(OrderHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCell")
        
        self.view.addSubviews(views: [collectionView, btnStackView])
        
        btnStackView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 200)
        btnStackView.anchorCenterSuperview()
//        collectionView.fillSuperview()

    }

}




