//
//  AccountVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/18/21.
//

import UIKit
import Firebase

class AccountVC: UIViewController {
    
    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        setUpViews()
    }
    
    //
    // MARK: Functions
    //
    
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

    //
    // MARK: UI Setup
    //
    
    let logoutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.add(text: "Logout", font: UIFont(boldWithSize: 17), textColor: UIColor(hex: "565656"))
        btn.backgroundColor = .subtitle_label
        btn.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        btn.layer.cornerRadius = 4
        return btn
    }()

    func setUpViews() {

        self.view.addSubviews(views: [logoutButton])
                
        logoutButton.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 40)
        logoutButton.anchorCenterSuperview()

        

    }

}
