//
//  AccountTypeVC.swift
//  BadgerBytes
//
//  Created by Mitch Alley on 2/21/21.
//

import UIKit

class AccountTypeVC: UIViewController{
    
    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        setUpViews()
        //firstNameInputView.input.becomeFirstResponder()
    }
    
    //
    // MARK: Functions
    //
    
    @objc func handleDismiss() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSignUp(sender: UIButton) {
        
        // TODO: set global user account type, probably can store in Firebase
        print("Button tag: ", sender.tag) // 0 = Admin, 1 = Staff, 2 = Customer
        
        var accountType:String
        switch sender.tag {
        case 0:
            accountType = "admin"
        case 1:
            accountType = "staff"
        default:
            accountType = "customer"
        }
        
        let signUpVC = SignUpVC()
        signUpVC.accoutType = accountType
        signUpVC.modalPresentationStyle = .overFullScreen
        self.present(signUpVC, animated: true, completion: nil)
    }
    
    func resetUI() {
        let tabBarVC = UIApplication.shared.keyWindow?.rootViewController as! TabBarVC
        tabBarVC.setUpViewControllers()
        self.view.endEditing(true)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    //
    // MARK: UI Setup
    //
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "auth_background")
        iv.contentMode = .scaleAspectFill
        iv.alpha = 0.6
        return iv
    }()
    
    let containerView = UIView()
    
    let dismissButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "dismiss_btn")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()
    
    let inputBackgroundView: UIView = {
        let vw = UIView()
        vw.backgroundColor = .login_input
        vw.alpha = 0.25
        vw.layer.cornerRadius = 8
        return vw
    }()
    
    let staffBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.tag = 1
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Staff", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
    }()
    
    let adminBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.tag = 0
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Admin", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
    }()
    
    let customerBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.tag = 2
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Customer", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
    }()
    
    let accountTypeLbl: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Select your account type", font: UIFont(regularWithSize: 23), textColor: .main_label)
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var inputStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [accountTypeLbl, adminBtn, staffBtn, customerBtn])
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        return sv
    }()
    
    func setUpViews() {
        
        self.view.backgroundColor = .black
        
        self.containerView.addSubviews(views: [dismissButton, inputBackgroundView, inputStackView])
        self.view.addSubviews(views: [backgroundImageView, containerView])
        
        backgroundImageView.fillSuperview()
        
        containerView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 300)
        
        dismissButton.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 18, heightConstant: 18)
                
        inputBackgroundView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 75, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        inputStackView.anchor(inputBackgroundView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 25, leftConstant: 25, bottomConstant: 0, rightConstant: 25, widthConstant: 0, heightConstant: 170)
    
    }
}
