//
//  TabBarVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/18/21.
//

import UIKit
import Firebase

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        
        fetchCurrentUser()
        
        if Auth.auth().currentUser == nil {
            // Waits unitil the tab bar is loaded then runs this code to present the login view controller
            DispatchQueue.main.async {
                let loginVC = LoginVC()
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: false, completion: nil)
            }
        }
        
        setUpViewControllers()
    }
    
    func fetchCurrentUser() {
        
        // Checks that there is a current user with an ID
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        
        // Retrieves user info from Firebase
        Database.database().reference().child("Users").child(currentUserID).observeSingleEvent(of: .value) { (snapshot) in
            
            // Creates dictionary of user information, instatiates new User object
            guard let userDict = snapshot.value as? [String: Any] else {return}
            globalCurrentUser = User(uid: currentUserID, dictionary: userDict)
        }
    }
    
    func setUpViewControllers() {
                globalMenuUI = MenuVC()
        // Initialize each tab bar view controller
        let controllers = [add(vc: globalMenuUI!, name: "Menu", icon: UIImage(named: "menu_icon")!),
                           add(vc: OrdersVC(), name: "Orders", icon: UIImage(named: "orders_icon")!),
                           add(vc: ManageVC(), name: "Manage", icon: UIImage(named: "manage_icon")!),
                           add(vc: AccountVC(), name: "Account", icon: UIImage(named: "account_icon")!)]
    
        // Add all view controllers
        self.viewControllers = controllers
        self.selectedIndex = 0
    }
    
    func add(vc: UIViewController, name: String, icon: UIImage) -> UINavigationController {
        vc.tabBarItem = UITabBarItem(title: name, image: icon.withRenderingMode(.alwaysTemplate), selectedImage: nil)
        vc.view.backgroundColor = .menu_white
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        return UINavigationController(rootViewController: vc)
    }
    

    
}

