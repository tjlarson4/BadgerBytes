//
//  UsageReportView.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/26/21.
//

import UIKit
import Firebase

class UsageReportView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var manageVC: ManageVC?
    
    var orders = [Order]()
    
    var orderItems = [MenuItem]()
        
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
    
    func fetchOrderItemsFor(order: Order) {
        
        self.orderItems = []
        
        for key in order.menuItems.keys {
            Database.fetchMenuItemWithID(id: key) { (menuItem) in
                self.orderItems.append(menuItem)
            }
        }
    }
    
    func filterSort(_: [Order]) {
//        self.activeOrders = self.orders.filter({ (order) -> Bool in
//            return order.status.contains("active")
//        })
//
//        self.pastOrders = self.orders.filter({ (order) -> Bool in
//            return order.status.contains("complete")
//        })
//
//        self.activeOrders = self.activeOrders.sorted { $0.priority < $1.priority }
//        self.pastOrders = self.pastOrders.sorted { $0.creationDate > $1.creationDate }
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
            })
            
            self.filterSort(self.orders)
            
            self.collectionView.reloadData()
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    
//    @objc func handlePrioritize() {
//        let prioritizeOrdersVC = PrioritizeOrdersVC()
//        prioritizeOrdersVC.modalPresentationStyle = .fullScreen
//        prioritizeOrdersVC.activeOrders = activeOrders
//        manageVC!.present(prioritizeOrdersVC, animated: true, completion: nil)
//
//    }
    
    //
    // MARK: CollectionView
    //

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders.count > 0 ? orders.count : 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let orderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderCell", for: indexPath) as! OrderCell
        
        if orders.count == 0 {
            orderCell.setHidden(isHidden: true)
            orderCell.emptyLabel.text = "No orders available"
        } else {
            
            orderCell.setHidden(isHidden: false)
            
            let orderItem = orders[indexPath.row]
            
            Database.fetchMenuItemWithID(id: orderItem.menuItems.keys.first ?? "") { (menuItem) in
                orderCell.orderImageView.loadImage(urlString: menuItem.imageURL)
            }
                
            orderCell.titleLabel.text = orderItem.creationDate.toStringWith(format: "EEEE, MMM d, h:mm a")
            let plural = orderItem.menuItems.count == 1 ? "" : "s"
            
            var priority = ""
            switch orderItem.priority {
                case 0: priority = "High"
                case 1: priority = "Medium"
                default: priority = "Low"
            }
            
            orderCell.subtitleLabel.text = "\(orderItem.menuItems.count) item\(plural) - Priority: \(priority)"
        }

        return orderCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! OrderHeaderCell
            
            header.titleLabel.text = "Active"
            header.prioritizeButton.isHidden = false
            
            return header
            
        } else {
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.frame.width, height: 40)
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
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Orders", font: UIFont(name: "PingFangHK-Regular", size: 21)!, textColor: .black)
        lbl.textAlignment = .center
        return lbl
    }()
    
    func setUpViews() {
        
        self.backgroundColor = .red
        
        fetchOrders()
        
        collectionView.register(OrderCell.self, forCellWithReuseIdentifier: "orderCell")
        collectionView.register(OrderHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCell")
        
        self.addSubview(collectionView)
        collectionView.fillSuperview()

    }

}


