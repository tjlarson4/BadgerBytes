//
//  OrderDetailsVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/25/21.
//

import UIKit
import Firebase

class OrderDetailsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
        weak var cv: UICollectionView! // this pages collection view
        var orderItems: [MenuItem]!
        var orders = [Order]()
        var order: Order!
    
    
    
    
        func fetchOrderItemsFor(order: Order) {
            
            
            //print(order.menuItems.keys)
            print("FECK")
            
            DispatchQueue.main.async {
                for key in order.menuItems.keys {
                    Database.database().reference().child("menuItems").child(key).observeSingleEvent(of: .value) { (snapshot) in
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            let menuItem = MenuItem(id: snapshot.key, dictionary: dictionary)
                            self.orderItems.append(menuItem)
                            print("order added")
                            self.cv.reloadData()
                        }
                    }
                    
                }
                
                
            }
            
            
        }
    
                    
        override func loadView() {
            super.loadView()
            self.orderItems = []
            print("yuh")
            fetchOrderItemsFor(order: self.order)
            let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            cv.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(cv)
            
            NSLayoutConstraint.activate([
                       cv.topAnchor.constraint(equalTo: self.view.topAnchor),
                       cv.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                       cv.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                       cv.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                   ])
            self.cv = cv
        }
        
        override func viewDidLoad() {
               super.viewDidLoad()

               self.cv.backgroundColor = .gray
               self.cv.dataSource = self
               self.cv.delegate = self

                self.cv.register(SimpleTextCell.self, forCellWithReuseIdentifier: "Simple")
            self.cv.register(InformationViewCell.self, forCellWithReuseIdentifier: "Info")
            self.cv.register(OrderCell.self, forCellWithReuseIdentifier: "OrderDetail")
                //self.cv.register(AddressCell.self, forCellWithReuseIdentifier: "MyCell")
           }



    // everything is public to match public status of protocols they are following
        public func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }

        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            if (!orderItems.isEmpty) {
                return orderItems.count
            } else {
                return 1
            }
        }

        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderDetail", for: indexPath) as! OrderCell
            
            if (!orderItems.isEmpty) {
                cell.titleLabel.text = orderItems[0].name
            }
            
            
            return cell
            
            
        }
        
        @objc func handleLogout() {
            do {
                try Auth.auth().signOut()
                let loginVC = LoginVC()
                loginVC.modalPresentationStyle = .fullScreen
                present(loginVC, animated: true, completion: nil)
            } catch {
                print("Error signing out: " +  error.localizedDescription)
            }
        }
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                print(indexPath.row + 1)
            
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)

            
        }


        public func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {

                return CGSize(width: collectionView.bounds.size.width - 16, height: 120)
            

        }
        public func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 8
        }

        public func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }

        public func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        }
    }


//import UIKit
//
//class OrderDetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    var orderItems = [MenuItem]()
//    
//    //
//    // MARK: View Lifecycle
//    //
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setUpViews()
//        print("Hello")
//        print(orderItems)
//    }
//    
//    //
//    // MARK: Functions
//    //
//    
//    @objc func handleDismiss() {
//        self.view.endEditing(true)
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    @objc func handleGetReceipt() {
//        print("Getting receipt")
//    }
//    
//    //
//    // MARK: Collection View
//    //
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return orderItems.count
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let menuItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuItemCell", for: indexPath) as! MenuItemCell
//        let menuItem = orderItems[indexPath.row]
//        menuItemCell.configure(item: menuItem)
//        print("Previewing ordre")
//                        
//        return menuItemCell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        return CGSize(width: self.view.frame.width, height: 200)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
//    
//    func registerCells() {
//        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: "menuItemCell")
//        collectionView.register(InformationViewCell.self, forCellWithReuseIdentifier: "OrderInfo")
//        // time left for delivery
//        // car description
//        // items in order
//    }
//    
//    //
//    // MARK: UI Setup
//    //
//    
//    let dismissButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setImage(UIImage(named: "dismiss_btn")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        btn.tintColor = .black
//        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
//        return btn
//    }()
//    
//    lazy var collectionView: UICollectionView = {
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//        cv.delegate = self
//        cv.dataSource = self
//        cv.backgroundColor = .clear
//        return cv
//    }()
//    
//    let getReceiptButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.layer.cornerRadius = 9
//        btn.backgroundColor = .subtitle_label
//        btn.add(text: "Get receipt ", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
//        btn.addTarget(self, action: #selector(handleGetReceipt), for: .touchUpInside)
//        return btn
//    }()
//
//    func setUpViews() {
//        
//        registerCells()
//        
//        //self.view.addSubview(collectionView)
//        
//        self.view.addSubviews(views: [dismissButton, collectionView, getReceiptButton])
//        self.view.backgroundColor = .menu_white
//        
//        dismissButton.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 18, heightConstant: 18)
//        
//        collectionView.anchor(dismissButton.bottomAnchor, left: view.leftAnchor, bottom: getReceiptButton.topAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 50, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//        
//        getReceiptButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 20, rightConstant: 30, widthConstant: 0, heightConstant: 45)
//
//        
//        
//    }
//
//}
