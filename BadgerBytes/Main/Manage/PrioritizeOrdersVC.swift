//
//  PrioritizeOrdersVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/26/21.
//

import UIKit
import PDFKit
import Firebase

class PrioritizeOrdersVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var activeOrders = [Order]()
    var highPriorityOrders = [Order]()
    var mediumPriorityOrders = [Order]()
    var lowPriorityOrders = [Order]()
    
    var manageOrdersView: ManageOrdersView?
    
    var lastMovedOrderCell: OrderCell?
    var sectionMovedFrom = 0
    var indexPathRowRemovedFrom = 0
    var orderMoved: Order?

        
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
    
    @objc func handleApplyPriority() {
        
        let orderSet = [0: highPriorityOrders, 1: mediumPriorityOrders, 2: lowPriorityOrders]
        
        for set in orderSet {
            for order in set.value {
                let values = ["priority": set.key]
                Database.database().reference().child("orders").child(order.id).updateChildValues(values)
            }
        }
        
        self.dismiss(animated: true) {
            self.manageOrdersView?.collectionView.reloadData()
        }
        
    }
    
    func registerCells() {
        collectionView.register(OrderCell.self, forCellWithReuseIdentifier: "orderCell")
        collectionView.register(OrderHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCell")

    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {

        case UIGestureRecognizerState.began:
            
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else { break }
            
            lastMovedOrderCell = collectionView.cellForItem(at: selectedIndexPath) as? OrderCell
            
            lastMovedOrderCell?.borderView.isHidden = false
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            
            indexPathRowRemovedFrom = selectedIndexPath.row
            sectionMovedFrom = selectedIndexPath.section
            
            let sectionMoved = selectedIndexPath.section
            var movedFromOrderArr: [Order]
            switch sectionMoved {
                case 0: movedFromOrderArr = highPriorityOrders
                case 1: movedFromOrderArr = mediumPriorityOrders
                default: movedFromOrderArr = lowPriorityOrders
            }
            
            if movedFromOrderArr.count > 0 {
                orderMoved = movedFromOrderArr[selectedIndexPath.row]
            }
            
        case UIGestureRecognizerState.changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            
            let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView))
            
            if selectedIndexPath?.row != indexPathRowRemovedFrom {
                let sectionMovedTo = selectedIndexPath?.section
                var movedToOrderArr: [Order]
                switch sectionMovedTo {
                    case 0: movedToOrderArr = highPriorityOrders
                    case 1: movedToOrderArr = mediumPriorityOrders
                    default: movedToOrderArr = lowPriorityOrders
                }
                
                movedToOrderArr.append(orderMoved!)
                
                switch sectionMovedTo {
                    case 0: highPriorityOrders = movedToOrderArr
                    case 1: mediumPriorityOrders = movedToOrderArr
                    default: lowPriorityOrders = movedToOrderArr
                }

                var movedFromOrderArr: [Order]
                switch sectionMovedFrom {
                    case 0: movedFromOrderArr = highPriorityOrders
                    case 1: movedFromOrderArr = mediumPriorityOrders
                    default: movedFromOrderArr = lowPriorityOrders
                }

                movedFromOrderArr.remove(at: indexPathRowRemovedFrom)
                
                switch sectionMovedFrom {
                    case 0: highPriorityOrders = movedFromOrderArr
                    case 1: mediumPriorityOrders = movedFromOrderArr
                    default: lowPriorityOrders = movedFromOrderArr
                }

            }
            
//            let orderCells = collectionView.visibleCells as! [OrderCell]
//            
//            for cell in orderCells {
//                cell.borderView.isHidden = true
//            }
            
            collectionView.reloadData()
            
            collectionView.endInteractiveMovement()
        
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func filterOrdersByPriority() {

        self.highPriorityOrders = self.activeOrders.filter { (order) -> Bool in
            return order.priority == 0
        }
        
        self.mediumPriorityOrders = self.activeOrders.filter { (order) -> Bool in
            return order.priority == 1
        }
        
        self.lowPriorityOrders = self.activeOrders.filter { (order) -> Bool in
            return order.priority == 2
        }
        
    }
        
    //
    // MARK: Collection View
    //
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var num = 1
        switch section {
            case 0: num = highPriorityOrders.count
            case 1: num = mediumPriorityOrders.count
            default: num = lowPriorityOrders.count
        }
        
        return num > 0 ? num : 1
    
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let orderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderCell", for: indexPath) as! OrderCell
        let orderArr: [Order]
        
        switch indexPath.section {
            case 0: orderArr = highPriorityOrders
            case 1: orderArr = mediumPriorityOrders
            default: orderArr = lowPriorityOrders
        }
        
        if orderArr.count == 0 {
            orderCell.setHidden(isHidden: true)
            orderCell.emptyLabel.text = "No items available"
        } else {
            
            orderCell.setHidden(isHidden: false)

            let orderItem = orderArr[indexPath.row]
            
            Database.fetchMenuItemWithID(id: orderItem.menuItems.keys.first ?? "") { (menuItem) in
                orderCell.orderImageView.loadImage(urlString: menuItem.imageURL)
            }
                
            orderCell.titleLabel.text = orderItem.creationDate.toStringWith(format: "EEEE, MMM d, h:mm a")
            let plural = orderItem.menuItems.count == 1 ? "" : "s"
            orderCell.subtitleLabel.text = "\(orderItem.menuItems.count) item\(plural) - Total: $\(orderItem.totalPrice).00"
            
            orderCell.infoButton.isHidden = true
            
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
            self.collectionView.addGestureRecognizer(longPressGesture)
        }
        
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
            
            switch indexPath.section {
                case 0: header.titleLabel.text = "High"
                case 1: header.titleLabel.text = "Medium"
                default: header.titleLabel.text = "Low"
            }
                        
            header.prioritizeButton.isHidden = true
            
            return header
            
        } else {
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 40)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let manageOrderDetailsVC = ManageOrderDetailsVC()
//
//        var orderItems = [MenuItem]()
//
//        let orderArr = indexPath.section == 0 ? activeOrders : pastOrders
//        manageOrderDetailsVC.order = orderArr[indexPath.row]
//
//
//        for key in orderArr[indexPath.row].menuItems.keys {
//            Database.fetchMenuItemWithID(id: key) { (menuItem) in
//                orderItems.append(menuItem)
//                manageOrderDetailsVC.orderItems = orderItems
//                manageOrderDetailsVC.collectionView.reloadData()
//            }
//        }
//
//        manageVC!.present(manageOrderDetailsVC, animated: true, completion: nil)
//    }
    
    //
    // MARK: UI Setup
    //
    
    let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Hold & drag to change priority:", font: UIFont(regularWithSize: 22), textColor: .black)
        lbl.textAlignment = .center
        return lbl
    }()
        
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
    
    let applyPriorityButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .cred
        btn.add(text: "Apply Prioritiy", font: UIFont(boldWithSize: 18), textColor: .white)
        btn.addTarget(self, action: #selector(handleApplyPriority), for: .touchUpInside)
        return btn
    }()

    func setUpViews() {
        
        filterOrdersByPriority()
        registerCells()
        
        //self.view.addSubview(collectionView)
        
        self.view.addSubviews(views: [dismissButton, infoLabel, collectionView, applyPriorityButton])
        self.view.backgroundColor = .menu_white
        
        dismissButton.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 18, heightConstant: 18)
        
        infoLabel.anchor(dismissButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)

        collectionView.anchor(infoLabel.bottomAnchor, left: view.leftAnchor, bottom: applyPriorityButton.topAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 50, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        applyPriorityButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 20, rightConstant: 30, widthConstant: 0, heightConstant: 45)
    }

}
