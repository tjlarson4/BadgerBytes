//
//  MenuVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/18/21.
//

import UIKit
import Firebase

class MenuVC: UIViewController {
    
    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        setUpViews()
    }
    
    //
    // MARK: Functions
    //
    var orderNum = 1
    
    @objc func handleStartOrder() {
        // Move to menu screen
        print("Order \(orderNum) started")
        orderNum += 1
    }
    
    func fetchCurrentUser() {
        
        // Checks that there is a current user with an ID
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        
        // Retrieves user info from Firebase
        Database.database().reference().child("Users").child(currentUserID).observeSingleEvent(of: .value) { (snapshot) in
            
            // Creates dictionary of user information, instatiates new User object
            guard let userDict = snapshot.value as? [String: Any] else {return}
            globalCurrentUser = User(uid: currentUserID, dictionary: userDict)
            print(globalCurrentUser)
        }
    }

    //
    // MARK: UI Setup
    //
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "auth_background")
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    let welcomeLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Welcome to...", font: UIFont(regularWithSize: 23), textColor: .main_label)
        lbl.textAlignment = .left
        return lbl
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "BadgerBytes", font: UIFont(name: "PingFangHK-Regular", size: 45)!, textColor: .subtitle_label)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let userLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "", font: UIFont(name: "PingFangHK-Regular", size: 23)!, textColor: .subtitle_label)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let startOrderButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.add(text: "Start your order", font: UIFont(boldWithSize: 18), textColor: .subtitle_label)
        btn.layer.borderColor = UIColor.subtitle_label.cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(handleStartOrder), for: .touchUpInside)
        return btn
    }()
    
    func setUpViews() {
        
        fetchCurrentUser()
        
//        self.view.addSubviews(views: [welcomeLabel, titleLabel, userLabel, startOrderButton])
        self.view.addSubviews(views: [scrollView])
        self.scrollView.addSubviews(views: [welcomeLabel, titleLabel, userLabel, startOrderButton])
        
        scrollView.fillSuperview()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 2000)

        welcomeLabel.anchor(scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 40, leftConstant: 20, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 35)
        
        titleLabel.anchor(welcomeLabel.bottomAnchor, left: welcomeLabel.leftAnchor, bottom: nil, right: welcomeLabel.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 60)
        
        startOrderButton.anchor(nil, left: view.leftAnchor, bottom: scrollView.safeAreaLayoutGuide.bottomAnchor, right: scrollView.rightAnchor, topConstant: 200, leftConstant: 30, bottomConstant: 40, rightConstant: 30, widthConstant: 0, heightConstant: 50)
        startOrderButton.anchorCenterXToSuperview()
        
        userLabel.anchor(startOrderButton.bottomAnchor, left: welcomeLabel.leftAnchor, bottom: nil, right: welcomeLabel.rightAnchor, topConstant: 200, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 60)


    }

}
