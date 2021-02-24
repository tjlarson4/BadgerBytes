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
    
    //
    // MARK: CollectionView
    //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        } else if section == 1 {
            return 0
        } else {
            return filteredMenuItems.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let menuItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuItemCell", for: indexPath) as! MenuItemCell
        menuItemCell.configure(item: filteredMenuItems[indexPath.row])
        return menuItemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            
            let welcomeHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "welcomeHeader", for: indexPath)
            let menuHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "menuHeader", for: indexPath)

            if indexPath.section == 0 {
                                
                let menuWelcomeView = MenuWelcomeView()
                welcomeHeader.addSubview(menuWelcomeView)
                menuWelcomeView.fillSuperview()
                menuWelcomeView.addMenuItemButton.addTarget(self, action: #selector(handleAddMenuItem), for: .touchUpInside)
                return welcomeHeader
                
            } else {
                
                let menuCategoryView = MenuCategoryView()
                menuHeader.addSubview(menuCategoryView)
                menuCategoryView.fillSuperview()
                menuCategoryView.menuVC = self
                
                // TODO: Problem with this reloading after scrolling past, therefore reseting the slider
                return menuHeader
            }
            
        } else {
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            let height =  self.view.frame.height - self.view.safeAreaInsets.bottom
            return CGSize(width: self.view.frame.width, height: height)
        } else if section == 1 {
            return CGSize(width: self.view.frame.width, height: 60)
        } else {
            return CGSize(width: self.view.frame.width, height: 0)
        }
        
    }
    
    func registerCells() {
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: "menuItemCell")
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "welcomeHeader")
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "menuHeader")
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
