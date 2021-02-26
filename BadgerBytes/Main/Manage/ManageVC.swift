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
    }
    
    //
    // MARK: Functions
    //
    
    @objc func handleOrders() {
        // remove usage report from container, display order collectionView
        
    }
    
    @objc func handleUsage() {
        
        
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
        btn.backgroundColor = UIColor(hex: "B80000")
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
    
    func setUpViews() {
        
        self.navigationItem.titleView = titleLabel
                
        self.view.addSubviews(views: [btnStackView, containerView])
        
        btnStackView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 40)
        
        containerView.anchor(btnStackView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        self.containerView.addSubviews(views: [manageOrdersView])
        manageOrdersView.fillSuperview()
    
    }

}




