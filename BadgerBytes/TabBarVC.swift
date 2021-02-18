//
//  TabBarVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/18/21.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        
        setUpViewControllers()
    }
    
    func setUpViewControllers() {
        
        // Initialize each tab bar view controller
        let controllers = [add(vc: MenuVC(), name: "Menu", icon: UIImage(named: "menu_icon")!),
                           add(vc: OrdersVC(), name: "Orders", icon: UIImage(named: "orders_icon")!),
                           add(vc: ManageVC(), name: "Manage", icon: UIImage(named: "manage_icon")!),
                           add(vc: AccountVC(), name: "Account", icon: UIImage(named: "account_icon")!)]
        
        // Add all view controllers
        self.viewControllers = controllers
        self.selectedIndex = 0
    }
    
    func add(vc: UIViewController, name: String, icon: UIImage) -> UINavigationController {
        vc.title = name
        vc.tabBarItem = UITabBarItem(title: name, image: icon.withRenderingMode(.alwaysTemplate), selectedImage: nil)
        vc.view.backgroundColor = .vc_background
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        return UINavigationController(rootViewController: vc)
    }
    
}

