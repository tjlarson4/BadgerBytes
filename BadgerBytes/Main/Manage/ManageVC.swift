//
//  ManageVC.swift
//  BadgerBytes
//
//  Created by Connor Hanson on 2/18/21.
//

import UIKit
import Firebase

class ManageVC: UIViewController {
        
    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        setUpViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manageOrdersView.fetchOrders()
        updateView(isOrdersHidden: false)
    }
    
    //
    // MARK: Functions
    //
    
    @objc func handleOrders() {
        // remove usage report from container, display order collectionView
        updateView(isOrdersHidden: false)
    }
    
    @objc func handleUsage() {
        
        // ONLY ALLOW ADMIN ACCESS - UNCOMMENT IN FINAL VERSION
//        let accountType = globalCurrentUser?.accountType
//
//        if accountType != "admin" {
//            let alert = UIAlertController(title: "Need Admin access!", message: "Logout and create a new Admin account", preferredStyle: .alert)
//
//            self.present(alert, animated: true, completion: nil)
//
//            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//        } else {
//            updateView(isOrdersHidden: true)
//        }
        
        updateView(isOrdersHidden: true)
    }
    
    func updateView(isOrdersHidden: Bool) {
        manageOrdersView.isHidden = isOrdersHidden
        usageReportView.isHidden = !isOrdersHidden
        
        ordersButton.backgroundColor = !isOrdersHidden ? .cred : .subtitle_label
        ordersButton.titleLabel?.textColor = !isOrdersHidden ? .white : UIColor(hex: "565656")

        usageButton.backgroundColor = isOrdersHidden ? .cred : .subtitle_label
        usageButton.titleLabel?.textColor = isOrdersHidden ? .white : UIColor(hex: "565656")

        self.view.layoutSubviews()
    }
    
    //
    // MARK: UI Setup
    //
    
    lazy var ordersButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = UIColor(hex: "B80000")
        btn.add(text: "Orders", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "FFFFFF"))
        btn.addTarget(self, action: #selector(handleOrders), for: .touchUpInside)
        return btn
    }()
    
    lazy var usageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Usage", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "FFFFFF"))
        btn.addTarget(self, action: #selector(handleUsage), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [ordersButton, usageButton])
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.spacing = 10
        return sv
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Manage", font: UIFont(name: "PingFangHK-Regular", size: 21)!, textColor: .black)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let containerView = UIView()
    
    let manageOrdersView = ManageOrdersView()
    let usageReportView = UsageReportView()
    
    func setUpViews() {
        
        self.navigationItem.titleView = titleLabel
        
        manageOrdersView.manageVC = self
                
        self.view.addSubviews(views: [btnStackView, containerView])
        
        btnStackView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 40)
        
        containerView.anchor(btnStackView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        self.containerView.addSubviews(views: [manageOrdersView, usageReportView])
        manageOrdersView.fillSuperview()
        usageReportView.fillSuperview()
        
        
    
    }

}




