//
//  MenuVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/18/21.
//

import UIKit
//test - Mitch
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
    
    @objc func handleStartOrder() {
        
        
    }

    //
    // MARK: UI Setup
    //
    
    let containerView = UIView()
    
    let welcomeLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Welcome to...", font: UIFont(regularWithSize: 23), textColor: .main_label)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "BadgerBytes", font: UIFont(name: "PingFangHK-Regular", size: 45)!, textColor: .subtitle_label)
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
        
        self.view.addSubviews(views: [containerView, welcomeLabel, titleLabel, startOrderButton])
        
        containerView.backgroundColor = .red
        
        containerView.anchor(nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 500)
        containerView.anchorCenterYToSuperview()

                

    }

}
