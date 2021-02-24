//
//  MenuVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/18/21.
//

import UIKit
import Firebase

class MenuVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        setUpViews()
    }
    
    //
    // MARK: Functions
    //

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
    
    //
    // MARK: CollectionView
    //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        } else {
            return 13
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let menuItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuItemCell", for: indexPath) as! MenuItemCell
        let item = MenuItem(name: "Chicken Tenders", price: "$6", category: "Chicken", imageURL: "chicken_tenders")
        menuItemCell.configure(item: item)
        return menuItemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            
            let welcomeHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "welcomeHeader", for: indexPath)
            let menuHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "menuHeader", for: indexPath)

            if indexPath.section == 0 {
                                
                let menuWelcomeView = MenuWelcomeView()
                welcomeHeader.addSubview(menuWelcomeView)
                menuWelcomeView.fillSuperview()
                return welcomeHeader
                
            } else {
                
                let menuCategoryView = MenuCategoryView()
                menuHeader.addSubview(menuCategoryView)
                menuCategoryView.fillSuperview()
                return menuHeader
            }
            
        } else {
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            let height =  self.view.frame.height - self.view.safeAreaInsets.bottom
            print(height)
            return CGSize(width: self.view.frame.width, height: height)
        } else {
            return CGSize(width: self.view.frame.width, height: 60)
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
        iv.image = UIImage(named: "auth_background")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    func setUpViews() {
        
        fetchCurrentUser()
        registerCells()
        
        self.view.addSubviews(views: [collectionView])
        collectionView.fillSuperview()
    }

}
