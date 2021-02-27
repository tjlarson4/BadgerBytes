//
//  MenuVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/18/21.
//

import UIKit
import Firebase

class MenuVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var menuItems = [MenuItem]()
    var cartItems = [MenuItem]()
    var filteredMenuItems = [MenuItem]()
    
    var orderActive = false
    
    var totalCartPrice = 0

    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(!orderActive, animated: true)
    }
    
    //
    // MARK: Functions
    //
    
    func getAccountType() -> String {
        
        guard let userID = Auth.auth().currentUser?.uid else { return "" }

        var accountType = ""
        Database.fetchUserWithUID(uid: userID) { (user) in
            accountType = user.accountType
        }
        return accountType
    }
        
    func fetchMenu() {
        
        menuItems = []
        
        let ref = Database.database().reference().child("menuItems")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
                        
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                let menuItem = MenuItem(id: key, dictionary: dictionary)
                
                self.menuItems.append(menuItem)
                                            
                self.filteredMenuItems = self.menuItems.filter { (menuItem) -> Bool in
                    return menuItem.category.lowercased().contains("burgers")
                }
                
                self.filteredMenuItems = self.filteredMenuItems.sorted { $0.name < $1.name }
                
            })
            
            self.collectionView.reloadSections(IndexSet(integer: 2))
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
        
    }
    
    @objc func handleAddMenuItem() {
        let addMenuItemVC = AddMenuItemVC()
        addMenuItemVC.menuVC = self
        addMenuItemVC.modalPresentationStyle = .overFullScreen
        self.present(addMenuItemVC, animated: true, completion: nil)
    }
    
    @objc func handleCheckCart() {
        
        if totalCartPrice == 0 {
            
            let alert = UIAlertController(title: "No items added to cart", message: "Add items below by pressing the + icon", preferredStyle: .alert)
            
            self.present(alert, animated: true, completion: nil)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (alert) in
                return
            }))
        }
        
        let cartOrderVC = CartOrderVC()
        cartOrderVC.cartItems = self.cartItems
        cartOrderVC.totalOrderPrice = self.totalCartPrice

        cartOrderVC.modalPresentationStyle = .overFullScreen
        
        cartOrderVC.emptyCartCallback = {
            self.cartItems = []
            self.totalCartPrice = 0
            self.viewCartButton.setTitle("View cart: $\(self.totalCartPrice).00", for: .normal)
        }
        
        cartOrderVC.placeOrderCallback = {
            
            self.dismiss(animated: true) {
                self.cartItems = []
                self.totalCartPrice = 0
                self.viewCartButton.setTitle("View cart: $\(self.totalCartPrice).00", for: .normal)
                self.orderActive = false
                self.navigationController?.setNavigationBarHidden(!self.orderActive, animated: true)

                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)

                let alert = UIAlertController(title: "Order successfully placed!", message: "View your active orders in the Orders tab.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (alert) in
                    let tabBarVC = UIApplication.shared.keyWindow?.rootViewController as! TabBarVC
                    tabBarVC.setUpViewControllers()
                    self.view.endEditing(true)
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                }))

                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.present(cartOrderVC, animated: true, completion: nil)
    }
        
    @objc func handleStartOrder() {
        
        orderActive = true
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])

        // Can just make the category view a slide in menu from the top that hides/shows depending on where they are on the page
        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .top, animated: true)
        
    }
    
    
    //
    // MARK: CollectionView
    //
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    func hideAddItem(){
        self.addMenuItemButton.isHidden = (globalCurrentUser?.accountType == "customer")
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else {
            return filteredMenuItems.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let welcomeViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "welcomeViewCell", for: indexPath) as! MenuWelcomeView
            welcomeViewCell.startOrderButton.addTarget(self, action: #selector(handleStartOrder), for: .touchUpInside)
            return welcomeViewCell

        case 1:
            let categoryViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryViewCell", for: indexPath) as! MenuCategoryView
            categoryViewCell.menuVC = self
            return categoryViewCell

        default:
            let menuItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuItemCell", for: indexPath) as! MenuItemCell
            let menuItem = filteredMenuItems[indexPath.row]
            menuItemCell.configure(item: menuItem)
            
            
            // COMMENTED OUT FOR TESTING - DO NOT REMOVE
            // Handles security permission for account types showing edit/add to cart buttons
            
            if getAccountType() == "customer" {
                menuItemCell.editItemButton.isHidden = true
                menuItemCell.openCartButton.isHidden = false
            } else {
                menuItemCell.editItemButton.isHidden = false
                menuItemCell.openCartButton.isHidden = true

            }
            
            menuItemCell.openCartCallback = {
                                                
                let addToCartVC = AddToCartVC()
                addToCartVC.itemToAdd = menuItem
                addToCartVC.modalPresentationStyle = .overFullScreen
                
                addToCartVC.addToCartCallback = {
                                                            
                    addToCartVC.quantity.times {
                        self.cartItems.append(menuItem)
                    }
                                        
                    self.totalCartPrice = self.totalCartPrice + addToCartVC.totalPrice
                    self.viewCartButton.setTitle("View cart: $\(self.totalCartPrice).00", for: .normal)
                    
                }
                
                self.present(addToCartVC, animated: true, completion: nil)
            }
            
            menuItemCell.editItemCallback = {
                
                let editMenuItemVC = EditMenuItemVC()
                editMenuItemVC.itemToEdit = menuItem
                editMenuItemVC.modalPresentationStyle = .overFullScreen
                
                editMenuItemVC.updateItemCallback = {
                    self.fetchMenu()
                }
                
                editMenuItemVC.deleteItemCallback = {
                    self.fetchMenu()
                }

                self.present(editMenuItemVC, animated: true, completion: nil)
            }
            
            return menuItemCell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            let welcomeHeight =  self.view.frame.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom
            return CGSize(width: self.view.frame.width, height: welcomeHeight)
        case 1:
            return CGSize(width: self.view.frame.width, height: 60)
        default:
            return CGSize(width: self.view.frame.width, height: 250)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func registerCells() {
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: "menuItemCell")
        collectionView.register(MenuWelcomeView.self, forCellWithReuseIdentifier: "welcomeViewCell")
        collectionView.register(MenuCategoryView.self, forCellWithReuseIdentifier: "categoryViewCell")
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
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "welcome_background2")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var viewCartButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.add(text: "View cart: $0.00", font: UIFont(boldWithSize: 15), textColor: .white)
        btn.addTarget(self, action: #selector(handleCheckCart), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .cred

        return btn
    }()
    
    lazy var addMenuItemButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.add(text: " + Add new menu item", font: UIFont(boldWithSize: 15), textColor: .white)
        btn.addTarget(self, action: #selector(handleAddMenuItem), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .cred
        return btn
    }()
    
    func setUpViews() {
        
        // COMMENTED OUT FOR TESTING - DO NOT REMOVE
        // BELOW CODE CHANGES BUTTON VISIBILITY FOR ACCOUNT TYPE PERMISSIONS
        
        if getAccountType() == "customer" {
            self.navigationItem.titleView = viewCartButton
        } else {
            self.navigationItem.titleView = addMenuItemButton
        }

        if getAccountType() == "staff" {
            addMenuItemButton.isEnabled = false
            addMenuItemButton.backgroundColor = .gray
        }
        
        // TEST CODE - DO NOT REMOVE
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addMenuItemButton)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: viewCartButton)

        registerCells()
        fetchMenu()
    
        self.view.addSubviews(views: [backgroundImageView, collectionView])
        backgroundImageView.fillSuperview()

        collectionView.fillSuperview()
        
    }

}
