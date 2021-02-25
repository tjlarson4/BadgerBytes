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
    var filteredMenuItems = [MenuItem]()

    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //
    // MARK: Functions
    //
    
    func fetchMenu() {
        
        menuItems = []
        
        let ref = Database.database().reference().child("menuItems")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
                        
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                let menuItem = MenuItem(dictionary: dictionary)
                
                self.menuItems.append(menuItem)
                                
                self.filteredMenuItems = self.menuItems.filter { (menuItem) -> Bool in
                    return menuItem.category.lowercased().contains("burgers")
                }
                
            })
            
            self.collectionView.reloadData()
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
        
    }

    func fetchCurrentUser() {
        
        // Checks that there is a current user with an ID
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        
        // Retrieves user info from Firebase
        Database.database().reference().child("Users").child(currentUserID).observeSingleEvent(of: .value) { (snapshot) in
            
            // Creates dictionary of user information, instatiates new User object
            guard let userDict = snapshot.value as? [String: Any] else {return}
            globalCurrentUser = User(uid: currentUserID, dictionary: userDict)
            print(globalCurrentUser!)
        }
    }
    
    @objc func handleAddMenuItem() {
        let addMenuItemVC = AddMenuItemVC()
        addMenuItemVC.menuVC = self
        addMenuItemVC.modalPresentationStyle = .overFullScreen
        self.present(addMenuItemVC, animated: true, completion: nil)
    }
    
    var orderNum = 1
    
    @objc func handleStartOrder() {
        // Move to menu screen
        print("Order \(orderNum) started")
        orderNum += 1

        // Can just make the category view a slide in menu from the top that hides/shows depending on where they are on the page
        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .top, animated: true)
    }
    
    
    //
    // MARK: CollectionView
    //
    
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
            welcomeViewCell.addMenuItemButton.addTarget(self, action: #selector(handleAddMenuItem), for: .touchUpInside)
            welcomeViewCell.startOrderButton.addTarget(self, action: #selector(handleStartOrder), for: .touchUpInside)

            return welcomeViewCell

        case 1:
            let categoryViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryViewCell", for: indexPath) as! MenuCategoryView
            categoryViewCell.menuVC = self
            return categoryViewCell

        default:
            let menuItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuItemCell", for: indexPath) as! MenuItemCell
            menuItemCell.configure(item: filteredMenuItems[indexPath.row])
            
            menuItemCell.addCallback = {
                print("add pressed: ", indexPath.row)
            }
            
            return menuItemCell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            
            let height =  UIScreen.main.bounds.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom
            return CGSize(width: self.view.frame.width, height: height)
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
    
    
    func setUpViews() {
        
        
        fetchCurrentUser()
        registerCells()
        fetchMenu()
    
        self.view.addSubviews(views: [backgroundImageView, collectionView])
        backgroundImageView.fillSuperview()

        collectionView.fillSuperview()
        
    }

}
